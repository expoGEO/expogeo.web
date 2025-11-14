import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colors.primaryOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
            ),
            child: Icon(Icons.public, color: AppTheme.colors.primaryOrange, size: 24),
          ),
          SizedBox(width: AppTheme.dimensions.space.medium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ExpoGEO',
                style: AppTheme.typography.headline.medium.copyWith(color: Colors.white),
              ),
              Text(
                'Conhecimento, Tecnologia e Interatividade',
                style: AppTheme.typography.body.medium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
