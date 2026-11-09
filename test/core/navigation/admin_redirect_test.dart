import 'package:expogeo/core/navigation/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_auth.dart';

void main() {
  var calls = 0;

  Future<User?> Function() restoring(User? user, {Duration delay = Duration.zero}) {
    return () async {
      calls++;
      await Future<void>.delayed(delay);
      return user;
    };
  }

  setUp(() => calls = 0);

  test('/admin sem sessão fica no login', () async {
    expect(await AppRouter.adminRedirect(AppRouter.admin, restoring(null)), isNull);
  });

  test('/admin com sessão recuperada depois de um atraso vai para o painel', () async {
    final result = await AppRouter.adminRedirect(
      AppRouter.admin,
      restoring(FakeUser(), delay: const Duration(milliseconds: 50)),
    );
    expect(result, AppRouter.adminPanel);
  });

  test('/admin/painel sem sessão volta ao login', () async {
    expect(await AppRouter.adminRedirect(AppRouter.adminPanel, restoring(null)), AppRouter.admin);
  });

  test('/admin/painel com sessão fica', () async {
    expect(await AppRouter.adminRedirect(AppRouter.adminPanel, restoring(FakeUser())), isNull);
  });

  test('outras rotas não consultam a sessão', () async {
    for (final path in [AppRouter.home, AppRouter.contact, '/representacoes-espaciais']) {
      expect(await AppRouter.adminRedirect(path, restoring(FakeUser())), isNull);
    }
    expect(calls, 0);
  });
}
