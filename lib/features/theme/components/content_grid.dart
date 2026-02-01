import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/theme/components/content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ContentGrid extends StatelessWidget {
  final SubthemeModel subtheme;

  const ContentGrid({super.key, required this.subtheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.large.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conteúdos Disponíveis (${subtheme.contents.length})',
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          AlignedGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: _getCrossAxisCount(context),
            mainAxisSpacing: AppTheme.dimensions.space.large.width,
            crossAxisSpacing: AppTheme.dimensions.space.large.width,
            itemCount: subtheme.contents.length,
            itemBuilder: (context, index) {
              final content = subtheme.contents[index];
              return ContentCard(content: content);
            },
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 640) {
      return 1; // Mobile: 1 coluna
    } else if (screenWidth < 1024) {
      return 2; // Tablet: 2 colunas
    } else {
      return 3; // Desktop: 3 colunas
    }
  }
}
