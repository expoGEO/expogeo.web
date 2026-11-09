import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:expogeo/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeUser implements User {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Repositório de autenticação sem Firebase; cada tentativa fica pendente até ser respondida.
class FakeAuthRepository implements AuthRepository {
  final List<String> emails = [];
  final List<String> passwords = [];
  Completer<Either<AuthFailure, User>>? _pending;

  int get loginCalls => emails.length;

  void fail(AuthFailure failure) => _pending!.complete(Left(failure));

  void succeed() => _pending!.complete(Right(FakeUser()));

  @override
  Future<Either<AuthFailure, User>> login(String email, String password) {
    emails.add(email);
    passwords.add(password);
    _pending = Completer();
    return _pending!.future;
  }

  @override
  Future<Either<AuthFailure, void>> logout() async => const Right(null);

  @override
  Future<Either<AuthFailure, User>> currentUser() async => const Left(UserNotFound());

  @override
  Future<User?> restoredUser() async => null;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();
}
