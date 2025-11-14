import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
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
          return SubthemeCard(subtheme: subtheme, onTap: () => context.go(subtheme.route));
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

class SubthemeCard extends StatefulWidget {
  final SubthemeModel subtheme;
  final VoidCallback onTap;

  const SubthemeCard({super.key, required this.subtheme, required this.onTap});

  @override
  State<SubthemeCard> createState() => _SubthemeCardState();
}

class _SubthemeCardState extends State<SubthemeCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _animationController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.colors.darkGray,
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.colors.black.withValues(alpha: _isHovered ? 0.3 : 0.2),
                      blurRadius: _isHovered ? 15 : 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 40.scale,
                        height: 40.scale,
                        decoration: BoxDecoration(
                          color: widget.subtheme.color,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(AppTheme.dimensions.radius.huge),
                            bottomLeft: Radius.circular(AppTheme.dimensions.radius.huge),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppTheme.dimensions.space.large.width),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.subtheme.title,
                            style: AppTheme.typography.title.big.copyWith(color: Colors.white),
                          ),
                          SizedBox(height: AppTheme.dimensions.space.large.height),
                          AppAssetImage(
                            image: widget.subtheme.image,
                            height: 100.scale,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: AppTheme.dimensions.space.large.height),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: AppTheme.dimensions.space.small.height,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              'Explorar subtema',
                              style: AppTheme.typography.body.big.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
