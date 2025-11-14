import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/theme/components/subtheme_banner.dart';
import 'package:expogeo/features/theme/components/subtheme_content.dart';
import 'package:flutter/material.dart';

class SubthemePage extends StatelessWidget {
  final String themeId;
  final String subthemeId;

  const SubthemePage({super.key, required this.themeId, required this.subthemeId});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeDataModel.themes.firstWhere(
      (t) => t.id == themeId,
      orElse: () => ThemeDataModel.themes.first,
    );

    final subtheme = theme.subthemes.firstWhere(
      (s) => s.id == subthemeId,
      orElse: () => theme.subthemes.first,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: subtheme.color.withValues(alpha: 0.2)),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SubthemeBanner(theme: theme, subtheme: subtheme),
                    SubthemeContent(subtheme: subtheme),
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
