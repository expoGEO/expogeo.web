import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/core/utils/string/string_utils.dart';
import 'package:expogeo/features/about/pages/about_page.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:expogeo/features/admin/login/presentation/pages/signin_page.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/object_editor_page.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_objects_view.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_shell.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_themes_view.dart';
import 'package:expogeo/features/contact/pages/contact_page.dart';
import 'package:expogeo/features/home/pages/home_page.dart';
import 'package:expogeo/features/theme/pages/object_page.dart';
import 'package:expogeo/features/theme/pages/subtheme_page.dart';
import 'package:expogeo/features/theme/pages/theme_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String contact = '/contato';
  static const String about = '/sobre';
  static const String admin = '/admin';
  static const String adminPanel = '/admin/painel';
  static const String adminPanelObjects = '/admin/painel/objetos';
  static const String adminPanelThemes = '/admin/painel/temas';
  static const String codeParam = 'codigo';
  static const String adminObjectNew = '/admin/painel/objetos/novo';
  static const String adminObjectEdit = '/admin/painel/objetos/:$codeParam/editar';

  static String representacoesEspaciais = ThemeEnum.representacoesEspaciais.value;
  static String meioAmbiente = ThemeEnum.naturezaMeioAmbiente.value;
  static String espacosUrbanosRurais = ThemeEnum.espacosUrbanosRurais.value;
  static String culturaPolitica = ThemeEnum.culturaPolitica.value;

  static final GoRouter router = GoRouter(
    initialLocation: home,
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) =>
        adminRedirect(state.uri.path, () => AdminSetup.getIt<AuthRepository>().restoredUser()),
    routes: [
      // Rota principal
      GoRoute(path: home, name: home, builder: (context, state) => const HomePage()),
      GoRoute(path: about, name: about, builder: (context, state) => const AboutPage()),
      GoRoute(path: contact, name: contact, builder: (context, state) => const ContactPage()),

      // Rota do painel administrativo: o login, com o painel como subrota; o painel em si leva
      // à primeira vista, dentro da moldura
      GoRoute(
        path: admin,
        builder: (context, state) => const SignInPage(),
        routes: [
          GoRoute(
            path: 'painel',
            name: 'admin-painel',
            redirect: (context, state) => adminPanelObjects,
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => PanelShell(location: state.uri, child: child),
        routes: [
          GoRoute(
            path: adminPanelObjects,
            name: 'admin-painel-objetos',
            builder: (context, state) =>
                PanelObjectsView(selection: PanelSelection.fromQuery(state.uri.queryParameters)),
          ),
          GoRoute(
            path: adminPanelThemes,
            name: 'admin-painel-temas',
            builder: (context, state) => const PanelThemesView(),
          ),
        ],
      ),

      // Editor de objeto: página inteira, fora da moldura do painel
      GoRoute(
        path: adminObjectNew,
        name: 'admin-painel-objeto-novo',
        onExit: (context, state) => ObjectEditorPage.confirmLeave(context),
        pageBuilder: (context, state) => _editorPage(
          ObjectEditorPage.create(
            key: ValueKey(state.uri.toString()),
            selection: PanelSelection.fromQuery(state.uri.queryParameters),
          ),
        ),
      ),
      GoRoute(
        path: adminObjectEdit,
        name: 'admin-painel-objeto-editar',
        redirect: (context, state) {
          final code = state.pathParameters[codeParam]!;
          final slug = referenceCodeSlug(code);
          if (slug == code) return null;
          return PanelAddress.editObject(slug);
        },
        onExit: (context, state) => ObjectEditorPage.confirmLeave(context),
        pageBuilder: (context, state) {
          final code = state.pathParameters[codeParam]!;
          return _editorPage(ObjectEditorPage.edit(key: ValueKey(code), code: code));
        },
      ),

      // Rotas dos temas principais
      GoRoute(
        path: '/$representacoesEspaciais',
        name: representacoesEspaciais,
        builder: (context, state) =>
            ThemePage(themeId: representacoesEspaciais, themeTitle: 'Representações Espaciais'),
      ),
      GoRoute(
        path: '/$meioAmbiente',
        name: meioAmbiente,
        builder: (context, state) =>
            ThemePage(themeId: meioAmbiente, themeTitle: 'Meio Ambiente e Natureza'),
      ),
      GoRoute(
        path: '/$espacosUrbanosRurais',
        name: espacosUrbanosRurais,
        builder: (context, state) =>
            ThemePage(themeId: espacosUrbanosRurais, themeTitle: 'Espaços Urbanos e Rurais'),
      ),
      GoRoute(
        path: '/$culturaPolitica',
        name: culturaPolitica,
        builder: (context, state) =>
            ThemePage(themeId: culturaPolitica, themeTitle: 'Cultura e Política'),
      ),

      // Rotas dos subtemas
      GoRoute(
        path: '/$representacoesEspaciais/:subthemeId',
        name: '$representacoesEspaciais-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: representacoesEspaciais, subthemeId: subthemeId);
        },
      ),
      GoRoute(
        path: '/$meioAmbiente/:subthemeId',
        name: '$meioAmbiente-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: meioAmbiente, subthemeId: subthemeId);
        },
      ),
      GoRoute(
        path: '/$espacosUrbanosRurais/:subthemeId',
        name: '$espacosUrbanosRurais-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: espacosUrbanosRurais, subthemeId: subthemeId);
        },
      ),
      GoRoute(
        path: '/$culturaPolitica/:subthemeId',
        name: '$culturaPolitica-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: culturaPolitica, subthemeId: subthemeId);
        },
      ),

      // Rotas dos objetos: irmãs das de subtema, para não empilhar a página dele por baixo
      _objectRoute(representacoesEspaciais),
      _objectRoute(meioAmbiente),
      _objectRoute(espacosUrbanosRurais),
      _objectRoute(culturaPolitica),
    ],
  );

  /// Decide `/admin` e o painel pela sessão já recuperada; as outras rotas não a consultam.
  static Future<String?> adminRedirect(String path, Future<User?> Function() restoredUser) async {
    final inPanel = path == adminPanel || path.startsWith('$adminPanel/');
    if (path != admin && !inPanel) return null;

    final isLogged = await restoredUser() != null;
    if (path == admin) return isLogged ? adminPanelObjects : null;
    if (!isLogged) return admin;
    return path == adminPanel ? adminPanelObjects : null;
  }

  // A mesma chave nas duas rotas do editor: trocar de endereço não empilha outra página.
  static Page<void> _editorPage(Widget child) =>
      MaterialPage(key: const ValueKey('object-editor'), child: child);

  static GoRoute _objectRoute(String themeId) => GoRoute(
    path: '/$themeId/:subthemeId/:code',
    name: '$themeId-object',
    redirect: (context, state) {
      final subthemeId = state.pathParameters['subthemeId']!;
      final code = state.pathParameters['code']!;
      final slug = referenceCodeSlug(code);
      if (slug == code) return null;
      return state.uri.replace(pathSegments: ['', themeId, subthemeId, slug]).toString();
    },
    builder: (context, state) => ObjectPage(
      themeId: themeId,
      subthemeId: state.pathParameters['subthemeId']!,
      code: state.pathParameters['code']!,
    ),
  );
}
