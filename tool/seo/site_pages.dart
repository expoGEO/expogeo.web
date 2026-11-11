import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/navigation/route_meta.dart';
import 'package:expogeo/core/utils/browser/page_meta_data.dart';
import 'package:expogeo/core/utils/constants/site_copy.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';

enum PageKind { home, about, contact, theme, subtheme, object }

/// Um passo do caminho até a página, para a trilha e o JSON-LD.
class PageCrumb {
  const PageCrumb(this.name, this.path);

  final String name;
  final String path;
}

class PageLink {
  const PageLink(this.title, this.path);

  final String title;
  final String path;
}

class PageFact {
  const PageFact(this.label, this.value);

  final String label;
  final String value;
}

/// Tudo o que o gerador precisa para escrever uma página: metadados e o texto que o app mostra.
class SitePage {
  const SitePage({
    required this.kind,
    required this.meta,
    required this.heading,
    this.paragraphs = const [],
    this.breadcrumbs = const [],
    this.links = const [],
    this.facts = const [],
    this.item,
  });

  final PageKind kind;
  final PageMeta meta;
  final String heading;
  final List<String> paragraphs;
  final List<PageCrumb> breadcrumbs;
  final List<PageLink> links;
  final List<PageFact> facts;

  /// Só nas páginas de objeto.
  final CatalogItem? item;

  String get path => meta.path;

  DateTime? get lastModified => item?.content.originInfo.insertionDate;
}

const PageCrumb _homeCrumb = PageCrumb('Início', AppRouter.home);

/// As páginas públicas do site: as fixas, os temas, os subtemas listados e um por objeto.
/// Não inclui `/admin` nem subtemas que o site não lista.
List<SitePage> buildSitePages(CatalogModel catalog) {
  final pages = <SitePage>[
    SitePage(
      kind: PageKind.home,
      meta: const PageMeta(
        title: SiteCopy.homeTitle,
        description: SiteCopy.homeDescription,
        path: AppRouter.home,
      ),
      heading: '${SiteCopy.homeHeadline}${SiteCopy.homeHeadlineAccent}',
      paragraphs: const [SiteCopy.homeLead],
      links: [for (final theme in ThemeDataModel.themes) PageLink(theme.title, theme.type.route)],
    ),
    SitePage(
      kind: PageKind.about,
      meta: PageMeta.titled(
        title: SiteCopy.aboutTitle,
        description: summarize(SiteCopy.aboutParagraphs.first),
        path: AppRouter.about,
      ),
      heading: SiteCopy.aboutTitle,
      paragraphs: [SiteCopy.aboutLead, ...SiteCopy.aboutParagraphs],
      breadcrumbs: const [_homeCrumb, PageCrumb('Sobre', AppRouter.about)],
    ),
    SitePage(
      kind: PageKind.contact,
      meta: PageMeta.titled(
        title: 'Contato',
        description: SiteCopy.contactLead,
        path: AppRouter.contact,
      ),
      heading: SiteCopy.contactTitle,
      paragraphs: const [SiteCopy.contactLead],
      breadcrumbs: const [_homeCrumb, PageCrumb('Contato', AppRouter.contact)],
    ),
  ];

  for (final theme in ThemeDataModel.themes) {
    final themeCrumb = PageCrumb(theme.title, theme.type.route);
    pages.add(
      SitePage(
        kind: PageKind.theme,
        meta: RouteMeta.theme(theme),
        heading: theme.title,
        paragraphs: [theme.description.trim()],
        breadcrumbs: [_homeCrumb, themeCrumb],
        links: [
          for (final subtheme in theme.subthemes) PageLink(subtheme.type.name, subtheme.type.route),
        ],
      ),
    );

    for (final subtheme in theme.subthemes) {
      final objects = _objectsOf(catalog, subtheme.type);
      final meta = RouteMeta.subtheme(theme: theme, subtheme: subtheme.type);
      pages.add(
        SitePage(
          kind: PageKind.subtheme,
          meta: meta,
          heading: subtheme.type.name,
          paragraphs: [meta.description],
          breadcrumbs: [_homeCrumb, themeCrumb, PageCrumb(subtheme.type.name, meta.path)],
          links: [for (final item in objects) PageLink(item.content.contentInfo.title, item.route)],
        ),
      );

      for (final item in objects) {
        final info = item.content.contentInfo;
        final author = item.content.intellectualIndicator;
        pages.add(
          SitePage(
            kind: PageKind.object,
            meta: RouteMeta.object(subtheme: subtheme.type, info: info, path: item.route),
            heading: info.title,
            paragraphs: [info.description, if (info.contentNote != null) info.contentNote!],
            breadcrumbs: [
              _homeCrumb,
              themeCrumb,
              PageCrumb(subtheme.type.name, subtheme.type.route),
              PageCrumb(info.title, item.route),
            ],
            facts: [
              PageFact('Autoria', author.creator),
              if (author.collaborator != null) PageFact('Colaboração', author.collaborator!),
              if (info.subjects.isNotEmpty) PageFact('Assuntos', info.subjects.join(', ')),
              PageFact('Tema', theme.title),
              PageFact('Subtema', subtheme.type.name),
            ],
            item: item,
          ),
        );
      }
    }
  }
  return pages;
}

/// Objetos do subtema na ordem do código; se dois códigos dão o mesmo endereço, vale o menor,
/// como o app faz ao abrir o objeto.
List<CatalogItem> _objectsOf(CatalogModel catalog, SubthemeEnum subtheme) {
  final byRoute = <String, CatalogItem>{};
  for (final item in catalog.items) {
    if (item.subtheme != subtheme) continue;
    final current = byRoute[item.route];
    if (current == null || item.content.id.compareTo(current.content.id) < 0) {
      byRoute[item.route] = item;
    }
  }
  return byRoute.values.toList()..sort((a, b) => a.content.id.compareTo(b.content.id));
}
