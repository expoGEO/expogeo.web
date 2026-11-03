import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/home/components/theme_overview_card.dart';
import 'package:flutter/material.dart';

class HomeThemesSection extends StatelessWidget {
  const HomeThemesSection({super.key, required this.titleFocusNode});

  /// Recebe o foco quando a página leva a pessoa até aqui.
  final FocusNode titleFocusNode;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final padding = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };

    return PageContent(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Temas'.toUpperCase(), style: styles.label.copyWith(color: colors.accent)),
            SizedBox(height: components.sectionLabelGap),
            Focus(
              focusNode: titleFocusNode,
              child: Semantics(
                header: true,
                headingLevel: 2,
                child: Text('Por onde começar', style: styles.h2.copyWith(color: colors.ink)),
              ),
            ),
            SizedBox(height: components.sectionHeadGap),
            const _ThemesGrid(),
          ],
        ),
      ),
    );
  }
}

class _ThemesGrid extends StatelessWidget {
  const _ThemesGrid();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final gap = components.themeGridGap;
    final themes = ThemeDataModel.themes;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < components.themeGridTwoColumnsWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < themes.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                ThemeOverviewCard(theme: themes[i]),
              ],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < themes.length; i += 2) ...[
              if (i > 0) SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: ThemeOverviewCard(theme: themes[i])),
                    SizedBox(width: gap),
                    Expanded(
                      child: i + 1 < themes.length
                          ? ThemeOverviewCard(theme: themes[i + 1])
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
