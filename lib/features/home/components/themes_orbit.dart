import 'dart:math' as math;

import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class ThemesOrbit extends StatelessWidget {
  const ThemesOrbit({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final maxSide = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.orbitMaxMobile,
      Breakpoint.tablet => components.orbitMaxTablet,
      Breakpoint.desktop => components.orbitMaxDesktop,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, maxSide);
        final medallion = side * components.orbitMedallion;
        final middle = (side - medallion) / 2;
        final themes = ThemeDataModel.themes;

        // Norte, leste, sul e oeste, na ordem dos temas.
        final positions = [
          Offset(middle, 0),
          Offset(side - medallion, middle),
          Offset(middle, side - medallion),
          Offset(0, middle),
        ];

        // O Tab segue o sentido horário a partir do norte, e não a ordem de leitura.
        return FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: SizedBox.square(
            dimension: side,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(child: CustomPaint(painter: _OrbitPainter())),
                ),
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: Padding(
                      padding: EdgeInsets.all(side * components.orbitCoreInset),
                      child: Image.asset(AppImages.logoSimple.path, fit: BoxFit.contain),
                    ),
                  ),
                ),
                for (var i = 0; i < themes.length && i < positions.length; i++)
                  Positioned(
                    left: positions[i].dx,
                    top: positions[i].dy,
                    child: FocusTraversalOrder(
                      order: NumericFocusOrder(i.toDouble()),
                      child: Semantics(
                        sortKey: OrdinalSortKey(i.toDouble()),
                        child: _OrbitMedallion(theme: themes[i], size: medallion),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OrbitMedallion extends StatefulWidget {
  const _OrbitMedallion({required this.theme, required this.size});

  final ThemeModel theme;
  final double size;

  @override
  State<_OrbitMedallion> createState() => _OrbitMedallionState();
}

class _OrbitMedallionState extends State<_OrbitMedallion> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _open() => GoRouter.of(context).go(widget.theme.type.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final padding = widget.size * (components.orbitMedallionPadding / components.orbitMedallion);
    final radius = BorderRadius.circular(widget.size / 2);

    return Semantics(
      link: true,
      label: widget.theme.title,
      onTap: _open,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _hovered || _focused ? components.orbitHoverScale : 1,
        duration: reduceMotion ? Duration.zero : components.hoverAnimation,
        curve: Curves.easeOut,
        child: AppFocusRing(
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppTheme.dimensions.shadows.soft,
            ),
            child: Material(
              color: colors.page,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: SelectionContainer.disabled(
                child: InkWell(
                  focusNode: _focusNode,
                  customBorder: const CircleBorder(),
                  onTap: _open,
                  onHover: (value) => setState(() => _hovered = value),
                  onFocusChange: (value) => setState(() => _focused = value),
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  mouseCursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: AppMedallion(
                      size: widget.size - padding * 2,
                      image: widget.theme.type.illustration,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final center = size.center(Offset.zero);
    final side = size.shortestSide;

    final ringStroke = components.orbitRingStroke;
    final ringRadius = side * (0.5 - components.orbitRingInset) - ringStroke / 2;
    final ringBounds = Rect.fromCircle(center: center, radius: ringRadius + ringStroke / 2);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringStroke
      ..shader = AppTheme.gradients.brand.createShader(ringBounds)
      ..color = colors.black.withValues(alpha: components.orbitRingOpacity);
    canvas.drawCircle(center, ringRadius, ring);

    final dashedRadius = side * (0.5 - components.orbitDashedInset);
    final dashed = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = components.orbitDashedStroke
      ..color = colors.orbitDashed;
    final circumference = 2 * math.pi * dashedRadius;
    final period = components.orbitDashLength + components.orbitDashGap;
    final dashes = (circumference / period).floor();
    if (dashes <= 0) return;
    final step = 2 * math.pi / dashes;
    final sweep = step * components.orbitDashLength / period;
    final dashedBounds = Rect.fromCircle(center: center, radius: dashedRadius);
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(dashedBounds, i * step, sweep, false, dashed);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) => false;
}
