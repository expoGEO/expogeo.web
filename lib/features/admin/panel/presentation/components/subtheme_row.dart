import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

String objectsLabel(int count) => count == 1 ? '1 objeto' : '$count objetos';

/// Linha de consulta de um subtema: medalhão, nome, caminho no site, contagem e "Ver objetos".
class SubthemeRow extends StatefulWidget {
  const SubthemeRow({
    required this.subtheme,
    required this.onViewObjects,
    this.count,
    this.isCountLoading = false,
    super.key,
  });

  final SubthemeEnum subtheme;

  /// Some quando a contagem falhou; com [isCountLoading], vira esqueleto.
  final int? count;
  final bool isCountLoading;
  final VoidCallback onViewObjects;

  @override
  State<SubthemeRow> createState() => _SubthemeRowState();
}

class _SubthemeRowState extends State<SubthemeRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final subtheme = widget.subtheme;
    final count = widget.count;

    final medallion = AppMedallion(
      size: components.panelSubthemeMedallion,
      image: subtheme.illustration,
    );

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          subtheme.name,
          maxLines: components.panelRowTitleMaxLines,
          overflow: TextOverflow.ellipsis,
          style: styles.panelRowTitle.copyWith(color: colors.ink),
        ),
        SizedBox(height: components.panelRowMetaGap),
        Text(subtheme.route, style: styles.panelMeta.copyWith(color: colors.inkSecondary)),
      ],
    );

    final Widget? badge = widget.isCountLoading
        ? AppSkeleton(
            width: components.panelBadgeSkeletonWidth,
            height: components.panelBadgeSkeletonHeight,
            radius: AppTheme.dimensions.radii.pill,
          )
        : count == null
        ? null
        : DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
              border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
            ),
            child: Padding(
              padding: components.panelBadgePadding,
              child: Text(
                objectsLabel(count),
                maxLines: 1,
                style: styles.panelBadge.copyWith(color: colors.inkSecondary),
              ),
            ),
          );

    final action = AppIconButton(
      icon: Icons.format_list_bulleted,
      color: colors.inkSecondary,
      size: components.panelActionIcon,
      label: 'Ver objetos de ${subtheme.name}',
      tooltip: 'Ver os objetos deste subtema',
      onPressed: widget.onViewObjects,
    );

    final Widget content;
    if (isMobile) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              medallion,
              SizedBox(width: components.panelRowGapMobileH),
              Expanded(child: texts),
            ],
          ),
          SizedBox(height: components.panelRowGapMobileV),
          Row(children: [if (badge != null) badge, const Spacer(), action]),
        ],
      );
    } else {
      content = Row(
        children: [
          medallion,
          SizedBox(width: components.panelRowGap),
          Expanded(child: texts),
          if (badge != null) ...[SizedBox(width: components.panelRowGap), badge],
          SizedBox(width: components.panelRowGap),
          action,
        ],
      );
    }

    final padding = isMobile
        ? EdgeInsets.all(components.panelRowPaddingMobile)
        : EdgeInsets.symmetric(
            vertical: components.panelRowPaddingV,
            horizontal: components.panelRowPaddingH,
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: ColoredBox(
        color: _hovered ? colors.rowHover : Colors.transparent,
        child: Padding(padding: padding, child: content),
      ),
    );
  }
}
