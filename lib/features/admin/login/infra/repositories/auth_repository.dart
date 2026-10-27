import 'package:dartz/dartz.dart';
import 'package:expogeo/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Interface do repositório de autenticação
abstract class AuthRepository {
  /// Faz login com email e senha
  Future<Either<AuthFailure, User>> login(String email, String password);

  /// Faz logout
  Future<Either<AuthFailure, void>> logout();

  /// Obtém o usuário atualmente logado
  Future<Either<AuthFailure, User>> currentUser();

  /// Stream de mudanças no estado de autenticação
  Stream<User?> get authStateChanges;
}

/// Implementação do repositório com tratamento de erros
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

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
  Stream<User?> get authStateChanges => _datasource.authStateChanges;
}
