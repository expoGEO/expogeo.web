import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  final Widget child;

  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      padding: padding ?? EdgeInsets.all(AppTheme.dimensions.space.large.scale),
      decoration: BoxDecoration(
        color: color ?? AppTheme.colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.dimensions.radius.large),
        border:
            border ??
            Border(
              bottom: BorderSide(
                color: AppTheme.colors.gray300,
                width: AppTheme.dimensions.stroke.medium,
              ),
            ),
        boxShadow: boxShadow,
      ),

      child: child,
    );
  }
}
