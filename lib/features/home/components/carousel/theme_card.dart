import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!widget.isCurrent) return;

        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        if (!widget.isCurrent) return;

        setState(() => _isHovered = false);
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
                margin: EdgeInsets.symmetric(
                  horizontal: AppTheme.dimensions.space.small,
                  vertical: AppTheme.dimensions.space.medium,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.2),
                      blurRadius: _isHovered ? 15 : 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [widget.theme.color, widget.theme.color.withValues(alpha: 0.8)],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            widget.theme.icon,
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          SizedBox(height: AppTheme.dimensions.space.large),
                          Text(
                            widget.theme.title,
                            style: AppTheme.typography.headline.small.copyWith(color: Colors.white),
                          ),
                          SizedBox(height: AppTheme.dimensions.space.medium),
                          Expanded(
                            child: Text(
                              widget.theme.description,
                              style: AppTheme.typography.body.medium.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          SizedBox(height: AppTheme.dimensions.space.medium),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: AppTheme.dimensions.space.medium,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                AppTheme.dimensions.radius.medium,
                              ),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'Explorar',
                              textAlign: TextAlign.center,
                              style: AppTheme.typography.title.medium.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
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
