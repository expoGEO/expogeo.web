import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeAboutSection extends StatelessWidget {
  const HomeAboutSection({super.key});

  static const List<(IconData, String, String)> audiences = [
    (
      Icons.school_outlined,
      'Estudantes',
      'Conteúdos para estudar e aprofundar cada tema, com acesso direto à fonte.',
    ),
    (
      Icons.edit_outlined,
      'Professores',
      'Recursos já descritos e organizados por assunto para levar à sala de aula.',
    ),
    (
      Icons.explore_outlined,
      'Interessados em Geografia',
      'Um ponto de partida confiável para compreender o mundo a partir do espaço.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final padding = switch (breakpoint) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sobre a superfície, o laranja de link fica abaixo de 4,5:1.
        Text(
          'Sobre a expoGEO'.toUpperCase(),
          style: styles.label.copyWith(color: colors.accentStrong),
        ),
        SizedBox(height: components.aboutTitleTop),
        Semantics(
          header: true,
          headingLevel: 2,
          child: Text(
            'Uma curadoria feita na universidade, pensada para a escola.',
            style: styles.h2.copyWith(color: colors.ink),
          ),
        ),
        SizedBox(height: components.aboutTitleBottom),
        Text(
          'Reunimos materiais confiáveis e recursos educacionais digitais que aproximam '
          'conhecimento científico, práticas pedagógicas e tecnologias contemporâneas.',
          style: styles.reading.copyWith(color: colors.inkSecondary),
        ),
        SizedBox(height: components.aboutLinkTop),
        const _AboutLink(),
      ],
    );

    final audienceList = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < audiences.length; i++)
          _Audience(
            icon: audiences[i].$1,
            title: audiences[i].$2,
            text: audiences[i].$3,
            isLast: i == audiences.length - 1,
          ),
      ],
    );

    return ColoredBox(
      color: colors.surface,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: breakpoint == Breakpoint.desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 100, child: intro),
                    SizedBox(width: components.aboutColumnGap),
                    Expanded(flex: 115, child: audienceList),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    intro,
                    SizedBox(height: components.sectionHeadGap),
                    audienceList,
                  ],
                ),
        ),
      ),
    );
  }
}

class _Audience extends StatelessWidget {
  const _Audience({
    required this.icon,
    required this.title,
    required this.text,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final line = BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: line, bottom: isLast ? line : BorderSide.none),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: components.aboutAudiencePadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Container(
                width: components.aboutAudienceIcon,
                height: components.aboutAudienceIcon,
                decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
                child: Icon(icon, size: components.aboutAudienceGlyph, color: colors.accentStrong),
              ),
            ),
            SizedBox(width: components.aboutAudienceGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    headingLevel: 3,
                    child: Text(
                      title,
                      style: styles.h3.copyWith(
                        fontSize: components.aboutAudienceTitle,
                        color: colors.ink,
                      ),
                    ),
                  ),
                  SizedBox(height: components.aboutAudienceTextGap),
                  Text(
                    text,
                    style: styles.regular.copyWith(
                      fontSize: components.aboutAudienceText,
                      color: colors.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutLink extends StatefulWidget {
  const _AboutLink();

  @override
  State<_AboutLink> createState() => _AboutLinkState();
}

class _AboutLinkState extends State<_AboutLink> {
  bool _hovered = false;

  void _open() => GoRouter.of(context).go(AppRouter.about);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    final style = AppTheme.typography
        .of(context)
        .regular
        .copyWith(
          fontWeight: FontWeight.w600,
          color: colors.accentStrong,
          decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
          decorationColor: colors.accentStrong,
        );

    return Semantics(
      link: true,
      label: 'Saiba mais sobre o projeto',
      linkUrl: Uri.parse(AppRouter.about),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: SelectionContainer.disabled(
            child: InkWell(
              onTap: _open,
              onHover: (value) => setState(() => _hovered = value),
              borderRadius: radius,
              splashFactory: NoSplash.splashFactory,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              mouseCursor: SystemMouseCursors.click,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: components.minTapTarget),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: Text('Saiba mais sobre o projeto', style: style)),
                    SizedBox(width: components.aboutLinkGap),
                    Icon(Icons.arrow_forward, size: style.fontSize, color: colors.accentStrong),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
