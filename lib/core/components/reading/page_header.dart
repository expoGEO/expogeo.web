import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.breadcrumbs,
    required this.title,
    this.lead,
    this.details,
    this.trailing,
    this.topAction,
  });

  final List<BreadcrumbItem> breadcrumbs;
  final String title;
  final String? lead;

  /// Entra abaixo do [lead].
  final Widget? details;

  /// À direita do texto no desktop; nas faixas menores, acima das migalhas.
  final Widget? trailing;

  /// À esquerda das migalhas; se não couberem lado a lado, elas descem de linha.
  final Widget? topAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final lead = this.lead;
    final details = this.details;
    final trailing = this.trailing;
    final topAction = this.topAction;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final paddingBottom = switch (breakpoint) {
      Breakpoint.mobile => components.pageHeadPaddingBottomMobile,
      Breakpoint.tablet => components.pageHeadPaddingBottomTablet,
      Breakpoint.desktop => components.pageHeadPaddingBottomDesktop,
    };

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (topAction == null)
          Align(
            alignment: Alignment.centerLeft,
            child: Breadcrumbs(items: breadcrumbs),
          )
        else
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: components.pageHeadTopGap,
            runSpacing: components.pageHeadTopGap,
            children: [
              topAction,
              Breadcrumbs(items: breadcrumbs),
            ],
          ),
        SizedBox(height: components.pageHeadTitleGap),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(title, style: styles.h1.copyWith(color: colors.ink)),
        ),
        if (lead != null) ...[
          SizedBox(height: components.pageHeadLeadGap),
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: components.readingMaxWidth),
              child: Text(lead, style: styles.reading.copyWith(color: colors.inkSecondary)),
            ),
          ),
        ],
        ?details,
      ],
    );

    final content = switch ((trailing, breakpoint)) {
      (null, _) => copy,
      (final trailing?, Breakpoint.desktop) => Row(
        children: [
          Expanded(child: copy),
          SizedBox(width: components.pageHeadColumnGap),
          trailing,
        ],
      ),
      (final trailing?, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(alignment: Alignment.centerLeft, child: trailing),
          SizedBox(height: components.pageHeadStackGap),
          copy,
        ],
      ),
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
          child: content,
        ),
      ),
    );
  }
}
