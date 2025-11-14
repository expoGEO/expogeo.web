import 'package:expogeo/features/contact/pages/contact_page.dart';
import 'package:expogeo/features/home/pages/home_page.dart';
import 'package:expogeo/features/theme/pages/subtheme_page.dart';
import 'package:expogeo/features/theme/pages/theme_page.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String representacoes = '/representacoes';
  static const String meioAmbiente = '/meio-ambiente';
  static const String espacosUrbanos = '/espacos-urbanos';
  static const String culturaPolitica = '/cultura-politica';
  static const String contact = '/contato';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      // Rota principal
      GoRoute(path: home, name: 'home', builder: (context, state) => const HomePage()),

      // Rotas dos temas principais
      GoRoute(
        path: representacoes,
        name: 'representacoes',
        builder: (context, state) =>
            const ThemePage(themeId: 'representacoes', themeTitle: 'Representações Espaciais'),
      ),
      GoRoute(
        path: meioAmbiente,
        name: 'meio-ambiente',
        builder: (context, state) =>
            const ThemePage(themeId: 'meio-ambiente', themeTitle: 'Meio Ambiente e Natureza'),
      ),
      GoRoute(
        path: espacosUrbanos,
        name: 'espacos-urbanos',
        builder: (context, state) =>
            const ThemePage(themeId: 'espacos-urbanos', themeTitle: 'Espaços Urbanos e Rurais'),
      ),
      GoRoute(
        path: culturaPolitica,
        name: 'cultura-politica',
        builder: (context, state) =>
            const ThemePage(themeId: 'cultura-politica', themeTitle: 'Cultura e Política'),
      ),

      // Rotas dos subtemas
      GoRoute(
        path: '$representacoes/:subthemeId',
        name: 'representacoes-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: 'representacoes', subthemeId: subthemeId);
        },
      ),
      GoRoute(
        path: '$meioAmbiente/:subthemeId',
        name: 'meio-ambiente-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: 'meio-ambiente', subthemeId: subthemeId);
        },
      ),
      GoRoute(
        path: '$espacosUrbanos/:subthemeId',
        name: 'espacos-urbanos-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: 'espacos-urbanos', subthemeId: subthemeId);
        },
      ),
      GoRoute(
        path: '$culturaPolitica/:subthemeId',
        name: 'cultura-politica-subtheme',
        builder: (context, state) {
          final subthemeId = state.pathParameters['subthemeId']!;
          return SubthemePage(themeId: 'cultura-politica', subthemeId: subthemeId);
        },
      ),

      // Rota de contato
      GoRoute(path: contact, name: 'contact', builder: (context, state) => const ContactPage()),
    ],
  );
}
