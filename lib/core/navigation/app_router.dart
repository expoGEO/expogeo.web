import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/admin/login/presentation/pages/signin_page.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_page.dart';
import 'package:expogeo/features/home/pages/home_page.dart';
import 'package:expogeo/features/theme/pages/subtheme_page.dart';
import 'package:expogeo/features/theme/pages/theme_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String contact = '/contato';
  static const String about = '/sobre';
  static const String admin = '/admin';
  static const String adminPanel = '/admin/painel';

  static String representacoesEspaciais = ThemeEnum.representacoesEspaciais.value;
  static String meioAmbiente = ThemeEnum.naturezaMeioAmbiente.value;
  static String espacosUrbanosRurais = ThemeEnum.espacosUrbanosRurais.value;
  static String culturaPolitica = ThemeEnum.culturaPolitica.value;

  static final GoRouter router = GoRouter(
    initialLocation: home,
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) async {
      final isLogged = FirebaseAuth.instance.currentUser != null;
      final isAdminPanel = state.fullPath == adminPanel;

      // Se tenta acessar /admin/painel sem estar logado, redireciona para /admin (login)
      if (isAdminPanel && !isLogged) {
        return admin;
      }

      // Se está na rota /admin base, o router decide entre login ou painel
      return null;
    },
    routes: [
      // Rota principal
      GoRoute(path: home, name: home, builder: (context, state) => const HomePage()),

      // Rota do painel administrativo (com login/panel como subrotas)
      GoRoute(
        path: admin,
        builder: (context, state) {
          // Redirecionar baseado no estado de autenticação
          final isLogged = FirebaseAuth.instance.currentUser != null;
          return isLogged ? const PanelPage() : const SignInPage();
        },
        routes: [
          GoRoute(
            path: 'painel',
            name: 'admin-painel',
            builder: (context, state) => const PanelPage(),
          ),
        ],
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

      // Rotas de conteúdo
      // GoRoute(
      //   path: '/:themeId/:subthemeId/:contentId',
      //   builder: (context, state) {
      //     final extra = state.extra as Map<String, dynamic>?;
      //     if (extra == null) return const NotFoundPage();

      //     final themeId = state.pathParameters['themeId'];
      //     final subthemeId = state.pathParameters['subthemeId'];
      //     final contentId = state.pathParameters['contentId'];

      //     if (themeId == null || subthemeId == null || contentId == null) {
      //       return const NotFoundPage();
      //     }

      //     final type = extra['type'] as ContentType?;
      //     if (type == null) return const NotFoundPage();

      //     switch (type) {
      //       case ContentType.video:
      //         return YoutubeVideoViewPage(
      //           themeId: themeId,
      //           subthemeId: subthemeId,
      //           contentId: contentId,
      //         );
      //       default:
      //         return const NotFoundPage();
      //     }
      //   },
      // ),
    ],
  );
}
