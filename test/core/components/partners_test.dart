import 'package:expogeo/core/components/partners/partner_logo.dart';
import 'package:expogeo/core/components/partners/partners_section.dart';
import 'package:expogeo/core/models/partner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/failing_asset_bundle.dart';
import '../../support/fake_url_launcher.dart';
import '../../support/semantics.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    double width = 1280,
    bool disableAnimations = false,
    AssetBundle? bundle,
  }) {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Widget child = const Scaffold(body: SingleChildScrollView(child: PartnersSection()));
    if (bundle != null) child = DefaultAssetBundle(bundle: bundle, child: child);

    return tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 1600), disableAnimations: disableAnimations),
          child: child,
        ),
      ),
    );
  }

  double topOf(WidgetTester tester, Partner partner) =>
      tester.getTopLeft(find.byWidgetPredicate((w) => w is PartnerLogo && w.partner == partner)).dy;

  testWidgets('seis links com o nome completo e o aviso de nova aba', (tester) async {
    await pump(tester);

    expect(find.text('Realização e apoio'), findsOneWidget);
    expect(find.byType(PartnerLogo), findsNWidgets(6));
    for (final partner in Partner.values) {
      expect(find.bySemanticsLabel('${partner.fullName}, abre em nova aba'), findsOneWidget);
    }
    expectHeading(tester, find.text('Realização e apoio'), 2);
  });

  testWidgets('toque abre o site da instituição', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);

    await tester.tap(find.byWidgetPredicate((w) => w is PartnerLogo && w.partner == Partner.capes));
    await tester.pumpAndSettle();
    expect(opened, ['https://www.gov.br/capes']);
  });

  testWidgets('foco por teclado tira o cinza e sobe o logo', (tester) async {
    await pump(tester);
    expect(find.byType(ColorFiltered), findsNWidgets(6));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    expect(find.byType(ColorFiltered), findsNWidgets(5));
    final lifted = tester
        .widgetList<Transform>(
          find.descendant(of: find.byType(PartnerLogo), matching: find.byType(Transform)),
        )
        .where((t) => t.transform.getTranslation().y < 0);
    expect(lifted, isNotEmpty);
  });

  testWidgets('com reduzir movimento acende sem subir nem crescer', (tester) async {
    await pump(tester, disableAnimations: true);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    expect(find.byType(ColorFiltered), findsNWidgets(5));
    final transforms = tester.widgetList<Transform>(
      find.descendant(of: find.byType(PartnerLogo), matching: find.byType(Transform)),
    );
    for (final transform in transforms) {
      expect(transform.transform.isIdentity(), isTrue);
    }
  });

  testWidgets('imagem que falha mostra a sigla e mantém o link', (tester) async {
    await pump(tester, bundle: FailingImageBundle());
    await tester.pumpAndSettle();

    for (final partner in Partner.values) {
      expect(find.text(partner.acronym), findsOneWidget);
      expect(find.bySemanticsLabel('${partner.fullName}, abre em nova aba'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  for (final (width, columns) in [(390.0, 2), (768.0, 3), (1280.0, 6)]) {
    testWidgets('$columns colunas em ${width.toInt()} px', (tester) async {
      await pump(tester, width: width);

      final firstRow = Partner.values.where((p) => topOf(tester, p) == topOf(tester, Partner.ufu));
      expect(firstRow.length, columns);
      expect(tester.takeException(), isNull);
    });
  }
}
