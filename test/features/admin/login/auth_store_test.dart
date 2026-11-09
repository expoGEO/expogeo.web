import 'dart:async';

import 'package:expogeo/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:expogeo/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_state.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fake_auth.dart';

void main() {
  late FakeAuthRepository repository;
  late AuthStore store;

  setUp(() {
    repository = FakeAuthRepository();
    store = AuthStore(repository);
  });

  test('duas chamadas seguidas fazem uma só tentativa', () async {
    final first = store.login('a@b.co', 'x');
    final second = store.login('a@b.co', 'x');
    await second;

    expect(repository.loginCalls, 1);
    repository.succeed();
    await first;
  });

  test('e-mail chega aparado e a senha, como foi digitada', () async {
    final future = store.login('  nome@exemplo.com ', ' senha ');
    repository.succeed();
    await future;

    expect(repository.emails.single, 'nome@exemplo.com');
    expect(repository.passwords.single, ' senha ');
  });

  test('erro guarda a falha e libera nova tentativa', () async {
    final future = store.login('a@b.co', 'x');
    expect(store.state.loginState, isA<LoginStateLoading>());
    repository.fail(const TooManyRequests());
    await future;

    final state = store.state.loginState;
    expect(state, isA<LoginStateError>());
    expect((state as LoginStateError).failure, isA<TooManyRequests>());

    final retry = store.login('a@b.co', 'y');
    expect(repository.loginCalls, 2);
    repository.succeed();
    await retry;
  });

  test('sucesso guarda o usuário', () async {
    final future = store.login('a@b.co', 'x');
    repository.succeed();
    await future;

    expect(store.state.loginState, isA<LoginStateSuccess>());
    expect(store.user, isNotNull);
  });

  group('sessão recuperada', () {
    test('devolve o usuário quando o Firebase responde', () async {
      final user = FakeUser();
      final repository = AuthRepositoryImpl(_RestoringDatasource(Future.value(user)));

      expect(await repository.restoredUser(), user);
    });

    test('sem resposta do Firebase, conta como sem sessão depois do limite', () async {
      final repository = AuthRepositoryImpl(
        _RestoringDatasource(Completer<User?>().future),
        restoreTimeout: const Duration(milliseconds: 10),
      );

      expect(await repository.restoredUser(), isNull);
    });
  });
}

class _RestoringDatasource implements FirebaseAuthDatasource {
  _RestoringDatasource(this._restored);

  final Future<User?> _restored;

  @override
  Future<User?> restoredUser() => _restored;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
