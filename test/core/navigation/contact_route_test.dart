import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/features/contact/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  // O roteador do app consulta o Firebase no redirecionamento; aqui entra só a rota dele.
  GoRoute routeOf(String path) => AppRouter.router.configuration.routes
      .whereType<GoRoute>()
      .firstWhere((route) => route.path == path);

  testWidgets('/contato abre a página de contato com o item da navbar marcado', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: AppRouter.contact,
      routes: [routeOf(AppRouter.contact)],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.byType(ContactPage), findsOneWidget);
    final item = tester.getSemantics(find.bySemanticsLabel('Contato').first).getSemanticsData();
    expect(item.flagsCollection.isLink, isTrue);
    expect(item.flagsCollection.isSelected, isTrue);
  });
}
