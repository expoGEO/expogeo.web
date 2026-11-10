import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({required LoginState loginState, required LogoutState logoutState}) =
      _AuthState;
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginStateInitial;
  const factory LoginState.loading() = LoginStateLoading;
  const factory LoginState.success() = LoginStateSuccess;
  const factory LoginState.error(AuthFailure failure) = LoginStateError;
}

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = LogoutStateInitial;
  const factory LogoutState.loading() = LogoutStateLoading;
  const factory LogoutState.success() = LogoutStateSuccess;
  const factory LogoutState.error(AuthFailure failure) = LogoutStateError;
}
