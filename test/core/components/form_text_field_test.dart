import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/core/components/form/marked_text.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkedText', () {
    testWidgets('trecho marcado sai em peso 700 e o resto, normal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MarkedText(
            'Aperte **Enviar** por lá.',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      );

      final root = tester.widget<RichText>(find.byType(RichText)).text;
      final marked = (root as TextSpan).children!.single as TextSpan;
      final spans = marked.children!.cast<TextSpan>();
      expect(root.toPlainText(), 'Aperte Enviar por lá.');
      expect(spans[1].text, 'Enviar');
      expect(spans[1].style?.fontWeight, FontWeight.w700);
      expect(spans[0].style?.fontWeight, isNull);
    });

    testWidgets('texto sem marca fica intacto', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MarkedText('Sem marca', style: TextStyle())));

      expect(find.text('Sem marca', findRichText: true), findsOneWidget);
    });
  });

  group('FormTextField', () {
    late TextEditingController controller;
    late FocusNode focusNode;
    final formKey = GlobalKey<FormState>();

    setUp(() {
      controller = TextEditingController();
      focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);
    });

    Future<void> pump(
      WidgetTester tester, {
      bool multiline = false,
      double width = 1280,
      bool obscureText = false,
      Widget? suffix,
      String? hintText,
    }) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: FormTextField(
                label: 'Nome',
                controller: controller,
                focusNode: focusNode,
                multiline: multiline,
                obscureText: obscureText,
                suffix: suffix,
                hintText: hintText,
                validator: (value) => (value ?? '').isEmpty ? 'Escreva seu nome.' : null,
              ),
            ),
          ),
        ),
      );
    }

    Color borderColor(WidgetTester tester) {
      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration! as BoxDecoration;
      return (decoration.border! as Border).top.color;
    }

    double fieldHeight(WidgetTester tester) => tester.getSize(find.byType(TextField)).height;

    testWidgets('rótulo visível e nome acessível iguais, sem nó solto', (tester) async {
      await pump(tester);

      expect(find.text('Nome'), findsOneWidget);
      expect(find.bySemanticsLabel('Nome'), findsOneWidget);
      final data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
      expect(data.label, 'Nome');
      expect(data.validationResult, isNot(SemanticsValidationResult.invalid));
    });

    testWidgets('borda muda no foco e no erro', (tester) async {
      await pump(tester);
      expect(borderColor(tester), AppTheme.colors.fieldBorder);

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(borderColor(tester), AppTheme.colors.accent);

      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(borderColor(tester), AppTheme.colors.error);
    });

    testWidgets('erro abaixo do campo, na cor de erro e ligado a ele', (tester) async {
      await pump(tester);
      expect(find.text('Escreva seu nome.'), findsNothing);

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      final error = find.text('Escreva seu nome.');
      expect(tester.widget<Text>(error).style?.color, AppTheme.colors.error);
      expect(
        tester.getTopLeft(error).dy,
        greaterThan(tester.getBottomLeft(find.byType(TextField)).dy),
      );

      final data = tester.getSemantics(find.byType(TextField)).getSemanticsData();
      expect(data.label, 'Nome. Escreva seu nome.');
      expect(data.validationResult, SemanticsValidationResult.invalid);
    });

    testWidgets('uma linha fica em uma linha', (tester) async {
      await pump(tester);
      expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 1);
      expect(tester.getSize(find.byType(AnimatedContainer)).height, 48);
    });

    testWidgets('mensagem vai de 6 a 12 linhas e Enter quebra linha', (tester) async {
      await pump(tester, multiline: true);

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.textInputAction, TextInputAction.newline);
      expect(field.keyboardType, TextInputType.multiline);
      final empty = fieldHeight(tester);

      controller.text = List.filled(9, 'linha').join('\n');
      await tester.pump();
      final nine = fieldHeight(tester);
      expect(nine, greaterThan(empty));

      controller.text = List.filled(40, 'linha').join('\n');
      await tester.pump();
      final many = fieldHeight(tester);
      expect(many, greaterThan(nine));

      controller.text = List.filled(80, 'linha').join('\n');
      await tester.pump();
      expect(fieldHeight(tester), many);
    });

    testWidgets('sem overflow em 320 com texto e erro longos', (tester) async {
      await pump(tester, width: 320);
      controller.text = 'x' * 400;
      await tester.pump();
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('senha fica oculta e sem sugestões nem autocorreção', (tester) async {
      await pump(tester, obscureText: true);

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);
      expect(field.enableSuggestions, isFalse);
      expect(field.autocorrect, isFalse);
    });

    testWidgets('sufixo fica dentro da caixa, à direita, e recebe o foco depois do campo', (
      tester,
    ) async {
      final suffixFocus = FocusNode();
      addTearDown(suffixFocus.dispose);
      await pump(
        tester,
        suffix: Focus(
          focusNode: suffixFocus,
          child: const SizedBox.square(key: Key('sufixo'), dimension: 44),
        ),
      );

      final box = tester.getRect(find.byType(AnimatedContainer));
      final suffix = tester.getRect(find.byKey(const Key('sufixo')));
      expect(box.contains(suffix.center), isTrue);
      expect(suffix.left, greaterThan(tester.getRect(find.byType(TextField)).right - 1));
      expect(tester.getSize(find.byType(AnimatedContainer)).height, 48);

      focusNode.requestFocus();
      await tester.pump();
      focusNode.nextFocus();
      await tester.pump();
      expect(suffixFocus.hasFocus, isTrue);
    });

    testWidgets('dica aparece dentro do campo vazio', (tester) async {
      await pump(tester, hintText: 'nome@exemplo.com');

      final hint = find.text('nome@exemplo.com');
      expect(hint, findsOneWidget);
      expect(
        tester.getRect(find.byType(AnimatedContainer)).contains(tester.getCenter(hint)),
        isTrue,
      );
      expect(tester.widget<Text>(hint).style?.color, AppTheme.colors.inkSecondary);
    });

    testWidgets('sem overflow em 320 com sufixo, texto e erro longos', (tester) async {
      await pump(
        tester,
        width: 320,
        suffix: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      );
      controller.text = 'x' * 400;
      await tester.pump();
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
