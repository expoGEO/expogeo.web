import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:expogeo/core/components/structure/page_meta_scope.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/navigation/route_meta.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/other_themes_section.dart';
import 'package:expogeo/features/theme/components/theme_header_stats.dart';
import 'package:expogeo/features/theme/components/theme_subthemes_section.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ThemePage extends StatefulWidget {
  final String themeId;
  final String themeTitle;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  const ThemePage({super.key, required this.themeId, required this.themeTitle, this.store});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  void initState() {
    super.initState();
    (widget.store ?? GetIt.I<CatalogStore>()).ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final theme = ThemeDataModel.themes.firstWhere(
      (t) => t.type.value == widget.themeId,
      orElse: () => ThemeDataModel.themes.first,
    );
    final medallion = ScreenUtils.breakpointOf(context) == Breakpoint.desktop
        ? components.pageHeadMedallion
        : components.pageHeadMedallionCompact;

    return PageMetaScope(
      meta: RouteMeta.theme(theme),
      child: SiteScaffold(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  breadcrumbs: [
                    const BreadcrumbItem('Início', route: AppRouter.home),
                    const BreadcrumbItem('Temas'),
                    BreadcrumbItem(theme.title),
                  ],
                  title: theme.title,
                  lead: theme.description.trim(),
                  details: ThemeHeaderStats(theme: theme, store: widget.store),
                  trailing: AppMedallion(size: medallion, image: theme.type.illustration),
                ),
                ThemeSubthemesSection(theme: theme, store: widget.store),
                OtherThemesSection(current: theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
