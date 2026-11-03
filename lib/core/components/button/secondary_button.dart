import "package:expogeo/core/components/icon/app_icon.dart";
import "package:expogeo/core/components/loading/circular_loading.dart";
import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/enums/app_icons.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onPressed,
    required this.label,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;

  final double? borderRadius;

  final AppIcons? leadingIcon;
  final AppIcons? trailingIcon;

  final EdgeInsets? padding;

  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isDisabled || isLoading ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: SelectionContainer.disabled(
        child: GestureDetector(
          onTap: isDisabled || isLoading ? null : onPressed,
          child: Container(
            padding: padding ?? EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
            decoration: BoxDecoration(
              color: AppTheme.colors.white,
              borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.dimensions.radius.huge),
              border: Border.all(
                color: isDisabled ? AppTheme.colors.gray200 : AppTheme.colors.gray900,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null && !isLoading) ...[
                  AppIcon(icon: leadingIcon!, color: AppTheme.colors.gray900, size: 24),
                  SizedBox(width: AppTheme.dimensions.space.small.width),
                ],
                if (isLoading)
                  CircularLoading()
                else
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTheme.typography.body.medium.copyWith(
                        color: isDisabled ? AppTheme.colors.gray500 : AppTheme.colors.gray900,
                      ),
                    ),
                  ),
                if (trailingIcon != null) ...[
                  SizedBox(width: AppTheme.dimensions.space.small.width),
                  AppIcon(icon: trailingIcon!, color: AppTheme.colors.gray900, size: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
