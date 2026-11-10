import 'package:expogeo/core/components/brand/app_brand.dart';
import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/form/form_error_alert.dart';
import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:expogeo/features/admin/login/presentation/components/login_brand_panel.dart';
import 'package:expogeo/features/admin/login/presentation/components/password_visibility_button.dart';
import 'package:expogeo/features/admin/login/presentation/pages/signin_page.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../support/fake_auth.dart';

void main() {
  late FakeAuthRepository repository;
  late AuthStore store;

  const credentialsMessage = 'E-mail ou senha não conferem. Confira e tente de novo.';

  setUp(() {
    repository = FakeAuthRepository();
    store = AuthStore(repository);
    GetIt.instance.registerSingleton<AuthStore>(store);
  });

  tearDown(() => GetIt.instance.reset());

  Future<void> pump(WidgetTester tester, {double width = 1280, double height = 900}) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/admin',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Text('Página inicial')),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const SignInPage(),
          routes: [GoRoute(path: 'painel', builder: (context, state) => const Text('Painel'))],
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  Finder field(String label) => find.descendant(
    of: find.widgetWithText(FormTextField, label),
    matching: find.byType(TextField),
  );

  final submit = find.widgetWithText(AppButton, 'Entrar');

  Future<void> fill(WidgetTester tester, {String email = '', String password = ''}) async {
    await tester.enterText(field('E-mail'), email);
    await tester.enterText(field('Senha'), password);
    await tester.pump();
  }

  bool hasFocus(WidgetTester tester, String label) =>
      tester.widget<FormTextField>(find.widgetWithText(FormTextField, label)).focusNode.hasFocus;

  testWidgets('textos do login em duas colunas a 1280', (tester) async {
    await pump(tester);

    expect(find.text('Entrar'), findsNWidgets(2));
    expect(
      find.text('Use o e-mail e a senha que a administração cadastrou para você.'),
      findsOneWidget,
    );
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('nome@exemplo.com'), findsOneWidget);
    expect(find.text('Voltar ao site'), findsOneWidget);
    expect(find.text('Cuide da curadoria da expoGEO.'), findsOneWidget);
    expect(
      find.text('Sem acesso? Peça a quem administra o painel para criar seu usuário.'),
      findsOneWidget,
    );

    final brand = tester.getRect(find.byType(LoginBrandPanel));
    final card = tester.getRect(find.byType(Form));
    expect(brand.right, lessThanOrEqualTo(card.left));
    expect(brand.height, 900);
  });

  testWidgets('envio vazio mostra os dois erros, foca o e-mail e não tenta entrar', (tester) async {
    await pump(tester);

    await tester.tap(submit);
    await tester.pump();

    expect(find.text('Escreva o e-mail, como nome@exemplo.com.'), findsOneWidget);
    expect(find.text('Escreva a senha.'), findsOneWidget);
    expect(hasFocus(tester, 'E-mail'), isTrue);
    expect(repository.loginCalls, 0);
  });

  testWidgets('e-mail válido e senha vazia focam a senha', (tester) async {
    await pump(tester);
    await fill(tester, email: ' nome@exemplo.com ');

    await tester.tap(submit);
    await tester.pump();

    expect(find.text('Escreva o e-mail, como nome@exemplo.com.'), findsNothing);
    expect(find.text('Escreva a senha.'), findsOneWidget);
    expect(hasFocus(tester, 'Senha'), isTrue);
    expect(repository.loginCalls, 0);
  });

  testWidgets('erro some quando o campo é corrigido', (tester) async {
    await pump(tester);
    await tester.tap(submit);
    await tester.pump();

    await tester.enterText(field('Senha'), 'x');
    await tester.pump();
    expect(find.text('Escreva a senha.'), findsNothing);
    expect(find.text('Escreva o e-mail, como nome@exemplo.com.'), findsOneWidget);
  });

  testWidgets('qualquer senha não vazia é tentada, com o e-mail aparado', (tester) async {
    await pump(tester);
    await fill(tester, email: ' nome@exemplo.com ', password: 'a');

    await tester.tap(submit);
    await tester.pump();

    expect(repository.emails.single, 'nome@exemplo.com');
    expect(repository.passwords.single, 'a');
    repository.succeed();
    await tester.pumpAndSettle();
  });

  for (final (failure, message) in [
    (const InvalidCredentials() as AuthFailure, credentialsMessage),
    (const WrongPassword(), credentialsMessage),
    (const UserNotFound(), credentialsMessage),
    (const InvalidEmailAddress(), credentialsMessage),
    (const TooManyRequests(), 'Muitas tentativas seguidas. Espere alguns minutos e tente de novo.'),
    (const UserDisabled(), 'Este usuário está desativado. Fale com quem administra o painel.'),
    (const ServerError(), 'Não conseguimos entrar agora. Confira sua conexão e tente de novo.'),
  ]) {
    testWidgets('${failure.runtimeType} mostra a mensagem e mantém os campos', (tester) async {
      await pump(tester);
      await fill(tester, email: 'nome@exemplo.com', password: 'segredo');
      await tester.tap(submit);
      await tester.pump();

      repository.fail(failure);
      await tester.pumpAndSettle();

      expect(find.byType(FormErrorAlert), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(tester.widget<TextField>(field('E-mail')).controller!.text, 'nome@exemplo.com');
      expect(tester.widget<TextField>(field('Senha')).controller!.text, 'segredo');
      final alert = tester.getRect(find.byType(FormErrorAlert));
      expect(alert.bottom, lessThan(tester.getRect(field('E-mail')).top));
    });
  }

  testWidgets('nova tentativa esconde o aviso anterior', (tester) async {
    await pump(tester);
    await fill(tester, email: 'nome@exemplo.com', password: 'segredo');
    await tester.tap(submit);
    await tester.pump();
    repository.fail(const WrongPassword());
    await tester.pumpAndSettle();
    expect(find.byType(FormErrorAlert), findsOneWidget);

    await tester.tap(submit);
    await tester.pump();
    expect(find.byType(FormErrorAlert), findsNothing);
    repository.fail(const WrongPassword());
    await tester.pumpAndSettle();
  });

  testWidgets('durante a tentativa diz "Entrando…" e não aceita outro clique nem Enter', (
    tester,
  ) async {
    await pump(tester);
    await fill(tester, email: 'nome@exemplo.com', password: 'segredo');

    await tester.tap(submit);
    await tester.pump();
    expect(find.text('Entrando…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.text('Entrando…'));
    await tester.pump();
    await tester.showKeyboard(field('Senha'));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(repository.loginCalls, 1);

    repository.fail(const ServerError());
    await tester.pumpAndSettle();
    expect(find.text('Entrando…'), findsNothing);
  });

  testWidgets('Enter no e-mail passa para a senha; Enter na senha envia', (tester) async {
    await pump(tester);
    await tester.showKeyboard(field('E-mail'));
    await tester.enterText(field('E-mail'), 'nome@exemplo.com');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(hasFocus(tester, 'Senha'), isTrue);
    expect(repository.loginCalls, 0);

    await tester.enterText(field('Senha'), 'segredo');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(repository.loginCalls, 1);
    repository.succeed();
    await tester.pumpAndSettle();
  });

  testWidgets('sucesso leva ao painel', (tester) async {
    await pump(tester);
    await fill(tester, email: 'nome@exemplo.com', password: 'segredo');
    await tester.tap(submit);
    await tester.pump();

    repository.succeed();
    await tester.pumpAndSettle();
    expect(find.text('Painel'), findsOneWidget);
  });

  testWidgets('erro antigo da store não aparece ao abrir', (tester) async {
    final future = store.login('nome@exemplo.com', 'x');
    repository.fail(const WrongPassword());
    await future;

    await pump(tester);
    expect(find.byType(FormErrorAlert), findsNothing);
  });

  testWidgets('mostrar senha alterna o campo', (tester) async {
    await pump(tester);
    expect(tester.widget<TextField>(field('Senha')).obscureText, isTrue);
    final passwordBox = find.descendant(
      of: find.widgetWithText(FormTextField, 'Senha'),
      matching: find.byType(AnimatedContainer),
    );
    expect(tester.getSize(passwordBox).height, 48);

    await tester.tap(find.byType(PasswordVisibilityButton));
    await tester.pump();
    expect(tester.widget<TextField>(field('Senha')).obscureText, isFalse);
    expect(find.bySemanticsLabel('Esconder senha'), findsOneWidget);
  });

  testWidgets('"Voltar ao site" leva à página inicial', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Voltar ao site'));
    await tester.pumpAndSettle();
    expect(find.text('Página inicial'), findsOneWidget);
  });

  for (final width in [390.0, 768.0, 1280.0]) {
    testWidgets('em $width px, sem exceção de layout, inclusive com erros', (tester) async {
      await pump(tester, width: width);
      await tester.tap(submit);
      await tester.pump();
      expect(tester.takeException(), isNull);
      final compact = width < 1024;
      expect(
        find.text('Sem acesso? Peça a quem administra o painel para criar seu usuário.'),
        compact ? findsNothing : findsOneWidget,
      );
    });
  }

  testWidgets('tela baixa rola sem corte, inclusive com erros e aviso', (tester) async {
    await pump(tester, width: 1280, height: 600);
    await tester.tap(submit);
    await tester.pump();
    expect(tester.takeException(), isNull);

    await fill(tester, email: 'nome@exemplo.com', password: 'segredo');
    await tester.tap(submit);
    await tester.pump();
    repository.fail(const UserDisabled());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('Tab segue marca, e-mail, senha, mostrar senha, Entrar e Voltar ao site', (
    tester,
  ) async {
    await pump(tester);

    String focused() {
      final context = FocusManager.instance.primaryFocus!.context!;
      if (context.findAncestorWidgetOfExactType<AppBrand>() != null) return 'marca';
      if (context.findAncestorWidgetOfExactType<PasswordVisibilityButton>() != null) {
        return 'mostrar senha';
      }
      final field = context.findAncestorWidgetOfExactType<FormTextField>();
      if (field != null) return field.label;
      final button = context.findAncestorWidgetOfExactType<AppButton>();
      if (button != null) return button.text;
      return '?';
    }

    final order = <String>[];
    for (var i = 0; i < 6; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      order.add(focused());
    }
    expect(order, ['marca', 'E-mail', 'Senha', 'mostrar senha', 'Entrar', 'Voltar ao site']);
  });
}
