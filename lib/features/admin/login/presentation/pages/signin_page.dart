import 'dart:math' as math;

import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/form/form_error_alert.dart';
import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/validators/form_validators.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/login/presentation/components/login_brand_panel.dart';
import 'package:expogeo/features/admin/login/presentation/components/password_visibility_button.dart';
import 'package:expogeo/features/admin/login/presentation/login_error_message.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_state.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final _authStore = AdminSetup.getIt<AuthStore>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final _emailValidator = FormValidators.email('Escreva o e-mail, como nome@exemplo.com.');
  final _passwordValidator = FormValidators.required('Escreva a senha.');

  bool _attempted = false;

  // A store guarda o último erro mesmo depois de sair da página; só aparece o que veio desta tela.
  bool _errorVisible = false;

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _authStore.currentUser();

    _reactions = [
      reaction((_) => _authStore.user, (User? user) {
        if (user == null || !mounted) return;
        // O painel é subrota do login, que continua montado por baixo; a senha não fica lá.
        _passwordController.clear();
        setState(() => _attempted = false);
        context.go(AppRouter.adminPanel);
      }),
      reaction((_) => _authStore.state.loginState, (LoginState state) {
        if (state is LoginStateError && mounted) setState(() => _errorVisible = true);
      }),
    ];
  }

  @override
  void dispose() {
    for (final reaction in _reactions) {
      reaction.reaction.dispose();
    }

    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  bool get _isLoading => _authStore.state.loginState is LoginStateLoading;

  void _submit() {
    if (_isLoading) return;

    setState(() {
      _attempted = true;
      _errorVisible = false;
    });

    if (!_formKey.currentState!.validate()) {
      final emailInvalid = _emailValidator(_emailController.text) != null;
      (emailInvalid ? _emailFocus : _passwordFocus).requestFocus();
      return;
    }

    _authStore.login(_emailController.text, _passwordController.text);
  }

  String? get _errorMessage {
    final state = _authStore.state.loginState;
    if (!_errorVisible || state is! LoginStateError) return null;
    return loginErrorMessage(state.failure);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final compact = breakpoint != Breakpoint.desktop;

    // A coluna mede a altura pelo IntrinsicHeight, que ignora larguras máximas no caminho; a margem
    // calculada da tela limita o cartão sem esconder dele a largura real.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final columnWidth = compact
        ? screenWidth
        : screenWidth *
              components.loginFormFlex /
              (components.loginBrandFlex + components.loginFormFlex);
    final sidePadding = math.max(
      components.loginMainPaddingH(breakpoint),
      (columnWidth - components.loginCardMaxWidth) / 2,
    );

    final formArea = Padding(
      padding: EdgeInsets.fromLTRB(
        sidePadding,
        components.loginMainPaddingTop(breakpoint),
        sidePadding,
        components.loginMainPaddingBottom,
      ),
      child: Align(alignment: Alignment.center, child: _buildCard(context, breakpoint)),
    );

    return Scaffold(
      backgroundColor: colors.surface,
      body: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [const LoginBrandPanel(compact: true), formArea],
                      )
                    : IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: components.loginBrandFlex,
                              child: const LoginBrandPanel(),
                            ),
                            Expanded(flex: components.loginFormFlex, child: formArea),
                          ],
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Breakpoint breakpoint) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(dimensions.radii.r18),
        border: Border.all(color: colors.line, width: dimensions.stroke.small),
        boxShadow: dimensions.shadows.card,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.loginCardPaddingH(breakpoint),
          vertical: components.loginCardPaddingV(breakpoint),
        ),
        child: Observer(
          builder: (context) {
            final isLoading = _isLoading;
            final passwordVisible = _authStore.passwordVisible;
            final errorMessage = _errorMessage;

            return Form(
              key: _formKey,
              autovalidateMode: _attempted ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      headingLevel: 2,
                      child: Text(
                        'Entrar',
                        style: styles.loginCardTitle.copyWith(color: colors.ink),
                      ),
                    ),
                    SizedBox(height: components.loginCardSubtitleGap),
                    Text(
                      'Use o e-mail e a senha que a administração cadastrou para você.',
                      style: styles.loginLead.copyWith(color: colors.inkSecondary),
                    ),
                    SizedBox(height: components.loginCardFieldsTop),
                    if (errorMessage != null) ...[
                      FormErrorAlert(message: errorMessage),
                      SizedBox(height: components.formFieldGap),
                    ],
                    FormTextField(
                      label: 'E-mail',
                      hintText: 'nome@exemplo.com',
                      controller: _emailController,
                      focusNode: _emailFocus,
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                    SizedBox(height: components.formFieldGap),
                    FormTextField(
                      label: 'Senha',
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      validator: _passwordValidator,
                      obscureText: !passwordVisible,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      suffix: PasswordVisibilityButton(
                        visible: passwordVisible,
                        onPressed: _authStore.togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: components.formFieldGap),
                    AppButton.primary(
                      text: isLoading ? 'Entrando…' : 'Entrar',
                      isLoading: isLoading,
                      fullWidth: true,
                      onPressed: _submit,
                    ),
                    SizedBox(height: components.loginBackLinkTop),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppButton.ghost(
                        text: 'Voltar ao site',
                        size: AppButtonSize.small,
                        leadingIcon: Icons.arrow_back,
                        onPressed: () => context.go(AppRouter.home),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
