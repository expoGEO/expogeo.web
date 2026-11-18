import 'package:expogeo/core/components/partners/partner_logo.dart';
import 'package:expogeo/core/models/partner.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class PartnerLogoGrid extends StatelessWidget {
  const PartnerLogoGrid({super.key});

  static int columnsFor(Breakpoint breakpoint) {
    final components = AppTheme.dimensions.components;
    return switch (breakpoint) {
      Breakpoint.mobile => components.partnerColumnsMobile,
      Breakpoint.tablet => components.partnerColumnsTablet,
      Breakpoint.desktop => components.partnerColumnsDesktop,
    };
  }

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.partnerGap;
    const partners = Partner.values;
    final columns = columnsFor(ScreenUtils.breakpointOf(context));
    final rows = (partners.length / columns).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < rows; row++) ...[
          if (row > 0) SizedBox(height: gap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columns; column++) ...[
                if (column > 0) SizedBox(width: gap),
                Expanded(
                  child: row * columns + column < partners.length
                      ? PartnerLogo(partner: partners[row * columns + column])
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
