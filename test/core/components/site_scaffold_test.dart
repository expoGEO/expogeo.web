import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Future<void> pump(WidgetTester tester, Size size, {required double contentHeight}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SiteScaffold(
            slivers: [SliverToBoxAdapter(child: SizedBox(height: contentHeight))],
          ),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('rodapé preenche até a base em página curta', (tester) async {
    await pump(tester, const Size(1280, 1600), contentHeight: 100);

    expect(tester.getBottomLeft(find.byType(Footer)).dy, 1600);
  });

  // A fonte de teste é larga: na largura de conteúdo, o texto do rodapé quebra mais do que na da
  // janela, como a fonte real quebra com texto ampliado.
  for (final width in [1280.0, 1440.0, 1920.0]) {
    testWidgets('rodapé sem overflow em $width com a página cheia', (tester) async {
      await pump(tester, Size(width, 700), contentHeight: 300);

      expect(find.byType(Footer), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
