import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.dimensions.space.huge),
      decoration: BoxDecoration(color: AppTheme.colors.darkGray),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildProjectInfo(context)),
              SizedBox(width: AppTheme.dimensions.space.large),
              Expanded(flex: 1, child: _buildContactInfo(context)),
            ],
          ),
          SizedBox(height: AppTheme.dimensions.space.large),
          Container(height: 1, color: AppTheme.colors.gray200.withValues(alpha: 0.2)),
          SizedBox(height: AppTheme.dimensions.space.medium),
          Text(
            '© 2025 | Desenvolvido para fins educativos',
            style: AppTheme.typography.body.small.copyWith(
              color: AppTheme.colors.gray500.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppAssetImage(image: AppImages.logoSimple, width: 32.scale, height: 32.scale),
            SizedBox(width: AppTheme.dimensions.space.small),
            Text(
              'ExpoGEO',
              style: AppTheme.typography.title.big.copyWith(color: AppTheme.colors.white),
            ),
          ],
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        Text(
          'ExpoGEO - Explorando o Mundo pela Geografia',
          style: AppTheme.typography.body.medium.copyWith(
            color: AppTheme.colors.gray500.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
          child: Text(
            'Entre em contato',
            style: AppTheme.typography.title.medium.copyWith(color: AppTheme.colors.white),
          ),
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        _buildContactItem(context, icon: Icons.email, text: 'expogeo@edu.com', onTap: () {}),
        SizedBox(height: AppTheme.dimensions.space.mini),
        _buildContactItem(context, icon: Icons.people, text: 'Instagram', onTap: () {}),
        SizedBox(height: AppTheme.dimensions.space.mini),
        _buildContactItem(context, icon: Icons.book, text: 'Material Complementar', onTap: () {}),
        SizedBox(height: AppTheme.dimensions.space.mini),
        _buildContactItem(context, icon: Icons.link, text: 'Materiais Extras (PDF)', onTap: () {}),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppTheme.dimensions.space.small,
            horizontal: AppTheme.dimensions.space.small,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16.scale, color: Colors.white.withValues(alpha: 0.7)),
              SizedBox(width: AppTheme.dimensions.space.small),
              Text(
                text,
                style: AppTheme.typography.body.medium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
