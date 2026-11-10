import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/utils/string/string_utils.dart';

enum PanelView { objects, themes }

/// Filtros de "Objetos digitais" lidos do endereço.
class PanelSelection {
  const PanelSelection({this.theme, this.subtheme, this.type, this.query});

  final ThemeEnum? theme;
  final SubthemeEnum? subtheme;
  final ContentType? type;
  final String? query;

  /// Cada valor desconhecido é ignorado sozinho. Subtema fora da lista do site, de outro tema ou
  /// sem tema também; tipo só pelo nome (`video`, não `Vídeo`); busca em branco vira nula.
  factory PanelSelection.fromQuery(Map<String, String> query) {
    final theme = _themeByValue[query[PanelAddress.themeParam]];
    final subtheme = _listedSubthemeByValue[query[PanelAddress.subthemeParam]];
    final text = query[PanelAddress.queryParam]?.trim();
    return PanelSelection(
      theme: theme,
      subtheme: theme != null && subtheme?.theme == theme ? subtheme : null,
      type: _typeByName[query[PanelAddress.typeParam]],
      query: text == null || text.isEmpty ? null : text,
    );
  }

  bool get hasNarrowingFilter => subtheme != null || type != null || query != null;

  @override
  bool operator ==(Object other) =>
      other is PanelSelection &&
      other.theme == theme &&
      other.subtheme == subtheme &&
      other.type == type &&
      other.query == query;

  @override
  int get hashCode => Object.hash(theme, subtheme, type, query);

  static final Map<String, ContentType> _typeByName = {
    for (final type in ContentType.values) type.name: type,
  };

  static final Map<String, ThemeEnum> _themeByValue = {
    for (final theme in ThemeEnum.values) theme.value: theme,
  };

  static final Map<String, SubthemeEnum> _listedSubthemeByValue = {
    for (final theme in ThemeDataModel.themes)
      for (final subtheme in theme.subthemes) subtheme.type.value: subtheme.type,
  };
}

class PanelAddress {
  const PanelAddress._();

  static const String themeParam = 'tema';
  static const String subthemeParam = 'subtema';

  static const String typeParam = 'tipo';
  static const String queryParam = 'q';

  static String objectsOf({
    ThemeEnum? theme,
    SubthemeEnum? subtheme,
    ContentType? type,
    String? query,
  }) {
    final text = query?.trim() ?? '';
    final parameters = {
      if (theme != null) themeParam: theme.value,
      if (theme != null && subtheme != null && subtheme.theme == theme)
        subthemeParam: subtheme.value,
      if (type != null) typeParam: type.name,
      if (text.isNotEmpty) queryParam: text,
    };
    if (parameters.isEmpty) return AppRouter.adminPanelObjects;
    return Uri(path: AppRouter.adminPanelObjects, queryParameters: parameters).toString();
  }

  static String objectsWith(PanelSelection selection) => objectsOf(
    theme: selection.theme,
    subtheme: selection.subtheme,
    type: selection.type,
    query: selection.query,
  );

  /// Editor de objeto novo, já com o tema e o subtema quando houver.
  static String newObject({ThemeEnum? theme, SubthemeEnum? subtheme}) {
    final parameters = {
      if (theme != null) themeParam: theme.value,
      if (theme != null && subtheme != null && subtheme.theme == theme)
        subthemeParam: subtheme.value,
    };
    if (parameters.isEmpty) return AppRouter.adminObjectNew;
    return Uri(path: AppRouter.adminObjectNew, queryParameters: parameters).toString();
  }

  /// Editor do objeto, com o código em minúsculas e hífen, como no site.
  static String editObject(String code) =>
      AppRouter.adminObjectEdit.replaceFirst(':${AppRouter.codeParam}', referenceCodeSlug(code));

  static PanelView? viewOf(String path) => switch (path) {
    AppRouter.adminPanelObjects => PanelView.objects,
    AppRouter.adminPanelThemes => PanelView.themes,
    _ => null,
  };

  static String of(PanelView view) => switch (view) {
    PanelView.objects => AppRouter.adminPanelObjects,
    PanelView.themes => AppRouter.adminPanelThemes,
  };
}

/// Até duas letras do que vem antes do `@`: a inicial de cada uma das duas primeiras partes
/// quando há `.`, `_` ou `-`; sem separador, as duas primeiras letras.
String initialsOf(String email) {
  final local = email.split('@').first.trim();
  final parts = local.split(RegExp(r'[._-]+')).where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    final word = parts.first;
    return word.substring(0, word.length < 2 ? word.length : 2).toUpperCase();
  }
  return (parts[0][0] + parts[1][0]).toUpperCase();
}
