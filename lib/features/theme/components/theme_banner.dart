import 'package:expogeo/core/components/button/back_to_button.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class ThemeBanner extends StatelessWidget {
  const ThemeBanner({required this.theme, super.key});

  final ThemeModel theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large.width,
        vertical: AppTheme.dimensions.space.large.height,
      ),
      padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackToButton(label: 'Voltar para início', route: AppRouter.home),
          SizedBox(height: AppTheme.dimensions.space.large),
          Row(
            children: [
              Container(
                width: 64.scale,
                height: 64.scale,
                decoration: BoxDecoration(
                  color: theme.color,
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
                ),
                child: Icon(theme.icon, size: 32.scale, color: AppTheme.colors.white),
              ),
              SizedBox(width: AppTheme.dimensions.space.large),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.title,
                      style: AppTheme.typography.title.big.copyWith(
                        color: AppTheme.colors.darkGray,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      theme.description,
                      style: AppTheme.typography.body.big.copyWith(
                        color: AppTheme.colors.mediumGray,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.dimensions.space.large),
          Text(
            'Subtemas:',
            style: AppTheme.typography.title.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        ],
      ),
    );
  }
}
