import "package:expogeo/core/components/icon/app_icon.dart";
import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/enums/app_icons.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding = 0,
  });

  final AppIcons icon;
  final VoidCallback onPressed;

  final double? size;

  final Color? iconColor;
  final Color? backgroundColor;

  final Color? borderColor;
  final double? borderRadius;

  final double padding;

  @override
  Widget build(BuildContext context) {
    final size = this.size?.scale;
    final iconSize = size != null ? size - padding * 2 : null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.colors.gray900,
          borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.dimensions.radius.gigantic),
          border: Border.all(
            color: borderColor ?? AppTheme.colors.gray900,
            width: AppTheme.dimensions.stroke.small,
          ),
        ),
        child: AppIcon(icon: icon, color: iconColor ?? AppTheme.colors.white, size: iconSize),
      ),
    );
  }
}
