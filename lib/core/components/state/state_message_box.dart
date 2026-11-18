import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/accessibility/announce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

enum StateMessageTone { neutral, error }

class StateMessageBox extends StatefulWidget {
  const StateMessageBox({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.message,
    this.action,
    this.tone = StateMessageTone.neutral,
    this.headingLevel,
    this.announce = true,
  }) : assert(icon != null || leading != null, 'A caixa precisa de um ícone ou de um topo.');

  final IconData? icon;

  /// Ocupa o lugar do ícone em círculo.
  final Widget? leading;

  final String title;
  final String? message;
  final Widget? action;
  final StateMessageTone tone;

  /// Faz do título um cabeçalho desse nível.
  final int? headingLevel;

  /// Lê o título ao aparecer. Uma página inteira dispensa, porque a leitura já começa pelo título.
  final bool announce;

  @override
  State<StateMessageBox> createState() => _StateMessageBoxState();
}

class _StateMessageBoxState extends State<StateMessageBox> {
  bool get _isError => widget.tone == StateMessageTone.error;

  @override
  void initState() {
    super.initState();
    if (!widget.announce) return;
    // O motor web não lê a caixa só pelo papel de alerta ou de status quando ela entra na tela.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announceToScreenReader(
        widget.title,
        Directionality.of(context),
        assertiveness: _isError ? Assertiveness.assertive : Assertiveness.polite,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);
    final message = widget.message;
    final action = widget.action;
    final headingLevel = widget.headingLevel;
    final (iconBackground, iconColor) = _isError
        ? (colors.errorSurface, colors.error)
        : (colors.surface, colors.inkSecondary);

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
            child: Semantics(
              container: true,
              role: _isError ? SemanticsRole.alert : SemanticsRole.status,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child:
                        widget.leading ??
                        Container(
                          width: components.stateBoxIcon,
                          height: components.stateBoxIcon,
                          decoration: BoxDecoration(color: iconBackground, shape: BoxShape.circle),
                          child: Icon(
                            widget.icon,
                            size: components.stateBoxIconGlyph,
                            color: iconColor,
                          ),
                        ),
                  ),
                  SizedBox(height: components.stateBoxGap),
                  Semantics(
                    container: true,
                    header: headingLevel != null,
                    headingLevel: headingLevel,
                    child: Text(
                      widget.title,
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
                    // Sem nó próprio, o botão se fundiria ao nó do alerta e perderia o papel de botão.
                    Semantics(container: true, child: action),
                  ],
                ],
              ),
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
