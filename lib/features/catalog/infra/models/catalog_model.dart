import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';

/// Documento como veio do Firestore, antes de virar objeto do catálogo.
class CatalogRecord {
  const CatalogRecord({required this.path, required this.id, required this.data});

  final String path;
  final String id;
  final Map<String, dynamic> data;
}

class CatalogItem {
  const CatalogItem({required this.theme, required this.subtheme, required this.content});

  final ThemeEnum theme;
  final SubthemeEnum subtheme;
  final ContentResponseModel content;
}

/// Todos os objetos do acervo, com tema e subtema tirados do caminho do documento.
class CatalogModel {
  CatalogModel._(this.items)
    : _byTheme = _countBy(items, (item) => item.theme),
      _bySubtheme = _countBy(items, (item) => item.subtheme);

  factory CatalogModel.fromRecords(Iterable<CatalogRecord> records) {
    final items = <CatalogItem>[];
    for (final record in records) {
      final item = _parse(record);
      if (item != null) items.add(item);
    }
    return CatalogModel._(List.unmodifiable(items));
  }

  final List<CatalogItem> items;
  final Map<ThemeEnum, int> _byTheme;
  final Map<SubthemeEnum, int> _bySubtheme;

  int get total => items.length;

  int countByTheme(ThemeEnum theme) => _byTheme[theme] ?? 0;

  int countBySubtheme(SubthemeEnum subtheme) => _bySubtheme[subtheme] ?? 0;

  static CatalogItem? _parse(CatalogRecord record) {
    final segments = record.path.split('/');
    if (segments.length != 6 ||
        segments[0] != 'themes' ||
        segments[2] != 'subthemes' ||
        segments[4] != 'contents') {
      return null;
    }

    final theme = _themeById[segments[1]];
    final subtheme = _subthemeById[segments[3]];
    if (theme == null || subtheme == null) return null;

    // Subtemas fora da lista do tema (como Movimentos da Terra) não aparecem no site.
    final listed = ThemeDataModel.themes.any(
      (model) => model.type == theme && model.subthemes.any((sub) => sub.type == subtheme),
    );
    if (!listed) return null;

    try {
      final content = ContentResponseModel.fromJson(record.data, record.id);
      return CatalogItem(theme: theme, subtheme: subtheme, content: content);
    } catch (_) {
      return null;
    }
  }

  static final Map<String, ThemeEnum> _themeById = {
    for (final theme in ThemeEnum.values) theme.id: theme,
  };

  static final Map<String, SubthemeEnum> _subthemeById = {
    for (final subtheme in SubthemeEnum.values) subtheme.id: subtheme,
  };

  static Map<K, int> _countBy<K>(List<CatalogItem> items, K Function(CatalogItem) key) {
    final counts = <K, int>{};
    for (final item in items) {
      counts.update(key(item), (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }
}
