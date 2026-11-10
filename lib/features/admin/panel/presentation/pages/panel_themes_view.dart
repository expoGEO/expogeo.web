import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/components/state/state_error_inline.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:expogeo/features/admin/panel/presentation/components/subtheme_row.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_view_scroll.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

/// Consulta dos temas e subtemas do site, com as contagens do catálogo.
class PanelThemesView extends StatelessWidget {
  const PanelThemesView({this.catalogStore, super.key});

  /// Sem valor, usa o catálogo compartilhado.
  final CatalogStore? catalogStore;

  @override
  Widget build(BuildContext context) {
    final store = catalogStore ?? AdminSetup.getIt<CatalogStore>();

    return Observer(
      builder: (context) {
        final state = store.state;
        final isLoading = state.isInitial || state.isLoading;
        final catalog = store.catalog;

        return PanelViewScroll(
          children: [
            const PanelSectionHeader(
              title: 'Temas e subtemas',
              summary:
                  'Só para consulta. Os temas e subtemas não são criados nem apagados pelo painel.',
            ),
            if (state.isError)
              Padding(
                padding: EdgeInsets.only(bottom: AppTheme.dimensions.components.panelBlockGap),
                child: StateErrorInline(
                  message: 'Não conseguimos carregar as contagens.',
                  onRetry: store.refresh,
                ),
              ),
            for (final theme in ThemeDataModel.themes)
              _ThemeBlock(theme: theme, catalog: catalog, isLoading: isLoading),
          ],
        );
      },
    );
  }
}

class _ThemeBlock extends StatelessWidget {
  const _ThemeBlock({required this.theme, required this.catalog, required this.isLoading});

  final ThemeModel theme;
  final CatalogModel? catalog;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final stroke = AppTheme.dimensions.stroke.small;
    final catalog = this.catalog;
    final subthemes = theme.subthemes;
    final metaStyle = styles.small.copyWith(color: colors.inkSecondary);
    final subthemesLabel = subthemes.length == 1 ? '1 subtema' : '${subthemes.length} subtemas';

    return Padding(
      padding: EdgeInsets.only(bottom: components.panelBlockGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: components.panelBlockHeadPaddingTop,
              bottom: components.panelBlockHeadPaddingBottom,
            ),
            child: Wrap(
              spacing: components.panelBlockHeadGapH,
              runSpacing: components.panelBlockHeadGapV,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Semantics(
                  header: true,
                  headingLevel: 2,
                  child: Text(
                    theme.type.name,
                    style: styles.panelBlockTitle.copyWith(color: colors.ink),
                  ),
                ),
                if (isLoading)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$subthemesLabel · ', style: metaStyle),
                      AppSkeleton(
                        width: components.panelBadgeSkeletonWidth,
                        height: components.panelNavCountSkeletonHeight,
                      ),
                    ],
                  )
                else
                  Text(
                    catalog == null
                        ? subthemesLabel
                        : '$subthemesLabel · ${objectsLabel(catalog.countByTheme(theme.type))}',
                    style: metaStyle,
                  ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.page,
              borderRadius: BorderRadius.circular(components.panelListRadius),
              border: Border.all(color: colors.line, width: stroke),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(components.panelListRadius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < subthemes.length; i++) ...[
                    if (i > 0) Divider(height: stroke, thickness: stroke, color: colors.line),
                    SubthemeRow(
                      subtheme: subthemes[i].type,
                      count: catalog?.countBySubtheme(subthemes[i].type),
                      isCountLoading: isLoading,
                      onViewObjects: () => GoRouter.of(
                        context,
                      ).go(PanelAddress.objectsOf(theme: theme.type, subtheme: subthemes[i].type)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
