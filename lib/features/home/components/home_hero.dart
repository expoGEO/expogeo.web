import 'dart:math' as math;

import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/home/components/hero_counts.dart';
import 'package:expogeo/features/home/components/themes_orbit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.onExploreThemes});

  final VoidCallback onExploreThemes;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final padding = switch (breakpoint) {
      Breakpoint.mobile => components.heroPaddingMobile,
      Breakpoint.tablet => components.heroPaddingTablet,
      Breakpoint.desktop => components.heroPaddingDesktop,
    };

    // O texto vem antes do anel para o leitor de tela, mesmo quando o anel aparece em cima.
    final text = Semantics(
      container: true,
      explicitChildNodes: true,
      sortKey: const OrdinalSortKey(0),
      child: _HeroText(onExploreThemes: onExploreThemes),
    );
    final orbit = Semantics(
      container: true,
      explicitChildNodes: true,
      sortKey: const OrdinalSortKey(1),
      child: const Center(child: ThemesOrbit()),
    );

    final Widget content = breakpoint == Breakpoint.desktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 115, child: text),
              SizedBox(width: components.heroColumnGap),
              Expanded(flex: 100, child: orbit),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              orbit,
              SizedBox(
                height: breakpoint == Breakpoint.mobile
                    ? components.heroStackGap
                    : components.heroColumnGap,
              ),
              text,
            ],
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: ClipRect(child: CustomPaint(painter: _HeroCirclesPainter())),
            ),
          ),
          PageContent(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.onExploreThemes});

  final VoidCallback onExploreThemes;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Curadoria digital do saber geográfico'.toUpperCase(),
          style: styles.label.copyWith(color: colors.accentStrong),
        ),
        SizedBox(height: components.heroTitleGap),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Conteúdos digitais de Geografia, '),
                TextSpan(
                  text: 'escolhidos para a sala de aula.',
                  style: TextStyle(color: colors.accentStrong),
                ),
              ],
            ),
            style: styles.h1.copyWith(color: colors.ink),
          ),
        ),
        SizedBox(height: components.heroLeadGap),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: components.heroLeadMaxWidth),
          child: Text(
            'Sites, vídeos, mapas e aplicativos confiáveis, organizados por tema para '
            'estudantes, professores e quem quer entender o mundo pela Geografia.',
            style: styles.reading.copyWith(color: colors.inkSecondary),
          ),
        ),
        SizedBox(height: components.heroActionsGap),
        Wrap(
          spacing: spacing.s12,
          runSpacing: spacing.s12,
          children: [
            AppButton.primary(
              text: 'Explorar os temas',
              trailingIcon: Icons.arrow_downward,
              onPressed: onExploreThemes,
            ),
            AppButton.secondary(
              text: 'Como fazemos a curadoria',
              onPressed: () => GoRouter.of(context).go(AppRouter.about),
            ),
          ],
        ),
        const HeroCounts(),
      ],
    );
  }
}

/// Dois conjuntos de círculos concêntricos finos, esmaecendo para baixo.
class _HeroCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final stroke = AppTheme.dimensions.stroke.small;
    final bounds = Offset.zero & size;

    canvas.saveLayer(bounds, Paint());
    _drawRings(
      canvas,
      size,
      center: components.heroCirclesAccentCenter,
      step: components.heroCirclesAccentStep,
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = colors.accent.withValues(alpha: components.heroCirclesAccentOpacity),
    );
    _drawRings(
      canvas,
      size,
      center: components.heroCirclesInkCenter,
      step: components.heroCirclesInkStep,
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = colors.ink.withValues(alpha: components.heroCirclesInkOpacity),
    );

    final fade = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [components.heroCirclesFadeStart, 1],
      colors: [colors.black, colors.black.withValues(alpha: 0)],
    );
    canvas.drawRect(
      bounds,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = fade.createShader(bounds),
    );
    canvas.restore();
  }

  void _drawRings(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double step,
    required Paint paint,
  }) {
    final origin = Offset(size.width * center.dx, size.height * center.dy);
    final reach = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((corner) => (corner - origin).distance).reduce(math.max);

    for (var radius = step - paint.strokeWidth / 2; radius <= reach; radius += step) {
      canvas.drawCircle(origin, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_HeroCirclesPainter oldDelegate) => false;
}
