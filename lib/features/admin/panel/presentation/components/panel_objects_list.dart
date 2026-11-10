import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/components/skeleton/loading_region.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

/// Bloco com borda: as linhas, separadas por divisórias, e o rodapé com "Mostrar mais".
class PanelObjectsList extends StatelessWidget {
  const PanelObjectsList({required this.rows, required this.footer, this.onShowMore, super.key});

  final List<Widget> rows;

  /// "Mostrando X de Y".
  final String footer;

  /// Sem valor, não há mais itens e o botão some.
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final stroke = AppTheme.dimensions.stroke.small;
    final onShowMore = this.onShowMore;

    return _ListBox(
      divider: Divider(height: stroke, thickness: stroke, color: colors.line),
      children: [
        ...rows,
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: components.panelListFootMinHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: components.panelListFootPaddingH,
              vertical: components.panelListFootPaddingV,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    footer,
                    style: styles.panelListFoot.copyWith(color: colors.inkSecondary),
                  ),
                ),
                if (onShowMore != null) ...[
                  SizedBox(width: components.panelListFootGap),
                  AppButton.ghost(
                    text: 'Mostrar mais',
                    size: AppButtonSize.small,
                    onPressed: onShowMore,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Quatro linhas-esqueleto (círculo e duas linhas), lidas uma vez como "Carregando…".
class PanelObjectsSkeleton extends StatelessWidget {
  const PanelObjectsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final stroke = AppTheme.dimensions.stroke.small;
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final medallion = components.panelSubthemeMedallion;

    Widget line(double factor, double height) => FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: factor,
      child: AppSkeleton(height: height),
    );

    final row = Padding(
      padding: isMobile
          ? EdgeInsets.all(components.panelRowPaddingMobile)
          : EdgeInsets.symmetric(
              horizontal: components.panelRowPaddingH,
              vertical: components.panelRowPaddingV,
            ),
      child: Row(
        children: [
          AppSkeleton(width: medallion, height: medallion, radius: AppTheme.dimensions.radii.pill),
          SizedBox(width: isMobile ? components.panelRowGapMobileH : components.panelRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                line(components.panelSkeletonTitleWidth, components.panelSkeletonTitleHeight),
                SizedBox(height: components.panelSkeletonGap),
                line(components.panelSkeletonMetaWidth, components.panelSkeletonMetaHeight),
              ],
            ),
          ),
        ],
      ),
    );

    return LoadingRegion(
      child: _ListBox(
        divider: Divider(height: stroke, thickness: stroke, color: colors.line),
        children: [for (var i = 0; i < components.panelSkeletonRows; i++) row],
      ),
    );
  }
}

class _ListBox extends StatelessWidget {
  const _ListBox({required this.children, required this.divider});

  final List<Widget> children;
  final Widget divider;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(components.panelListRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: radius,
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[if (i > 0) divider, children[i]],
          ],
        ),
      ),
    );
  }
}
