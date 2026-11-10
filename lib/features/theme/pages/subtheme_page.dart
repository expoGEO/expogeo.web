import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:expogeo/core/components/structure/page_meta_scope.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_lead.dart';
import 'package:expogeo/features/theme/components/subtheme_objects_section.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class SubthemePage extends StatelessWidget {
  final String themeId;
  final String subthemeId;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  const SubthemePage({super.key, required this.themeId, required this.subthemeId, this.store});

  @override
  Widget build(BuildContext context) {
    for (final theme in ThemeDataModel.themes) {
      if (theme.type.value != themeId) continue;
      for (final subtheme in theme.subthemes) {
        if (subtheme.type.value == subthemeId) {
          // A chave recomeça busca, tipo e rolagem quando o roteador reaproveita a página.
          return _SubthemeView(
            key: ValueKey(subtheme.type),
            theme: theme,
            subtheme: subtheme,
            store: store,
          );
        }
      }
    }
    return const NotFoundPage();
  }
}

class _SubthemeView extends StatefulWidget {
  const _SubthemeView({super.key, required this.theme, required this.subtheme, this.store});

  final ThemeModel theme;
  final SubthemeModel subtheme;
  final CatalogStore? store;

  @override
  State<_SubthemeView> createState() => _SubthemeViewState();
}

class _SubthemeViewState extends State<_SubthemeView> {
  late final CatalogStore _catalog = widget.store ?? GetIt.I<CatalogStore>();
  late final SubthemeObjectsStore _objects = SubthemeObjectsStore(widget.subtheme.type, _catalog);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _catalog.ensureLoaded();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final theme = widget.theme;
    final subtheme = widget.subtheme;
    final medallion = ScreenUtils.breakpointOf(context) == Breakpoint.desktop
        ? components.pageHeadMedallion
        : components.pageHeadMedallionCompact;

    return PageMetaScope(
      meta: PageMeta.titled(
        title: '${subtheme.type.name} · ${theme.title}',
        description:
            'Conteúdos digitais sobre ${subtheme.type.name.toLowerCase()} em ${theme.title}: '
            'sites, vídeos, mapas e aplicativos escolhidos para a sala de aula.',
        path: subtheme.type.route,
      ),
      child: SiteScaffold(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  topAction: Transform.translate(
                    offset: Offset(components.pageHeadBackShift, 0),
                    child: AppButton.ghost(
                      text: theme.title,
                      semanticLabel: 'Voltar para ${theme.title}',
                      size: AppButtonSize.small,
                      leadingIcon: Icons.arrow_back,
                      onPressed: () => context.go(theme.type.route),
                    ),
                  ),
                  breadcrumbs: [
                    const BreadcrumbItem('Início', route: AppRouter.home),
                    BreadcrumbItem(theme.title, route: theme.type.route),
                    BreadcrumbItem(subtheme.type.name),
                  ],
                  title: subtheme.type.name,
                  details: SubthemeLead(subtheme: subtheme.type, store: _catalog),
                  trailing: AppMedallion(size: medallion, image: subtheme.image),
                ),
                SubthemeObjectsSection(
                  theme: theme,
                  store: _objects,
                  controller: _searchController,
                  searchFocusNode: _searchFocusNode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
