import "package:flutter/material.dart";
import "package:expogeo/core/theme/app_theme.dart";

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppTheme.colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.dimensions.radius.huge),
        border: Border.all(
          color: borderColor ?? AppTheme.colors.gray200,
          width: borderWidth ?? AppTheme.dimensions.stroke.small,
        ),
        boxShadow: boxShadow,
      ),
      margin: margin,
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }
}
