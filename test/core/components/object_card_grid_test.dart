import 'package:expogeo/core/components/card/object_card_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, double width, int count) async {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ObjectCardGrid(children: [for (var i = 0; i < count; i++) Text('item $i')]),
          ),
        ),
      ),
    );
  }

  for (final (width, columns) in [(390.0, 1), (768.0, 2), (1280.0, 3)]) {
    testWidgets('em $width, $columns por linha', (tester) async {
      await pump(tester, width, 6);

      expect(find.byType(Row), findsNWidgets((6 / columns).ceil()));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('com menos itens que colunas, não estica', (tester) async {
    await pump(tester, 1280, 1);

    final row = tester.widget<Row>(find.byType(Row));
    expect(row.children.whereType<Expanded>(), hasLength(3));
    expect(tester.getSize(find.byType(Expanded).first).width, lessThan(1280 / 2));
  });
}
