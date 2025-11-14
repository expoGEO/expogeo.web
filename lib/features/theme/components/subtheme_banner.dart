import 'package:expogeo/core/components/button/back_to_button.dart';
import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class SubthemeBanner extends StatelessWidget {
  const SubthemeBanner({required this.theme, required this.subtheme, super.key});

  final ThemeModel theme;
  final SubthemeModel subtheme;

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
          BackToButton(label: 'Voltar para ${theme.title}', route: theme.route),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Row(
            children: [
              AppAssetImage(image: subtheme.image, width: 80.scale),
              SizedBox(width: AppTheme.dimensions.space.medium.width),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtheme.title,
                      style: AppTheme.typography.title.medium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.darkGray,
                      ),
                    ),
                    SizedBox(height: AppTheme.dimensions.space.mini.height),
                    Text(
                      subtheme.description,
                      style: AppTheme.typography.body.medium.copyWith(
                        color: AppTheme.colors.mediumGray,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
