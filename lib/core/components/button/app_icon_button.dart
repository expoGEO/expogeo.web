import "package:expogeo/core/components/icon/app_icon.dart";
import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/enums/app_icons.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.label,
    this.color,
    this.iconSize,
    super.key,
  });

  final AppIcons icon;
  final VoidCallback onPressed;

  final String? label;
  final Color? color;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.gray900),
            ),
            SizedBox(width: AppTheme.dimensions.space.small.width),
          ],
          AppIcon(icon: icon, size: iconSize ?? 24, color: color ?? AppTheme.colors.gray900),
        ],
      ),
    );
  }
}
