import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/seo/firestore_reader.dart';
import '../../features/catalog/catalog_test_data.dart';

Map<String, dynamic> _encode(Object? value) => switch (value) {
  null => {'nullValue': null},
  bool() => {'booleanValue': value},
  int() => {'integerValue': '$value'},
  double() => {'doubleValue': value},
  String() => {'stringValue': value},
  List() => {
    'arrayValue': {
      'values': [for (final item in value) _encode(item)],
    },
  },
  Map() => {
    'mapValue': {
      'fields': {for (final entry in value.entries) '${entry.key}': _encode(entry.value)},
    },
  },
  _ => throw ArgumentError('tipo ${value.runtimeType}'),
};

Map<String, dynamic> _doc(String path, [Map<String, dynamic>? data]) => {
  'name': 'projects/p/databases/(default)/documents/$path',
  if (data != null) 'fields': {for (final e in data.entries) e.key: _encode(e.value)},
};

/// Responde cada coleção pela rota; `token` separa páginas da mesma coleção.
class _FakeFirestore {
  _FakeFirestore(this.pages);

  final Map<String, Map<String, dynamic>> pages;
  final List<Uri> requests = [];
  int failures = 0;

  Future<Map<String, dynamic>> call(Uri uri) async {
    requests.add(uri);
    if (failures > 0) {
      failures--;
      throw 'sem rede';
    }
    final collection = uri.path.split('/documents/').last;
    final key = '$collection${uri.queryParameters['pageToken'] ?? ''}';
    return pages[key] ?? const {};
  }
}

FirestoreReader _reader(_FakeFirestore fake, {int attempts = 3}) => FirestoreReader(
  projectId: 'p',
  apiKey: 'chave',
  getJson: fake.call,
  attempts: attempts,
  retryDelay: Duration.zero,
);

Map<String, Map<String, dynamic>> _tree({Map<String, dynamic>? contentData}) => {
  'themes': {
    'documents': [
      _doc('themes/RE', {'name': 'Representações Espaciais'}),
    ],
  },
  'themes/RE/subthemes': {
    'documents': [_doc('themes/RE/subthemes/RE_HC'), _doc('themes/RE/subthemes/RE_MOT')],
  },
  'themes/RE/subthemes/RE_HC/contents': {
    'documents': [
      _doc('themes/RE/subthemes/RE_HC/contents/RE_HC_01', contentData ?? validContentJson()),
    ],
  },
  'themes/RE/subthemes/RE_MOT/contents': {
    'documents': [_doc('themes/RE/subthemes/RE_MOT/contents/RE_MOT_01', validContentJson())],
  },
};

void main() {
  test('percorre tema, subtema e conteúdos e devolve os documentos como o app os recebe', () async {
    final records = await _reader(_FakeFirestore(_tree())).fetchRecords();

    expect(records.map((r) => r.path), [
      'themes/RE/subthemes/RE_HC/contents/RE_HC_01',
      'themes/RE/subthemes/RE_MOT/contents/RE_MOT_01',
    ]);
    expect(records.first.id, 'RE_HC_01');
    expect(records.first.data, validContentJson());
  });

  test('segue a próxima página de uma coleção', () async {
    final tree = _tree();
    tree['themes/RE/subthemes/RE_HC/contents'] = {
      'documents': [_doc('themes/RE/subthemes/RE_HC/contents/RE_HC_01', validContentJson())],
      'nextPageToken': 'p2',
    };
    tree['themes/RE/subthemes/RE_HC/contentsp2'] = {
      'documents': [_doc('themes/RE/subthemes/RE_HC/contents/RE_HC_02', validContentJson())],
    };

    final records = await _reader(_FakeFirestore(tree)).fetchRecords();

    expect(records.where((r) => r.path.contains('RE_HC')).map((r) => r.id), [
      'RE_HC_01',
      'RE_HC_02',
    ]);
  });

  test('tenta de novo depois de uma falha e desiste na última tentativa', () async {
    final fake = _FakeFirestore(_tree())..failures = 2;
    expect(await _reader(fake).fetchRecords(), isNotEmpty);

    final broken = _FakeFirestore(_tree())..failures = 3;
    await expectLater(
      _reader(broken).fetchRecords(),
      throwsA(isA<SeoException>().having((e) => e.message, 'mensagem', contains('"themes"'))),
    );
  });

  test('sem tema nenhum, falha em vez de seguir com um site vazio', () async {
    await expectLater(
      _reader(_FakeFirestore({})).fetchRecords(),
      throwsA(isA<SeoException>().having((e) => e.message, 'mensagem', contains('nenhum tema'))),
    );
  });

  group('strictCatalog', () {
    test('usa o campo id do documento na rota, mesmo com ID de documento aleatório', () {
      final data = validContentJson()..['id'] = 'RE_HC_06';
      final catalog = strictCatalog([recordAt('RE_HC', 'rp19HOQImcgxVcMrApKc', data: data)]);

      expect(catalog.items.single.route, '/representacoes-espaciais/historia-cartografia/re-hc-06');
    });

    test('ignora subtema fora da lista do site, como o app', () {
      final catalog = strictCatalog([recordAt('RE_HC', 'a'), recordAt('RE_MOT', 'b')]);

      expect(catalog.total, 1);
    });

    test('recusa um objeto que não converte e diz qual é', () {
      final broken = validContentJson()..remove('contentInfo');

      expect(
        () => strictCatalog([recordAt('RE_HC', 'a'), recordAt('RE_HC', 'RE_HC_09', data: broken)]),
        throwsA(isA<SeoException>().having((e) => e.message, 'mensagem', contains('RE_HC_09'))),
      );
    });

    test('recusa quando nenhum objeto do site foi devolvido', () {
      expect(() => strictCatalog([recordAt('RE_MOT', 'a')]), throwsA(isA<SeoException>()));
      expect(() => strictCatalog(const <CatalogRecord>[]), throwsA(isA<SeoException>()));
    });
  });
}
