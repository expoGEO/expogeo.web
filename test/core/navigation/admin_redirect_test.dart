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
    expect(result, AppRouter.adminPanelObjects);
  });

  test('/admin/painel sem sessão volta ao login', () async {
    expect(await AppRouter.adminRedirect(AppRouter.adminPanel, restoring(null)), AppRouter.admin);
  });

  test('/admin/painel com sessão leva a objetos', () async {
    expect(
      await AppRouter.adminRedirect(AppRouter.adminPanel, restoring(FakeUser())),
      AppRouter.adminPanelObjects,
    );
  });

  test('as vistas do painel sem sessão voltam ao login', () async {
    for (final path in [
      AppRouter.adminPanelThemes,
      AppRouter.adminPanelObjects,
      '/admin/painel/xyz',
    ]) {
      expect(await AppRouter.adminRedirect(path, restoring(null)), AppRouter.admin);
    }
  });

  test('as vistas do painel com sessão ficam', () async {
    for (final path in [AppRouter.adminPanelThemes, AppRouter.adminPanelObjects]) {
      expect(await AppRouter.adminRedirect(path, restoring(FakeUser())), isNull);
    }
  });

  test('outras rotas não consultam a sessão', () async {
    for (final path in [AppRouter.home, AppRouter.contact, '/representacoes-espaciais']) {
      expect(await AppRouter.adminRedirect(path, restoring(FakeUser())), isNull);
    }
    expect(calls, 0);
  });
}
