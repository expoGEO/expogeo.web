import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class SubthemeContent extends StatelessWidget {
  const SubthemeContent({required this.subtheme, super.key});

  final SubthemeModel subtheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.large.width),
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
          Text(
            'Conteúdo em Desenvolvimento',
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Text(
            'Este subtema está sendo desenvolvido e em breve terá conteúdo educativo completo sobre "${subtheme.title}".',
            style: AppTheme.typography.body.big.copyWith(
              color: AppTheme.colors.mediumGray,
              height: 1.6,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
            decoration: BoxDecoration(
              color: AppTheme.colors.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
              border: Border.all(
                color: AppTheme.colors.mediumGray.withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: AppTheme.dimensions.stroke.small,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.construction,
                  size: 48,
                  color: AppTheme.colors.mediumGray.withValues(alpha: 0.7),
                ),
                SizedBox(height: AppTheme.dimensions.space.large.height),
                Text(
                  'Área de conteúdo interativo',
                  style: AppTheme.typography.title.medium.copyWith(
                    color: AppTheme.colors.mediumGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.dimensions.space.small.height),
                Text(
                  'Aqui será implementado conteúdo específico sobre o subtema, incluindo textos explicativos, imagens, gráficos interativos e exercícios.',
                  style: AppTheme.typography.body.medium.copyWith(
                    color: AppTheme.colors.mediumGray,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
