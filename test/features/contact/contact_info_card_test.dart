import 'package:expogeo/core/components/button/inline_link.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/features/contact/components/contact_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_url_launcher.dart';
import '../../support/semantics.dart';

void main() {
  Future<void> pump(WidgetTester tester) {
    return tester.pumpWidget(const MaterialApp(home: Scaffold(body: ContactInfoCard())));
  }

  testWidgets('título h2, rótulos e endereço igual ao do rodapé', (tester) async {
    await pump(tester);

    expectHeading(tester, find.text('Outros meios'), 2);
    expect(find.text('E-MAIL'), findsOneWidget);
    expect(find.text('ENDEREÇO'), findsOneWidget);
    expect(find.text('OBSERVATÓRIO'), findsOneWidget);
    expect(find.bySemanticsLabel('Endereço'), findsOneWidget);
    expect(find.text(AppLinks.address.join('\n')), findsOneWidget);
  });

  testWidgets('o e-mail abre pelo mailto:', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);

    await tester.tap(find.text(AppLinks.email));
    await tester.pumpAndSettle();

    expect(opened, [AppLinks.emailUrl]);
  });

  testWidgets('o Observatório mostra o domínio e avisa a nova aba', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);

    expect(tester.widget<InlineLink>(find.byType(InlineLink).last).url, AppLinks.observatory);
    expect(
      find.bySemanticsLabel('observatoriogeohistoria.net.br, abre em nova aba'),
      findsOneWidget,
    );

    await tester.tap(find.text('observatoriogeohistoria.net.br'));
    await tester.pumpAndSettle();

    expect(opened, [AppLinks.observatory]);
  });
}
