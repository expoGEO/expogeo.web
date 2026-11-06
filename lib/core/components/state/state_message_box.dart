import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum StateMessageTone { neutral, error }

class StateMessageBox extends StatelessWidget {
  const StateMessageBox({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.tone = StateMessageTone.neutral,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final StateMessageTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);
    final message = this.message;
    final action = this.action;
    final (iconBackground, iconColor) = switch (tone) {
      StateMessageTone.neutral => (colors.surface, colors.inkSecondary),
      StateMessageTone.error => (colors.errorSurface, colors.error),
    };

    return Padding(
      padding: EdgeInsets.only(
        top: components.stateBoxMarginTop,
        bottom: components.stateBoxMarginBottom,
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: colors.stateBoxBorder,
          radius: dimensions.radii.r18,
          strokeWidth: dimensions.stroke.small,
          dash: components.stateBoxDashLength,
          gap: components.stateBoxDashGap,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: components.stateBoxPaddingVertical,
            horizontal: components.stateBoxPaddingHorizontal,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: components.stateBoxIcon,
                    height: components.stateBoxIcon,
                    decoration: BoxDecoration(color: iconBackground, shape: BoxShape.circle),
                    child: Icon(icon, size: components.stateBoxIconGlyph, color: iconColor),
                  ),
                ),
                SizedBox(height: components.stateBoxGap),
                Semantics(
                  container: true,
                  liveRegion: true,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: styles.h3.copyWith(
                      fontSize: components.stateBoxTitle,
                      color: colors.ink,
                    ),
                  ),
                ),
                if (message != null) ...[
                  SizedBox(height: components.stateBoxGap),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: components.stateBoxTextMaxWidth),
                    child: Semantics(
                      container: true,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: styles.regular.copyWith(color: colors.inkSecondary),
                      ),
                    ),
                  ),
                ],
                if (action != null) ...[
                  SizedBox(height: components.stateBoxGap + components.stateBoxButtonGap),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// O `Border` do Flutter não desenha tracejado.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final outline = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in (Path()..addRRect(outline)).computeMetrics()) {
      var start = 0.0;
      while (start < metric.length) {
        canvas.drawPath(metric.extractPath(start, start + dash), paint);
        start += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}
