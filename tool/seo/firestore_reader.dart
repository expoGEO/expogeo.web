import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';

/// Falha que deve interromper o deploy, com a causa em português.
class SeoException implements Exception {
  const SeoException(this.message);

  final String message;

  @override
  String toString() => message;
}

typedef JsonGetter = Future<Map<String, dynamic>> Function(Uri uri);

/// Lê os objetos pela API REST pública do Firestore, percorrendo tema, subtema e conteúdos.
/// O percurso funciona tanto com as regras antigas quanto com as novas e não usa credencial.
class FirestoreReader {
  FirestoreReader({
    required this.projectId,
    required this.apiKey,
    JsonGetter? getJson,
    this.attempts = 3,
    this.retryDelay = const Duration(seconds: 2),
  }) : _getJson = getJson ?? _httpGetJson;

  final String projectId;
  final String apiKey;
  final int attempts;
  final Duration retryDelay;
  final JsonGetter _getJson;

  Future<CatalogModel> fetchCatalog() async => strictCatalog(await fetchRecords());

  Future<List<CatalogRecord>> fetchRecords() async {
    final themes = await _list('themes');
    if (themes.isEmpty) throw SeoException('O Firestore de $projectId não tem nenhum tema.');

    final records = <CatalogRecord>[];
    for (final theme in themes) {
      for (final subtheme in await _list('${theme.path}/subthemes')) {
        for (final content in await _list('${subtheme.path}/contents')) {
          records.add(CatalogRecord(path: content.path, id: content.id, data: content.data));
        }
      }
    }
    return records;
  }

  Future<List<_Doc>> _list(String collection) async {
    final docs = <_Doc>[];
    String? token;
    do {
      final uri = Uri.https(
        'firestore.googleapis.com',
        '/v1/projects/$projectId/databases/(default)/documents/$collection',
        {'pageSize': '300', 'key': apiKey, if (token != null) 'pageToken': token},
      );
      final page = await _withRetries(() => _getJson(uri), collection);
      for (final raw in (page['documents'] as List?) ?? const []) {
        docs.add(_Doc.fromJson(raw as Map<String, dynamic>));
      }
      token = page['nextPageToken'] as String?;
    } while (token != null && token.isNotEmpty);
    return docs;
  }

  Future<T> _withRetries<T>(Future<T> Function() action, String what) async {
    Object? last;
    for (var attempt = 1; attempt <= attempts; attempt++) {
      try {
        return await action();
      } catch (error) {
        last = error;
        if (attempt < attempts) await Future<void>.delayed(retryDelay);
      }
    }
    throw SeoException('Não foi possível ler "$what" do Firestore de $projectId: $last');
  }

  static Future<Map<String, dynamic>> _httpGetJson(Uri uri) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
    try {
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 30));
      final response = await request.close().timeout(const Duration(seconds: 30));
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw SeoException('HTTP ${response.statusCode}');
      }
      return jsonDecode(body) as Map<String, dynamic>;
    } finally {
      client.close(force: true);
    }
  }
}

/// Monta o catálogo como o app, mas recusando qualquer objeto dos subtemas do site que não
/// converta: uma página incompleta não pode ir ao ar sem que alguém saiba.
CatalogModel strictCatalog(List<CatalogRecord> records) {
  final problems = <String>[];
  var listed = 0;
  for (final record in records) {
    final segments = record.path.split('/');
    if (segments.length != 6 || segments[0] != 'themes') continue;
    if (!_isListed(segments[1], segments[3])) continue;
    listed++;
    try {
      ContentResponseModel.fromJson(record.data, record.id);
    } catch (error) {
      problems.add('${record.path}: $error');
    }
  }
  if (problems.isNotEmpty) {
    throw SeoException('Objetos que não convertem:\n  ${problems.join('\n  ')}');
  }
  if (listed == 0) throw const SeoException('O Firestore não devolveu nenhum objeto do site.');
  return CatalogModel.fromRecords(records);
}

bool _isListed(String themeId, String subthemeId) => ThemeDataModel.themes.any(
  (theme) =>
      theme.type.id == themeId && theme.subthemes.any((subtheme) => subtheme.type.id == subthemeId),
);

class _Doc {
  const _Doc({required this.path, required this.id, required this.data});

  factory _Doc.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final path = name.split('/documents/').last;
    final fields = (json['fields'] as Map<String, dynamic>?) ?? const {};
    return _Doc(path: path, id: path.split('/').last, data: _decodeFields(fields));
  }

  final String path;
  final String id;
  final Map<String, dynamic> data;
}

Map<String, dynamic> _decodeFields(Map<String, dynamic> fields) => {
  for (final entry in fields.entries) entry.key: _decode(entry.value as Map<String, dynamic>),
};

Object? _decode(Map<String, dynamic> value) {
  final type = value.keys.first;
  final raw = value[type];
  return switch (type) {
    'nullValue' => null,
    'booleanValue' || 'stringValue' || 'timestampValue' => raw,
    'integerValue' => int.parse(raw as String),
    'doubleValue' => raw is num ? raw.toDouble() : double.parse(raw as String),
    'mapValue' => _decodeFields(
      ((raw as Map<String, dynamic>)['fields'] as Map<String, dynamic>?) ?? const {},
    ),
    'arrayValue' => [
      for (final item in ((raw as Map<String, dynamic>)['values'] as List?) ?? const [])
        _decode(item as Map<String, dynamic>),
    ],
    _ => raw,
  };
}
