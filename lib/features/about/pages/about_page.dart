import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/partners/partners_section.dart';
import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:expogeo/core/components/reading/reading_column.dart';
import 'package:expogeo/core/components/structure/observatory_card.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/about/components/reference_code_example.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<String> paragraphs = [
    'A expoGEO é um espaço pensado para estudantes, professores e todos que se interessam por '
        'compreender o mundo a partir da Geografia. Aqui você encontra uma seleção cuidadosa de '
        'conteúdos digitais que abordam os principais temas geográficos de forma dinâmica, '
        'interativa e pedagogicamente qualificada.',
    'Reunimos materiais confiáveis, recursos educacionais digitais e propostas inovadoras que '
        'potencializam os processos de ensino e aprendizagem da Geografia escolar, aproximando '
        'conhecimento científico, práticas pedagógicas e tecnologias contemporâneas.',
    'O projeto integra as ações do Programa de Pós-Graduação em Educação da Universidade Federal '
        'de Uberlândia (PPGED/UFU) e foi desenvolvido no âmbito do Observatório do Ensino de '
        'História e Geografia (OEHGEO/UFU), fortalecendo a articulação entre pesquisa, formação '
        'docente e curadoria de conteúdos educacionais.',
  ];

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

    return SiteScaffold(
      slivers: [
        const SliverToBoxAdapter(
          child: PageHeader(
            breadcrumbs: [
              BreadcrumbItem('Início', route: AppRouter.home),
              BreadcrumbItem('Sobre'),
            ],
            title: 'Sobre a expoGEO',
            lead: 'Conhecimento, tecnologia e interatividade a serviço do ensino de Geografia.',
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
    );
  }
}
