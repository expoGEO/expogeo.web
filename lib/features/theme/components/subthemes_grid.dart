import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/theme/components/subtheme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class SubthemeGrid extends StatelessWidget {
  final ThemeModel theme;

  const SubthemeGrid({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.large.width),
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: _getCrossAxisCount(context),
        mainAxisSpacing: AppTheme.dimensions.space.large.width,
        crossAxisSpacing: AppTheme.dimensions.space.large.width,
        itemCount: theme.subthemes.length,
        itemBuilder: (context, index) {
          final subtheme = theme.subthemes[index];
          return SubthemeCard(subtheme: subtheme, onTap: () => context.go(subtheme.type.route));
        },
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
