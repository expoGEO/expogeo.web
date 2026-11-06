import 'package:expogeo/core/components/button/inline_link.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final padding = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.contactInfoPaddingMobile,
      Breakpoint.tablet => components.contactInfoPaddingTablet,
      Breakpoint.desktop => components.contactInfoPaddingDesktop,
    };
    final domain = UrlUtils.displayDomain(AppLinks.observatory);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text('Outros meios', style: styles.h3.copyWith(color: colors.ink)),
          ),
          SizedBox(height: components.contactInfoListTop),
          const _InfoItem(
            label: 'E-mail',
            child: InlineLink(text: AppLinks.email, url: AppLinks.emailUrl),
          ),
          SizedBox(height: components.contactInfoItemGap),
          _InfoItem(
            label: 'Endereço',
            child: Text(
              AppLinks.address.join('\n'),
              style: styles.regular.copyWith(color: colors.ink),
            ),
          ),
          SizedBox(height: components.contactInfoItemGap),
          _InfoItem(
            label: 'Observatório',
            child: InlineLink(
              text: domain,
              url: AppLinks.observatory,
              semanticLabel: '$domain, abre em nova aba',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          semanticsLabel: label,
          style: AppTheme.typography
              .of(context)
              .label
              .copyWith(color: AppTheme.colors.inkSecondary),
        ),
        SizedBox(height: AppTheme.dimensions.components.contactInfoLabelGap),
        child,
      ],
    );
  }
}
