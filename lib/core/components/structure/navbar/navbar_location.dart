import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum NavbarSection { themes, about, contact }

class NavbarLocation {
  const NavbarLocation({this.section, this.theme});

  /// Na página de erro não há `GoRouterState`, então usa o endereço do roteador.
  factory NavbarLocation.of(BuildContext context) {
    final scoped = context.dependOnInheritedWidgetOfExactType<NavbarLocationScope>();
    if (scoped != null) return scoped.location;
    try {
      return NavbarLocation.fromUri(GoRouterState.of(context).uri);
    } catch (_) {
      return NavbarLocation.fromUri(GoRouter.of(context).routeInformationProvider.value.uri);
    }
  }

  factory NavbarLocation.fromUri(Uri uri) {
    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
    if (segments.isEmpty) return const NavbarLocation();

    final first = segments.first;
    for (final theme in ThemeEnum.values) {
      if (theme.value == first) return NavbarLocation(section: NavbarSection.themes, theme: theme);
    }

    return switch (first) {
      'sobre' => const NavbarLocation(section: NavbarSection.about),
      'contato' => const NavbarLocation(section: NavbarSection.contact),
      _ => const NavbarLocation(),
    };
  }

  final NavbarSection? section;

  final ThemeEnum? theme;
}

/// Fixa a seção ativa da navbar abaixo dele, em vez de deduzi-la do endereço.
class NavbarLocationScope extends InheritedWidget {
  const NavbarLocationScope({super.key, required this.location, required super.child});

  /// Nenhum item ativo, para páginas que não estão no menu mesmo sob um endereço de tema.
  const NavbarLocationScope.none({super.key, required super.child})
    : location = const NavbarLocation();

  final NavbarLocation location;

  @override
  bool updateShouldNotify(NavbarLocationScope oldWidget) =>
      oldWidget.location.section != location.section || oldWidget.location.theme != location.theme;
}
