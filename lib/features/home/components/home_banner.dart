import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.dimensions.space.huge.scale),
      color: AppTheme.colors.white,
      child: Column(
        children: [
          AppAssetImage(image: AppImages.logo, width: MediaQuery.of(context).size.width * 0.5),
          SizedBox(height: AppTheme.dimensions.space.large),
          // Text(
          //   'ExpoGEO – Explorando o Mundo pela Geografia',
          //   textAlign: TextAlign.center,
          //   style: AppTheme.typography.headline.big.copyWith(color: AppTheme.colors.darkGray),
          // ),
          // SizedBox(height: AppTheme.dimensions.space.medium),
          Text(
            'Bem-vindo(a) ao ExpoGEO! Aqui você explora os principais temas da Geografia de forma dinâmica, visual e interativa.',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.mediumGray),
          ),
          SizedBox(height: AppTheme.dimensions.space.small),
          Text(
            'Clique nos temas e comece sua jornada pelo conhecimento geográfico.',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        ],
      ),
    );
  }
}
