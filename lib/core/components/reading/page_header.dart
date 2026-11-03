import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.breadcrumbs, required this.title, this.lead});

  final List<BreadcrumbItem> breadcrumbs;
  final String title;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final lead = this.lead;
    final paddingBottom = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.pageHeadPaddingBottomMobile,
      Breakpoint.tablet => components.pageHeadPaddingBottomTablet,
      Breakpoint.desktop => components.pageHeadPaddingBottomDesktop,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.only(top: components.pageHeadPaddingTop, bottom: paddingBottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Breadcrumbs(items: breadcrumbs),
              ),
              SizedBox(height: components.pageHeadTitleGap),
              Semantics(
                header: true,
                headingLevel: 1,
                child: Text(title, style: styles.h1.copyWith(color: colors.ink)),
              ),
              if (lead != null) ...[
                SizedBox(height: components.pageHeadLeadGap),
                Text(lead, style: styles.reading.copyWith(color: colors.inkSecondary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
