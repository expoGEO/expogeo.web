import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

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
            child: SelectionContainer.disabled(
              child: GestureDetector(
                onTap: widget.onTap,
                child: RoundedCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.subtheme.title,
                        textAlign: TextAlign.center,
                        style: AppTheme.typography.title.big.copyWith(
                          color: AppTheme.colors.darkGray,
                        ),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.large.height),
                      AppAssetImage(
                        image: widget.subtheme.image,
                        width: 100.scale,
                        height: 100.scale,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.large.height),
                      AppButton.primary(onPressed: widget.onTap, text: 'Explorar'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
