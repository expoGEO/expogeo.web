import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large,
        vertical: AppTheme.dimensions.space.medium,
      ),
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.gray200.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildLogo(context),
            const Spacer(),
            _buildNavigationLinks(context, currentLocation),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRouter.home),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAssetImage(image: AppImages.logoSimple, width: 56.scale, height: 56.scale),
          const SizedBox(width: 8),
          Text(
            'ExpoGEO',
            style: AppTheme.typography.headline.small.copyWith(color: AppTheme.colors.gray900),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationLinks(BuildContext context, String currentLocation) {
    final navigationItems = [
      _NavigationItem(label: 'Home', route: AppRouter.home, icon: Icons.home),
      ...ThemeDataModel.themes.map(
        (theme) => _NavigationItem(label: theme.title, route: theme.type.route, icon: theme.icon),
      ),
      _NavigationItem(label: 'Contato', route: AppRouter.contact, icon: Icons.contact_mail),
    ];

    return Row(
      children: navigationItems.map((item) {
        final isActive = currentLocation == item.route;
        return _buildNavigationItem(context, item, isActive);
      }).toList(),
    );
  }

  Widget _buildNavigationItem(BuildContext context, _NavigationItem item, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.dimensions.space.small,
              vertical: AppTheme.dimensions.space.small,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.colors.gray100 : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
            ),
            child: Text(
              item.label,
              style: AppTheme.typography.body.medium.copyWith(
                color: isActive ? AppTheme.colors.gray900 : AppTheme.colors.gray500,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final String label;
  final String route;
  final IconData icon;

  const _NavigationItem({required this.label, required this.route, required this.icon});
}
