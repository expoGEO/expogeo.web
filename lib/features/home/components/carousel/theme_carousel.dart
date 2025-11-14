import 'package:carousel_slider/carousel_slider.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/home/components/carousel/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/theme_model.dart';

class ThemeCarousel extends StatefulWidget {
  const ThemeCarousel({super.key});

  @override
  State<ThemeCarousel> createState() => _ThemeCarouselState();
}

class _ThemeCarouselState extends State<ThemeCarousel> {
  int _currentIndex = 0;

  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: AppTheme.dimensions.space.medium),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.colors.black.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => _carouselController.previousPage(),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        SizedBox(width: AppTheme.dimensions.space.medium),
        Expanded(
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: ThemeDataModel.themes.length,
            itemBuilder: (context, index, realIndex) {
              final theme = ThemeDataModel.themes[index];

              return ThemeCard(
                theme: theme,
                onTap: () => context.go(theme.route),
                isCurrent: _currentIndex == index,
              );
            },
            options: CarouselOptions(
              height: 400.height,
              scrollPhysics: NeverScrollableScrollPhysics(),
              viewportFraction: _getViewportFraction(),
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              autoPlay: false,
              onPageChanged: (index, _) => setState(() => _currentIndex = index),
            ),
          ),
        ),
        SizedBox(width: AppTheme.dimensions.space.medium),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.colors.black.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => _carouselController.nextPage(),
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ),
        SizedBox(width: AppTheme.dimensions.space.medium),
      ],
    );
  }

  double _getViewportFraction() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 640) return 1.0;
    if (screenWidth < 1024) return 0.6;

    return 0.4;
  }
}
