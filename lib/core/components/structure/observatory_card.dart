import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Cartão que apresenta o Observatório, do qual a expoGEO faz parte.
class ObservatoryCard extends StatelessWidget {
  const ObservatoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final inRow = breakpoint == Breakpoint.desktop;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r20);

    final symbol = ExcludeSemantics(
      child: SvgPicture.asset(
        AppImages.observatorioSimbolo.path,
        width: components.observatorySymbol,
        height: components.observatorySymbol,
      ),
    );

    final text = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: components.observatoryTextMaxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'A expoGEO faz parte do'.toUpperCase(),
            style: styles.label.copyWith(color: colors.footerHighlight),
          ),
          SizedBox(height: components.observatoryTitleGap),
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text(
              'Observatório do Ensino de História e Geografia',
              style: styles.h2.copyWith(color: colors.white),
            ),
          ),
          SizedBox(height: components.observatoryTextGap),
          Text(
            'Narrativas, pesquisas, documentos e uma biblioteca de teses e dissertações '
            'sobre o ensino de História e Geografia.',
            style: styles.regular.copyWith(color: colors.footerText),
          ),
        ],
      ),
    );

    const button = AppButton.primary(
      text: 'Visitar o Observatório',
      externalUrl: AppLinks.observatory,
    );

    final Widget content = inRow
        ? Row(
            children: [
              symbol,
              SizedBox(width: components.observatoryRowGap),
              Expanded(
                child: Align(alignment: Alignment.centerLeft, child: text),
              ),
              SizedBox(width: components.observatoryRowGap),
              button,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              symbol,
              SizedBox(height: components.observatoryStackGap),
              text,
              SizedBox(height: components.observatoryStackGap),
              button,
            ],
          );

    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: colors.footerBackground,
        child: CustomPaint(
          painter: _CornerCirclesPainter(
            color: colors.footerHighlight.withValues(alpha: components.observatoryCirclesOpacity),
            step: components.observatoryCirclesStep,
            count: components.observatoryCirclesCount,
            stroke: AppTheme.dimensions.stroke.small,
          ),
          child: Padding(
            padding: EdgeInsets.all(
              breakpoint == Breakpoint.mobile
                  ? components.observatoryPaddingMobile
                  : components.observatoryPadding,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _CornerCirclesPainter extends CustomPainter {
  const _CornerCirclesPainter({
    required this.color,
    required this.step,
    required this.count,
    required this.stroke,
  });

  final Color color;
  final double step;
  final int count;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final center = Offset(size.width, 0);
    for (var i = 1; i <= count; i++) {
      canvas.drawCircle(center, step * i, paint);
    }
  }

  @override
  bool shouldRepaint(_CornerCirclesPainter oldDelegate) =>
      color != oldDelegate.color ||
      step != oldDelegate.step ||
      count != oldDelegate.count ||
      stroke != oldDelegate.stroke;
}
