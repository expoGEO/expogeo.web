import 'package:expogeo/features/admin/panel/presentation/components/panel_sidebar.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/object_editor_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/admin/panel/panel_harness.dart';
import '../../features/catalog/catalog_test_data.dart';

void main() {
  Future<PanelHarness> open(WidgetTester tester, String location, {bool logged = true}) async {
    final panel = PanelHarness();
    await panel.pump(tester, location, logged: logged);
    if (logged) {
      await panel.loadCatalog(tester, [objectAt('NMA_BH', 'NMA_BH_03', date: DateTime(2025))]);
    }
    await tester.pumpAndSettle();
    return panel;
  }

  testWidgets('editar pelo código com hífen abre o editor fora da moldura', (tester) async {
    final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');

    expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
    expect(find.byType(ObjectEditorPage), findsOneWidget);
    expect(find.byType(PanelSidebar), findsNothing);
  });

  testWidgets('o código original vai para a forma com hífen', (tester) async {
    final panel = await open(tester, '/admin/painel/objetos/NMA_BH_03/editar');

    expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
  });

  testWidgets('novo com tema e subtema abre o editor', (tester) async {
    final panel = await open(
      tester,
      '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
    );

    expect(find.byType(ObjectEditorPage), findsOneWidget);
    expect(panel.location, contains('/admin/painel/objetos/novo'));
  });

  for (final location in ['/admin/painel/objetos/novo', '/admin/painel/objetos/nma-bh-03/editar']) {
    testWidgets('$location sem sessão volta ao login', (tester) async {
      final panel = await open(tester, location, logged: false);

      expect(panel.location, '/admin');
      expect(find.byType(ObjectEditorPage), findsNothing);
    });
  }

  testWidgets('a lista continua dentro da moldura', (tester) async {
    await open(tester, '/admin/painel/objetos');

    expect(find.byType(PanelSidebar), findsOneWidget);
    expect(find.byType(ObjectEditorPage), findsNothing);
  });
}
