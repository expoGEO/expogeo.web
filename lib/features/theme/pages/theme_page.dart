import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/theme/components/subtheme_grid.dart';
import 'package:expogeo/features/theme/components/theme_banner.dart';
import 'package:flutter/material.dart';

class ThemePage extends StatelessWidget {
  final String themeId;
  final String themeTitle;

  const ThemePage({super.key, required this.themeId, required this.themeTitle});

  @override
  Widget build(BuildContext context) {
    // Buscar o tema correspondente
    final theme = ThemeDataModel.themes.firstWhere(
      (t) => t.type.value == themeId,
      orElse: () => ThemeDataModel.themes.first,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.color.withValues(alpha: 0.2)),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ThemeBanner(theme: theme),
                    SubthemeGrid(theme: theme),
                    SizedBox(height: AppTheme.dimensions.space.large.height),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
