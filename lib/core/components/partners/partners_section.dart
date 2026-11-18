import 'package:expogeo/core/components/partners/partner_logo_grid.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key, this.paddingTop});

  /// Sem valor, usa o espaçamento das seções da página.
  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final padding = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };

    return ColoredBox(
      color: colors.page,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.only(top: paddingTop ?? padding, bottom: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                headingLevel: 2,
                child: Text(
                  'Realização e apoio',
                  style: AppTheme.typography.of(context).h2.copyWith(color: colors.ink),
                ),
              ),
              SizedBox(height: components.sectionHeadGap),
              const PartnerLogoGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
