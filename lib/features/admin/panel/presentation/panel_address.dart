import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';

enum PanelView { objects, themes }

/// Tema e subtema escolhidos pelo endereço de "Objetos digitais".
class PanelSelection {
  const PanelSelection({this.theme, this.subtheme});

  final ThemeEnum? theme;
  final SubthemeEnum? subtheme;

  /// Tema desconhecido é ignorado; subtema desconhecido, fora da lista do site ou de outro tema
  /// também, ficando só o tema.
  factory PanelSelection.fromQuery(Map<String, String> query) {
    final theme = _themeByValue[query[PanelAddress.themeParam]];
    if (theme == null) return const PanelSelection();

    final subtheme = _listedSubthemeByValue[query[PanelAddress.subthemeParam]];
    if (subtheme == null || subtheme.theme != theme) return PanelSelection(theme: theme);
    return PanelSelection(theme: theme, subtheme: subtheme);
  }

  @override
  bool operator ==(Object other) =>
      other is PanelSelection && other.theme == theme && other.subtheme == subtheme;

  @override
  int get hashCode => Object.hash(theme, subtheme);

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

  static String objectsOf({ThemeEnum? theme, SubthemeEnum? subtheme}) {
    if (theme == null) return AppRouter.adminPanelObjects;
    return Uri(
      path: AppRouter.adminPanelObjects,
      queryParameters: {
        themeParam: theme.value,
        if (subtheme != null && subtheme.theme == theme) subthemeParam: subtheme.value,
      },
    ).toString();
  }

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
