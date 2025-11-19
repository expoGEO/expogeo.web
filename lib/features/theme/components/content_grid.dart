import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/theme/components/content_card.dart';
import 'package:flutter/material.dart';

class ContentGrid extends StatelessWidget {
  final SubthemeModel subtheme;

  const ContentGrid({super.key, required this.subtheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.large.width),
      padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.large.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conteúdos Disponíveis',
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.small.height),
          Text(
            '${subtheme.contents.length} conteúdo${subtheme.contents.length > 1 ? 's' : ''} ${subtheme.contents.length > 1 ? 'disponíveis' : 'disponível'}',
            style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.mediumGray),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subtheme.contents.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: AppTheme.dimensions.space.medium.height),
            itemBuilder: (context, index) {
              final content = subtheme.contents[index];
              return ContentCard(content: content);
            },
          ),
        ],
      ),
    );
  }
}
