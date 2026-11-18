import 'package:dartz/dartz.dart';
import 'package:expogeo/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, User>> login(String email, String password);

  Future<Either<AuthFailure, void>> logout();

  Future<Either<AuthFailure, User>> currentUser();

  /// Usuário da sessão salva, ou nulo sem sessão ou se o Firebase não responder a tempo
  Future<User?> restoredUser();

  Stream<User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  /// Sem resposta do Firebase (rede bloqueada), o login abre em vez de a página ficar parada.
  final Duration restoreTimeout;

  AuthRepositoryImpl(this._datasource, {this.restoreTimeout = const Duration(seconds: 3)});

  @override
  Future<Either<AuthFailure, User>> login(String email, String password) async {
    try {
      final user = await _datasource.signIn(email, password);
      return Right(user);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (_) {
      return const Left(ServerError());
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _datasource.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (_) {
      return const Left(ServerError());
    }
  }

  @override
  Future<Either<AuthFailure, User>> currentUser() async {
    try {
      final user = await _datasource.currentUser();

      if (user == null) {
        return const Left(UserNotFound());
      }

      return Right(user);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure.fromException(error));
    } catch (_) {
      return const Left(UserNotFound());
    }
  }

  @override
  Future<User?> restoredUser() async {
    try {
      return await _datasource.restoredUser().timeout(restoreTimeout);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<User?> get authStateChanges => _datasource.authStateChanges;
}
