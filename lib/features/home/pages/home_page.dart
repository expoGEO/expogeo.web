import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/home/components/carousel/themes_row.dart';
import 'package:expogeo/features/home/components/home_banner.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final space = SliverToBoxAdapter(child: SizedBox(height: AppTheme.dimensions.space.massive));

    return Scaffold(
      backgroundColor: AppTheme.colors.gray100,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const HomeBanner()),
          space,
          SliverToBoxAdapter(child: const Center(child: ThemesRow())),
          space,
          SliverToBoxAdapter(child: const Footer()),
        ],
      ),
    );
  }
}
