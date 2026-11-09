import 'package:expogeo/features/admin/login/presentation/components/login_brand_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../support/semantics.dart';

void main() {
  Future<void> pump(WidgetTester tester, {bool compact = false}) async {
    tester.view.physicalSize = Size(compact ? 390 : 1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/admin',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Text('Página inicial')),
        GoRoute(
          path: '/admin',
          builder: (context, state) => Scaffold(body: LoginBrandPanel(compact: compact)),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  const lead = 'Cadastre, revise e organize os objetos digitais de cada tema e subtema.';
  const noAccess = 'Sem acesso? Peça a quem administra o painel para criar seu usuário.';

  testWidgets('coluna inteira tem rótulo, título, apoio e o pé', (tester) async {
    await pump(tester);

    expect(find.text('PAINEL DA CURADORIA'), findsOneWidget);
    expect(find.text('Cuide da curadoria da expoGEO.'), findsOneWidget);
    expect(find.text(lead), findsOneWidget);
    expect(find.text(noAccess), findsOneWidget);
    expect(find.bySemanticsLabel('expoGEO, página inicial'), findsOneWidget);
  });

  testWidgets('faixa compacta esconde o apoio e o pé', (tester) async {
    await pump(tester, compact: true);

    expect(find.text('PAINEL DA CURADORIA'), findsOneWidget);
    expect(find.text('Cuide da curadoria da expoGEO.'), findsOneWidget);
    expect(find.text(lead), findsNothing);
    expect(find.text(noAccess), findsNothing);
  });

  testWidgets('título marcado como cabeçalho', (tester) async {
    await pump(tester);
    expectHeading(tester, find.text('Cuide da curadoria da expoGEO.'), 1);
  });

  testWidgets('a marca leva à página inicial', (tester) async {
    await pump(tester);

    await tester.tap(find.bySemanticsLabel('expoGEO, página inicial'));
    await tester.pumpAndSettle();
    expect(find.text('Página inicial'), findsOneWidget);
  });
}
