import 'dart:math' as math;

import 'package:expogeo/core/components/brand/app_brand.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/login/presentation/components/login_rings_painter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key, this.compact = false});

  /// Faixa no topo, só com marca, rótulo e título.
  final bool compact;

  // A página mede a altura das colunas pelo IntrinsicHeight, que ignora larguras máximas; por isso
  // a largura vem da tela e o limite do texto vira margem.
  double _contentWidth(BuildContext context, Breakpoint breakpoint) {
    final components = AppTheme.dimensions.components;
    final width = MediaQuery.sizeOf(context).width;
    final column = compact
        ? width
        : width *
              components.loginBrandFlex /
              (components.loginBrandFlex + components.loginFormFlex);
    return column - 2 * components.loginBrandPaddingH(breakpoint);
  }

  double _slack(double available, double maxWidth) => math.max(0, available - maxWidth);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.loginBrandGap(breakpoint);
    final titleStyle = styles.loginBrandTitle.copyWith(color: colors.white);
    final contentWidth = _contentWidth(context, breakpoint);

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Painel da curadoria'.toUpperCase(),
          style: styles.label.copyWith(color: colors.footerHighlight),
        ),
        SizedBox(height: components.loginEyebrowGap),
        Padding(
          padding: EdgeInsets.only(
            right: _slack(
              contentWidth,
              titleStyle.fontSize! * components.loginBrandTitleMaxWidthEm,
            ),
          ),
          child: Semantics(
            header: true,
            headingLevel: 1,
            child: Text('Cuide da curadoria da expoGEO.', style: titleStyle),
          ),
        ),
        if (!compact) ...[
          SizedBox(height: components.loginBrandLeadGap),
          Padding(
            padding: EdgeInsets.only(
              right: _slack(contentWidth, components.loginBrandLeadMaxWidth),
            ),
            child: Text(
              'Cadastre, revise e organize os objetos digitais de cada tema e subtema.',
              style: styles.regular.copyWith(color: colors.footerText),
            ),
          ),
        ],
      ],
    );

    return ColoredBox(
      color: colors.footerBackground,
      child: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: IgnorePointer(
                child: ClipRect(
                  child: CustomPaint(
                    painter: LoginRingsPainter(
                      color: colors.footerHighlight.withValues(alpha: components.loginRingsOpacity),
                      step: components.loginRingsStep,
                      stroke: components.loginRingsStroke,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: components.loginBrandPaddingH(breakpoint),
              vertical: components.loginBrandPaddingV(breakpoint),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              children: [
                AppBrand(
                  onDark: true,
                  tagline: 'Curadoria digital do saber geográfico',
                  onTap: () => context.go(AppRouter.home),
                ),
                SizedBox(height: gap),
                heading,
                if (!compact) ...[
                  SizedBox(height: gap),
                  Text(
                    'Sem acesso? Peça a quem administra o painel para criar seu usuário.',
                    style: styles.small.copyWith(color: colors.footerSubtle),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
