import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/components/field/app_text_field.dart';
import 'package:expogeo/core/components/loading/circular_loading.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/validators/validators.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
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

  final _formKey = GlobalKey<FormState>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _authStore.currentUser();

    _reactions = [
      reaction((_) => _authStore.user, (User? user) {
        if (user != null) {
          GoRouter.of(context).go('/admin/painel');
        }
      }),
      reaction((_) => _authStore.state, (AuthState state) {
        if (state.loginState is LoginStateError) {
          final loginState = state.loginState as LoginStateError;
          Messenger.showError(context, loginState.failure.message);
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isMobile = ScreenUtils.isMobile(context);
    bool isTablet = ScreenUtils.isTablet(context);

    return Scaffold(
      backgroundColor: AppTheme.colors.lightGray,
      body: SizedBox(
        width: size.width,
        child: Observer(
          builder: (context) {
            final loginState = _authStore.state.loginState;

            return Center(
              child: RoundedCard(
                width: size.width * (isMobile ? 1 : (isTablet ? 0.5 : 0.3)),
                padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
                margin: isMobile
                    ? EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.medium.width)
                    : EdgeInsets.zero,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LOGIN',
                        style: AppTheme.typography.title.big.copyWith(
                          color: AppTheme.colors.darkGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.large.height),
                      AppTextField(
                        controller: _emailController,
                        labelText: 'E-MAIL',
                        hintText: 'exemplo@dominio.com',
                        validator: Validators.isValidEmail,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.height),
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'SENHA',
                        obscureText: !_authStore.passwordVisible,
                        validator: Validators.isValidPassword,
                        suffixIcon: GestureDetector(
                          onTap: _authStore.togglePasswordVisibility,
                          child: _authStore.passwordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.large.height),
                      loginState is LoginStateLoading
                          ? const CircularLoading()
                          : PrimaryButton(
                              label: "ENTRAR",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _authStore.login(_emailController.text, _passwordController.text);
                                }
                              },
                            ),
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
}
