import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/features/about/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/semantics.dart';

void main() {
  // O roteador do app consulta o Firebase no redirecionamento; aqui entra só a rota dele.
  GoRoute routeOf(String path) => AppRouter.router.configuration.routes
      .whereType<GoRoute>()
      .firstWhere((route) => route.path == path);

  testWidgets('/sobre abre a página Sobre com o item da navbar marcado', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(initialLocation: AppRouter.about, routes: [routeOf(AppRouter.about)]);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.byType(AboutPage), findsOneWidget);
    final item = tester.getSemantics(find.bySemanticsLabel('Sobre')).getSemanticsData();
    expect(item.flagsCollection.isLink, isTrue);
    expect(isMarked(item), isTrue);
  });
}
