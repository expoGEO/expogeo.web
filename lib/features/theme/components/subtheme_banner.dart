import 'package:expogeo/core/components/button/back_to_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
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
    return RoundedCard(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large.width,
        vertical: AppTheme.dimensions.space.large.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackToButton(label: 'Voltar para ${theme.title}', route: theme.type.route),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Row(
            children: [
              AppAssetImage(image: subtheme.image, width: 56.scale),
              SizedBox(width: AppTheme.dimensions.space.medium.width),
              Flexible(
                child: Text(
                  subtheme.title,
                  style: AppTheme.typography.title.medium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors.darkGray,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
