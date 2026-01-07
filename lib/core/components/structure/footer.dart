import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.all(AppTheme.dimensions.space.huge.scale),
      decoration: BoxDecoration(color: AppTheme.colors.darkGray),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _projectInfo),
                SizedBox(width: AppTheme.dimensions.space.large.width),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(flex: 2, child: _contactInfo),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _projectInfo,
                SizedBox(height: AppTheme.dimensions.space.large.height),
                _contactInfo,
              ],
            ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Container(height: 1, color: AppTheme.colors.gray200.withValues(alpha: 0.2)),
          SizedBox(height: AppTheme.dimensions.space.medium.height),
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

  Widget get _projectInfo {
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

  Widget get _contactInfo {
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
        _buildContactItem(icon: Icons.email, text: 'expogeo@edu.com', onTap: () {}),
        SizedBox(height: AppTheme.dimensions.space.mini),
        _buildContactItem(icon: Icons.people, text: 'Instagram', onTap: () {}),
        SizedBox(height: AppTheme.dimensions.space.mini),
        _buildContactItem(icon: Icons.book, text: 'Material Complementar', onTap: () {}),
        SizedBox(height: AppTheme.dimensions.space.mini),
        _buildContactItem(icon: Icons.link, text: 'Materiais Extras (PDF)', onTap: () {}),
      ],
    );
  }

  Widget _buildContactItem({
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
            vertical: AppTheme.dimensions.space.small.height,
            horizontal: AppTheme.dimensions.space.small.width,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16.scale, color: AppTheme.colors.white.withValues(alpha: 0.7)),
              SizedBox(width: AppTheme.dimensions.space.small.width),
              Text(
                text,
                style: AppTheme.typography.body.medium.copyWith(
                  color: AppTheme.colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
