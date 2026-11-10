import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_nav_item.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PanelSidebar extends StatelessWidget {
  const PanelSidebar({
    required this.catalogStore,
    required this.view,
    required this.onNavigate,
    required this.onLogout,
    this.theme,
    this.onOpenSite,
    this.isDrawer = false,
    super.key,
  });

  final CatalogStore catalogStore;

  /// Vista atual; nula fora das vistas do painel.
  final PanelView? view;

  /// Tema escolhido em "Objetos digitais".
  final ThemeEnum? theme;

  /// Recebe o endereço escolhido; a casca navega e fecha a gaveta.
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;

  /// Com ação, "Ver site" aparece no pé, acima de "Sair" (na gaveta do celular).
  final VoidCallback? onOpenSite;

  /// Na gaveta, o foco vai para o item atual ao abrir.
  final bool isDrawer;

  static int get subthemeTotal =>
      ThemeDataModel.themes.fold(0, (total, theme) => total + theme.subthemes.length);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final onOpenSite = this.onOpenSite;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Seções do painel',
      child: Material(
        color: colors.page,
        child: Observer(
          builder: (context) {
            final state = catalogStore.state;
            final catalog = catalogStore.catalog;
            final isLoading = state.isInitial || state.isLoading;
            final onObjects = view == PanelView.objects;

            Widget spaced(Widget child, double spacing) => Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: child,
            );

            final themes = Container(
              margin: EdgeInsets.only(left: components.panelNavSubIndent),
              padding: EdgeInsets.only(
                left: components.panelNavSubPaddingStart,
                top: components.panelNavSubPaddingTop,
                bottom: components.panelNavSubPaddingBottom,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final model in ThemeDataModel.themes)
                    spaced(
                      PanelNavItem(
                        title: model.type.name,
                        count: catalog?.countByTheme(model.type),
                        isCountLoading: isLoading,
                        isSubItem: true,
                        isCurrent: onObjects && theme == model.type,
                        autofocus: isDrawer && onObjects && theme == model.type,
                        onTap: () => onNavigate(PanelAddress.objectsOf(theme: model.type)),
                      ),
                      components.panelNavSubItemSpacing,
                    ),
                ],
              ),
            );

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    components.panelSidebarPaddingH,
                    components.panelSidebarPaddingV,
                    components.panelSidebarPaddingH,
                    0,
                  ),
                  sliver: SliverList.list(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          components.panelNavItemPaddingH,
                          components.panelGroupLabelPaddingTop,
                          components.panelNavItemPaddingH,
                          components.panelGroupLabelPaddingBottom,
                        ),
                        child: Semantics(
                          header: true,
                          child: Text(
                            'CURADORIA',
                            semanticsLabel: 'Curadoria',
                            style: styles.panelGroupLabel.copyWith(color: colors.inkSecondary),
                          ),
                        ),
                      ),
                      spaced(
                        PanelNavItem(
                          title: 'Objetos digitais',
                          icon: Icons.layers_outlined,
                          count: catalog?.total,
                          isCountLoading: isLoading,
                          isCurrent: onObjects && theme == null,
                          isParentOfCurrent: onObjects && theme != null,
                          autofocus: isDrawer && onObjects && theme == null,
                          onTap: () => onNavigate(PanelAddress.objectsOf()),
                        ),
                        components.panelNavItemSpacing,
                      ),
                      themes,
                      spaced(
                        PanelNavItem(
                          title: 'Temas e subtemas',
                          icon: Icons.sell_outlined,
                          count: subthemeTotal,
                          isCurrent: view == PanelView.themes,
                          autofocus: isDrawer && view == PanelView.themes,
                          onTap: () => onNavigate(PanelAddress.of(PanelView.themes)),
                        ),
                        components.panelNavItemSpacing,
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: components.panelSidebarPaddingH,
                      vertical: components.panelSidebarPaddingV,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (onOpenSite != null)
                          spaced(
                            PanelNavItem(
                              title: 'Ver site',
                              icon: Icons.public,
                              trailingIcon: Icons.north_east,
                              isMuted: true,
                              isExternal: true,
                              onTap: onOpenSite,
                            ),
                            components.panelNavItemSpacing,
                          ),
                        PanelNavItem(
                          title: 'Sair',
                          icon: Icons.logout,
                          isMuted: true,
                          onTap: onLogout,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
