import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.all(AppTheme.dimensions.space.huge.scale),
      decoration: BoxDecoration(color: AppTheme.colors.lightGray),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppTheme.dimensions.space.large.width,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppTheme.dimensions.space.large.height,
                    children: [_projectInfo, _contactInfo],
                  ),
                ),
                Expanded(child: _partnersInfo),
              ],
            )
          else
            Column(
              spacing: AppTheme.dimensions.space.large.height,
              children: [_projectInfo, _contactInfo, _partnersInfo],
            ),
          SizedBox(height: AppTheme.dimensions.space.huge.height),
          Container(height: 1, color: AppTheme.colors.gray200),
          SizedBox(height: AppTheme.dimensions.space.huge.height),
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

  Widget get _partnersInfo {
    final images = [
      AppImages.capes,
      AppImages.faced,
      AppImages.observatorio,
      AppImages.ppged,
      AppImages.ufu,
      AppImages.cnpq,
      AppImages.fapemig,
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppTheme.dimensions.space.large.width,
      runSpacing: AppTheme.dimensions.space.large.height,
      children: images.map((image) => AppAssetImage(image: image, width: 180.width)).toList(),
    );
  }

  Widget get _projectInfo {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppTheme.dimensions.space.medium.height,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppTheme.dimensions.space.small.width,
          children: [
            AppAssetImage(image: AppImages.logoSimple, width: 80.scale, height: 80.scale),
            Text(
              'expoGEO',
              style: AppTheme.typography.title.big.copyWith(color: AppTheme.colors.darkGray),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small.width),
          child: Text(
            'Conhecimento, Tecnologia e Interatividade.',
            style: AppTheme.typography.body.medium.copyWith(
              color: AppTheme.colors.gray500.withValues(alpha: 0.8),
            ),
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
          padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small.width),
          child: Text(
            'Entre em contato:',
            style: AppTheme.typography.title.medium.copyWith(color: AppTheme.colors.darkGray),
          ),
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        _buildContactItem(
          icon: Icons.email,
          text: 'expogeoufu@gmail.com',
          onTap: () {
            UrlUtils.openUrl('mailto:expogeoufu@gmail.com');
          },
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        _buildContactItem(
          icon: Icons.book,
          text: 'Metadados da nossa Curadoria Digital',
          onTap: () {
            UrlUtils.openUrl(
              'https://drive.google.com/drive/folders/1xpVY1bm14ZwBdAPHYhb8s9ic4FACuUKb?usp=sharing',
            );
          },
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        _buildContactItem(
          icon: Icons.book,
          text: 'Tese de Doutorado',
          onTap: () {
            UrlUtils.openUrl(
              'https://drive.google.com/file/d/1Br4J2nR6GBuKVY8xwwBJzZoOLD3Nftmz/view?usp=sharing',
            );
          },
        ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24.scale, color: AppTheme.colors.primaryOrange),
              SizedBox(width: AppTheme.dimensions.space.small.width),
              Flexible(
                child: Text(
                  text,
                  style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.darkGray),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
