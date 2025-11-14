import 'package:expogeo/features/home/components/home_banner.dart';
import 'package:flutter/material.dart';

import '../../../core/components/structure/footer.dart';
import '../../../core/theme/app_theme.dart';
import '../components/carousel/theme_carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final space = SliverToBoxAdapter(child: SizedBox(height: AppTheme.dimensions.space.massive));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradients.primaryGradient),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeBanner()),
            space,
            SliverToBoxAdapter(child: Center(child: ThemeCarousel())),
            space,
            SliverToBoxAdapter(child: Footer()),
          ],
        ),
      ),
    );
  }
}
