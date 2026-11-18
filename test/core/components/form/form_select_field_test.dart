import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/core/components/form/form_select_field.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const options = [
    AppFilterOption<String?>(null, 'Escolha'),
    AppFilterOption<String?>('site', 'Site'),
    AppFilterOption<String?>('video', 'Vídeo'),
  ];

  late GlobalKey<FormState> formKey;
  late FocusNode focusNode;

  setUp(() {
    formKey = GlobalKey<FormState>();
    focusNode = FocusNode();
    addTearDown(focusNode.dispose);
  });

  Future<List<String?>> pump(WidgetTester tester, {String? value, bool optional = false}) async {
    final chosen = <String?>[];
    var current = value;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: StatefulBuilder(
              builder: (context, setState) => FormSelectField<String?>(
                label: 'Tipo',
                options: options,
                value: current,
                focusNode: focusNode,
                optional: optional,
                validator: (value) => value == null ? 'Escolha o tipo.' : null,
                onSelected: (value) {
                  chosen.add(value);
                  setState(() => current = value);
                },
              ),
            ),
          ),
        ),
      ),
    );
    return chosen;
  }

  testWidgets('rótulo visível e nome acessível com o rótulo', (tester) async {
    await pump(tester, value: 'site');

    expect(find.text('Tipo'), findsOneWidget);
    final data = tester.getSemantics(find.bySemanticsLabel('Tipo')).getSemanticsData();
    expect(data.value, 'Site');
  });

  testWidgets('"opcional" entra no nome', (tester) async {
    await pump(tester, optional: true);

    expect(find.bySemanticsLabel('Tipo, opcional'), findsOneWidget);
  });

  testWidgets('escolhe pelo teclado: Enter abre, setas andam, Enter escolhe', (tester) async {
    final chosen = await pump(tester);

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Vídeo'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(chosen, ['site']);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('Esc fecha a lista e devolve o foco', (tester) async {
    await pump(tester);

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Vídeo'), findsNothing);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('erro com borda e texto, lido com o nome; some ao escolher', (tester) async {
    await pump(tester);

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();

    final error = find.text('Escolha o tipo.');
    expect(error, findsOneWidget);
    expect(tester.widget<Text>(error).style?.color, AppTheme.colors.error);
    expect(find.bySemanticsLabel('Tipo. Escolha o tipo.'), findsOneWidget);
    final shape = tester
        .widgetList<Material>(find.byType(Material))
        .map((material) => material.shape)
        .whereType<RoundedRectangleBorder>()
        .last;
    expect(shape.side.color, AppTheme.colors.error);

    await tester.tap(find.text('Escolha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vídeo').last);
    await tester.pumpAndSettle();
    expect(formKey.currentState!.validate(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Escolha o tipo.'), findsNothing);
  });

  testWidgets('altura de campo de formulário em largura total', (tester) async {
    await pump(tester);

    final button = find.descendant(
      of: find.byType(AppFilterSelect<String?>),
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(button).height, AppTheme.dimensions.components.formFieldHeight);
    expect(tester.getSize(button).width, 800);
  });
}
