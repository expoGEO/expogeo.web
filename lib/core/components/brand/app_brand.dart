import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

/// Símbolo + "expoGEO" + linha opcional.
class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.tagline, this.onDark = false, this.onTap});

  final String? tagline;
  final bool onDark;

  /// Com ação, a marca vira link para a página inicial.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    final nameStyle = styles.h3.copyWith(
      fontSize: components.brandName,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: components.brandName * -0.03,
      color: onDark ? colors.white : colors.ink,
    );

    Widget mark = Image.asset(
      AppImages.logoSimple.path,
      width: components.brandMark,
      height: components.brandMark,
      fit: BoxFit.contain,
    );
    if (onDark) {
      // O símbolo tem partes escuras que somem no fundo do rodapé.
      mark = DecoratedBox(
        decoration: BoxDecoration(color: colors.white, shape: BoxShape.circle),
        child: Padding(padding: EdgeInsets.all(AppTheme.dimensions.stroke.medium), child: mark),
      );
    }

    final tagline = this.tagline;
    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: spacing.s12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'expo',
                  children: [
                    TextSpan(
                      text: 'GEO',
                      style: TextStyle(color: onDark ? colors.footerHighlight : colors.accent),
                    ),
                  ],
                ),
                style: nameStyle,
              ),
              if (tagline != null)
                Text(
                  tagline,
                  style: styles.small.copyWith(
                    fontSize: components.brandTagline,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: onDark ? colors.footerSubtle : colors.inkSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    final onTap = this.onTap;
    if (onTap == null) {
      return Semantics(
        container: true,
        label: tagline == null ? 'expoGEO' : 'expoGEO, $tagline',
        excludeSemantics: true,
        child: brand,
      );
    }

    return Semantics(
      link: true,
      label: 'expoGEO, página inicial',
      onTap: onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        color: onDark ? colors.footerHighlight : null,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          hoverColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          child: brand,
        ),
      ),
    );
  }
}
