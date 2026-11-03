import 'package:flutter_test/flutter_test.dart';

/// Confere que o texto encontrado é um título do nível dado.
void expectHeading(WidgetTester tester, Finder finder, int level) {
  final data = tester.getSemantics(finder).getSemanticsData();
  expect(data.flagsCollection.isHeader, isTrue);
  expect(data.headingLevel, level);
}
