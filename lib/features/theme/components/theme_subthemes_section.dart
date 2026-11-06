import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_overview_card.dart';
import 'package:flutter/material.dart';

class ThemeSubthemesSection extends StatelessWidget {
  const ThemeSubthemesSection({super.key, required this.theme, this.store});

  final ThemeModel theme;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  static int columnsFor(Breakpoint breakpoint) {
    final components = AppTheme.dimensions.components;
    return switch (breakpoint) {
      Breakpoint.mobile => components.subthemeColumnsMobile,
      Breakpoint.tablet => components.subthemeColumnsTablet,
      Breakpoint.desktop => components.subthemeColumnsDesktop,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final subthemes = theme.subthemes;
    final columns = columnsFor(breakpoint);
    final rows = (subthemes.length / columns).ceil();
    final gap = breakpoint == Breakpoint.mobile
        ? components.subthemeGridGapMobile
        : components.subthemeGridGap;

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(top: components.subthemeSectionTop),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              headingLevel: 2,
              child: Text(
                subthemes.length == 1 ? '1 subtema' : '${subthemes.length} subtemas',
                style: styles.h2.copyWith(color: colors.ink),
              ),
            ),
            SizedBox(height: components.subthemeSectionHeadGap),
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var column = 0; column < columns; column++) ...[
                      if (column > 0) SizedBox(width: gap),
                      Expanded(
                        child: row * columns + column < subthemes.length
                            ? SubthemeOverviewCard(
                                subtheme: subthemes[row * columns + column],
                                store: store,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
