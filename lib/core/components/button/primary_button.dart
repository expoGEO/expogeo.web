import "package:expogeo/core/components/icon/app_icon.dart";
import "package:expogeo/core/components/loading/circular_loading.dart";
import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/enums/app_icons.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.label,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;

  final double? borderRadius;

  final AppIcons? leadingIcon;
  final AppIcons? trailingIcon;

  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isDisabled || isLoading ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled || isLoading ? null : onPressed,
        child: Container(
          padding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
          decoration: BoxDecoration(
            color: isDisabled ? AppTheme.colors.gray200 : AppTheme.colors.gray900,
            borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.dimensions.radius.huge),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null && !isLoading) ...[
                AppIcon(icon: leadingIcon!, color: AppTheme.colors.white, size: 24),
                SizedBox(width: AppTheme.dimensions.space.small.width),
              ],
              if (isLoading)
                CircularLoading(color: AppTheme.colors.white)
              else
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTheme.typography.body.medium.copyWith(
                      color: isDisabled ? AppTheme.colors.gray500 : AppTheme.colors.white,
                    ),
                  ),
                ),
              if (trailingIcon != null) ...[
                SizedBox(width: AppTheme.dimensions.space.small.width),
                AppIcon(icon: trailingIcon!, color: AppTheme.colors.white, size: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
