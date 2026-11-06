import 'package:expogeo/core/components/button/inline_link.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_url_launcher.dart';

void main() {
  Future<void> pump(WidgetTester tester, InlineLink link) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: link)),
      ),
    );
  }

  testWidgets('abre o mailto: pelo clique', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester, const InlineLink(text: 'a@b.com', url: 'mailto:a@b.com'));

    await tester.tap(find.text('a@b.com'));
    await tester.pumpAndSettle();

    expect(opened, ['mailto:a@b.com']);
  });

  testWidgets('nome acessível próprio, com um só nó focável e marcado como link', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const InlineLink(
        text: 'exemplo.org',
        url: 'https://exemplo.org/',
        semanticLabel: 'exemplo.org, abre em nova aba',
      ),
    );

    final node = tester.getSemantics(find.bySemanticsLabel('exemplo.org, abre em nova aba'));
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.linkUrl, Uri.parse('https://exemplo.org/'));
    expect(data.hasAction(SemanticsAction.focus), isTrue);
    expect(node.childrenCount, 0);
    expect(find.bySemanticsLabel('exemplo.org'), findsNothing);
    handle.dispose();
  });

  testWidgets('Enter pelo teclado abre, e o texto fica em laranja forte sublinhado', (
    tester,
  ) async {
    final opened = fakeUrlLauncher();
    await pump(tester, const InlineLink(text: 'a@b.com', url: 'mailto:a@b.com'));

    final text = tester.widget<Text>(find.text('a@b.com'));
    expect(text.style?.color, AppTheme.colors.accentStrong);
    expect(text.style?.decoration, TextDecoration.underline);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(opened, ['mailto:a@b.com']);
  });
}
