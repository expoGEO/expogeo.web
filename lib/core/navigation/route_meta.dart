import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/utils/browser/page_meta_data.dart';

/// Metadados de tema, subtema e objeto; a página e o gerador de HTML usam o mesmo texto.
class RouteMeta {
  const RouteMeta._();

  static PageMeta theme(ThemeModel theme) => PageMeta.titled(
    title: theme.title,
    description: summarize(theme.description),
    path: theme.type.route,
  );

  static PageMeta subtheme({required ThemeModel theme, required SubthemeEnum subtheme}) =>
      PageMeta.titled(
        title: '${subtheme.name} · ${theme.title}',
        description:
            'Conteúdos digitais sobre ${subtheme.name.toLowerCase()} em ${theme.title}: '
            'sites, vídeos, mapas e aplicativos escolhidos para a sala de aula.',
        path: subtheme.route,
      );

  static PageMeta object({
    required SubthemeEnum subtheme,
    required ContentInfo info,
    required String path,
  }) => PageMeta.titled(
    title: '${info.title} · ${subtheme.name}',
    description: summarize(info.description),
    path: path,
  );
}
