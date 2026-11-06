import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Topo da página do objeto. Voltar e migalhas vêm do endereço e aparecem em todos os estados;
/// sem [item], o resto vira esqueleto, ou some se [failed].
class ObjectHead extends StatelessWidget {
  const ObjectHead({
    super.key,
    required this.theme,
    required this.subtheme,
    this.item,
    this.failed = false,
  });

  final ThemeModel theme;
  final SubthemeModel subtheme;
  final CatalogItem? item;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final name = subtheme.type.name;
    final item = this.item;

    return Padding(
      padding: EdgeInsets.only(top: components.objectHeadPaddingTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: components.pageHeadTopGap,
            runSpacing: components.pageHeadTopGap,
            children: [
              Transform.translate(
                offset: Offset(components.pageHeadBackShift, 0),
                child: AppButton.ghost(
                  text: name,
                  semanticLabel: 'Voltar para $name',
                  size: AppButtonSize.small,
                  leadingIcon: Icons.arrow_back,
                  onPressed: () => context.go(subtheme.type.route),
                ),
              ),
              Breadcrumbs(
                items: [
                  BreadcrumbItem(theme.title, route: theme.type.route),
                  BreadcrumbItem(name, route: subtheme.type.route),
                  const BreadcrumbItem('Objeto'),
                ],
              ),
            ],
          ),
          if (item != null) _HeadText(item: item) else if (!failed) const _HeadSkeleton(),
        ],
      ),
    );
  }
}

double _leadSize(BuildContext context) {
  final components = AppTheme.dimensions.components;
  return switch (ScreenUtils.breakpointOf(context)) {
    Breakpoint.mobile => components.objectHeadLeadMobile,
    Breakpoint.tablet => components.objectHeadLeadTablet,
    Breakpoint.desktop => components.objectHeadLeadDesktop,
  };
}

class _HeadText extends StatelessWidget {
  const _HeadText({required this.item});

  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final origin = item.content.originInfo;
    final label = typeLine(origin.type, origin.format);
    final description = item.content.contentInfo.description.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: components.objectHeadTagGap),
        Row(
          children: [
            ExcludeSemantics(
              child: Container(
                width: components.objectCardIconBox,
                height: components.objectCardIconBox,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(components.objectCardIconRadius),
                ),
                child: Icon(
                  origin.type.cardIcon,
                  size: components.objectCardIcon,
                  color: colors.accent,
                ),
              ),
            ),
            SizedBox(width: components.objectCardGap),
            Expanded(
              // O rótulo em caixa alta seria soletrado; a leitura de tela recebe o texto normal.
              child: Semantics(
                container: true,
                label: label,
                excludeSemantics: true,
                child: Text(
                  label.toUpperCase(),
                  style: styles.label.copyWith(
                    fontSize: components.objectCardTypeText,
                    letterSpacing:
                        components.objectCardTypeText * components.objectCardTypeLetterSpacing,
                    color: colors.accent,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: components.objectHeadTitleGap),
        Semantics(
          container: true,
          header: true,
          headingLevel: 1,
          child: Text(item.content.contentInfo.title, style: styles.h1.copyWith(color: colors.ink)),
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: components.objectHeadLeadGap),
          Semantics(
            container: true,
            child: Text(
              description,
              style: styles.regular.copyWith(
                fontSize: _leadSize(context),
                height: components.objectHeadLeadHeight,
                color: colors.inkSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HeadSkeleton extends StatelessWidget {
  const _HeadSkeleton();

  @override
  Widget build(BuildContext context) {
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);
    final titleLine = styles.h1.fontSize! * styles.h1.height!;
    final leadLine = _leadSize(context) * components.objectHeadLeadHeight;
    final fill = components.objectCardSkeletonBarFill;
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    Widget line(double height, {bool short = false}) => FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: short ? components.objectCardSkeletonShortLine : 1,
      child: AppSkeleton(height: height * fill),
    );

    Widget button() => AppSkeleton(
      width: mobile ? null : components.objectHeadSkeletonButton,
      height: components.buttonMinHeightRegular,
      radius: dimensions.radii.r10,
    );

    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: components.objectHeadTagGap),
          Row(
            children: [
              AppSkeleton(
                width: components.objectCardIconBox,
                height: components.objectCardIconBox,
                radius: components.objectCardIconRadius,
              ),
              SizedBox(width: components.objectCardGap),
              AppSkeleton(
                width: components.objectCardSkeletonTypeWidth,
                height: components.objectCardTypeText,
              ),
            ],
          ),
          SizedBox(height: components.objectHeadTitleGap),
          line(titleLine),
          SizedBox(height: titleLine * (1 - fill)),
          line(titleLine, short: true),
          SizedBox(height: components.objectHeadLeadGap),
          line(leadLine),
          SizedBox(height: leadLine * (1 - fill)),
          line(leadLine, short: true),
          SizedBox(height: components.objectHeadActionsGap),
          if (mobile) ...[
            button(),
            SizedBox(height: components.objectActionsGap),
            button(),
          ] else
            Row(
              children: [
                button(),
                SizedBox(width: components.objectActionsGap),
                button(),
              ],
            ),
        ],
      ),
    );
  }
}
