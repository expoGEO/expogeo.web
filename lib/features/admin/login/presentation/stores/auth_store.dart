import 'package:expogeo/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final AuthRepository _authRepository;

  AuthStoreBase(this._authRepository);

  @observable
  bool passwordVisible = false;

  @observable
  User? user;

  @observable
  AuthState state = const AuthState(
    loginState: LoginState.initial(),
    logoutState: LogoutState.initial(),
  );

  @action
  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
  }

  @action
  Future<void> currentUser() async {
    final result = await _authRepository.currentUser();

    result.fold((failure) => user = null, (user) => this.user = user);
  }

  /// Faz login com email e senha; ignora a chamada enquanto outra tentativa está em andamento
  @action
  Future<void> login(String email, String password) async {
    if (state.loginState is LoginStateLoading) return;

    state = state.copyWith(loginState: const LoginState.loading());

    final result = await _authRepository.login(email.trim(), password);

    result.fold((failure) => state = state.copyWith(loginState: LoginState.error(failure)), (user) {
      this.user = user;
      state = state.copyWith(
        loginState: const LoginState.success(),
        logoutState: const LogoutState.initial(),
      );
    });
  }

  @action
  Future<void> logout() async {
    state = state.copyWith(logoutState: const LogoutState.loading());

    final result = await _authRepository.logout();

    result.fold((failure) => state = state.copyWith(logoutState: LogoutState.error(failure)), (_) {
      user = null;
      state = state.copyWith(
        loginState: const LoginState.initial(),
        logoutState: const LogoutState.success(),
      );
    });
  }
}
