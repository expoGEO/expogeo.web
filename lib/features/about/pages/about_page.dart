import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/partners/partners_section.dart';
import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:expogeo/core/components/reading/reading_column.dart';
import 'package:expogeo/core/components/structure/observatory_card.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/components/structure/page_meta_scope.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/constants/site_copy.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/about/components/reference_code_example.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<String> paragraphs = SiteCopy.aboutParagraphs;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final reading = styles.reading.copyWith(color: colors.ink);
    final sectionPadding = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };

    return PageMetaScope(
      meta: PageMeta.titled(
        title: SiteCopy.aboutTitle,
        description: summarize(SiteCopy.aboutParagraphs.first),
        path: AppRouter.about,
      ),
      child: SiteScaffold(
        slivers: [
          const SliverToBoxAdapter(
            child: PageHeader(
              breadcrumbs: [
                BreadcrumbItem('Início', route: AppRouter.home),
                BreadcrumbItem('Sobre'),
              ],
              title: SiteCopy.aboutTitle,
              lead: SiteCopy.aboutLead,
            ),
          ),
          SliverToBoxAdapter(
            child: ReadingColumn(
              children: [
                for (var i = 0; i < paragraphs.length; i++) ...[
                  if (i > 0) SizedBox(height: components.readingParagraphGap),
                  Text(paragraphs[i], style: reading),
                ],
                SizedBox(height: components.readingSectionGap),
                Semantics(
                  header: true,
                  headingLevel: 2,
                  child: Text(
                    'Como cada objeto é descrito',
                    style: styles.h2.copyWith(color: colors.ink),
                  ),
                ),
                SizedBox(height: components.readingHeadingGap),
                Text(
                  'Todo objeto digital recebe uma ficha com autoria, conteúdo, origem, registro, '
                  'direitos e ação de preservação. O código de referência diz onde ele está na '
                  'curadoria:',
                  style: reading,
                ),
                SizedBox(height: components.readingBlockGap),
                const ReferenceCodeExample(),
                SizedBox(height: components.readingBlockGap),
                Text(
                  'Os links são revisados ao longo do tempo para que continuem funcionando.',
                  style: reading,
                ),
                SizedBox(height: components.readingBlockGap),
                Wrap(
                  spacing: spacing.s12,
                  runSpacing: spacing.s12,
                  children: const [
                    AppButton.secondary(
                      text: 'Metadados da curadoria',
                      externalUrl: AppLinks.curationMetadata,
                    ),
                    AppButton.secondary(text: 'Tese de doutorado', externalUrl: AppLinks.thesis),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(child: PartnersSection(paddingTop: components.readingSectionGap)),
          SliverToBoxAdapter(
            child: PageContent(
              child: Padding(
                padding: EdgeInsets.only(bottom: sectionPadding),
                child: const ObservatoryCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
