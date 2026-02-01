import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class ThemeCard extends StatefulWidget {
  const ThemeCard({super.key, required this.theme, required this.onTap, required this.isCurrent});

  final ThemeModel theme;
  final VoidCallback onTap;
  final bool isCurrent;

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);
    final isTablet = ScreenUtils.isTablet(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth =
        screenWidth /
        (isMobile
            ? 1
            : isTablet
            ? 2
            : 4);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        _animationController.forward();
      },
      onExit: (_) {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: RoundedCard(
                width: contentWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(AppTheme.dimensions.space.small),
                        decoration: BoxDecoration(
                          color: AppTheme.colors.darkOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(widget.theme.icon, size: 40, color: AppTheme.colors.darkOrange),
                      ),
                    ),
                    SizedBox(height: AppTheme.dimensions.space.large),
                    Text(
                      widget.theme.title,
                      textAlign: TextAlign.center,
                      style: AppTheme.typography.headline.small.copyWith(
                        color: AppTheme.colors.darkGray,
                      ),
                    ),
                    SizedBox(height: AppTheme.dimensions.space.medium),
                    Expanded(
                      child: Text(
                        widget.theme.description,
                        textAlign: TextAlign.center,
                        style: AppTheme.typography.body.medium.copyWith(
                          color: AppTheme.colors.darkGray,
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.dimensions.space.medium),
                    PrimaryButton(onPressed: widget.onTap, label: 'Explorar'),
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
