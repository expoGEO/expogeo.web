import 'package:expogeo/core/navigation/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Pedido de rolagem até uma seção da Home, sem rota própria para a seção.
class HomeSections {
  const HomeSections._();

  /// Fica verdadeiro até a Home atender o pedido, que pode chegar antes de ela ser montada.
  static final ValueNotifier<bool> themesRequested = ValueNotifier(false);

  static void openThemes(BuildContext context) {
    themesRequested.value = true;
    GoRouter.of(context).go(AppRouter.home);
  }
}
