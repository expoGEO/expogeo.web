import "package:expogeo/core/components/icon/app_icon.dart";
import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/enums/app_icons.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class RoundedAppIcon extends StatelessWidget {
  const RoundedAppIcon({
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.size,
    super.key,
  });

  final AppIcons icon;

  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;

  final double? size;

  @override
  Widget build(BuildContext context) {
    final size = this.size?.scale;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(AppTheme.dimensions.space.mini.scale),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor ?? backgroundColor ?? AppTheme.colors.gray200),
      ),
      child: Center(
        child: AppIcon(
          icon: icon,
          color: iconColor ?? AppTheme.colors.white,
          size: size != null ? size / 2 : null,
        ),
      ),
    );
  }
}
