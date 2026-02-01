import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackToButton extends StatelessWidget {
  const BackToButton({required this.label, required this.route, super.key});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppTheme.dimensions.space.small,
            horizontal: AppTheme.dimensions.space.medium,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, size: 16.scale, color: AppTheme.colors.mediumGray),
              SizedBox(width: AppTheme.dimensions.space.small),
              Flexible(
                child: Text(
                  label,
                  style: AppTheme.typography.body.medium.copyWith(
                    color: AppTheme.colors.mediumGray,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
