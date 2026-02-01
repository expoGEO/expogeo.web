import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  OverlayEntry? _menuOverlayEntry;

  bool get _isMobile => ScreenUtils.isMobile(context);
  bool get _isTablet => ScreenUtils.isTablet(context);
  bool get _isSmallDesktop => ScreenUtils.isSmallDesktop(context);

  bool get _enabledMenu => _isMobile || _isTablet || _isSmallDesktop;

  String get _currentLocation => GoRouterState.of(context).uri.path;

  double get _navbarHeight {
    final padding = AppTheme.dimensions.space.medium * 2;
    final safeTop = MediaQuery.paddingOf(context).top;

    return kToolbarHeight + padding + safeTop;
  }

  bool _menuOpen = false;

  void _toggleMenu() {
    _menuOpen ? _hideMenuOverlay() : _showMenuOverlay();
  }

  void _showMenuOverlay() {
    _menuOverlayEntry = OverlayEntry(
      builder: (overlayContext) => _buildOverlayContent(overlayContext),
    );
    Overlay.of(context).insert(_menuOverlayEntry!);
    setState(() => _menuOpen = true);
  }

  void _hideMenuOverlay() {
    _menuOverlayEntry?.remove();
    _menuOverlayEntry = null;
    setState(() => _menuOpen = false);
  }

  void _closeMenu() {
    if (_menuOpen) _hideMenuOverlay();
  }

  void _navigateAndClose(String route) {
    context.go(route);
    _closeMenu();
  }

  Widget _buildOverlayContent(BuildContext overlayContext) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _hideMenuOverlay,
            child: Container(color: Colors.black26),
          ),
        ),
        Positioned(
          top: _navbarHeight,
          left: AppTheme.dimensions.space.medium,
          right: AppTheme.dimensions.space.medium,
          child: Material(color: Colors.transparent, child: _mobileMenuPanel),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _logo,
            const Spacer(),
            if (_enabledMenu)
              IconButton(
                onPressed: _toggleMenu,
                icon: Icon(
                  _menuOpen ? Icons.close : Icons.menu,
                  color: AppTheme.colors.gray900,
                  size: 40.scale,
                ),
                tooltip: _menuOpen ? 'Fechar menu' : 'Abrir menu',
              )
            else
              _navigationLinks,
          ],
        ),
      ),
    );
  }

  Widget get _logo {
    return GestureDetector(
      onTap: () => context.go(AppRouter.home),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAssetImage(image: AppImages.logoSimple, width: 56.scale, height: 56.scale),
          SizedBox(width: AppTheme.dimensions.space.small.width),
          Text(
            'expoGEO',
            style: AppTheme.typography.headline.small.copyWith(color: AppTheme.colors.gray900),
          ),
        ],
      ),
    );
  }

  Widget get _navigationLinks {
    final navigationItems = [
      _NavigationItem(label: 'Home', route: AppRouter.home, icon: Icons.home),
      ...ThemeDataModel.themes.map(
        (theme) => _NavigationItem(label: theme.title, route: theme.type.route, icon: theme.icon),
      ),
    ];

    return Row(
      children: navigationItems.map((item) {
        final isActive = item.route == AppRouter.home
            ? false
            : _currentLocation.contains(item.route);
        return _buildNavigationItem(item, isActive);
      }).toList(),
    );
  }

  Widget get _mobileMenuPanel {
    final navigationItems = [
      _NavigationItem(label: 'Home', route: AppRouter.home, icon: Icons.home),
      ...ThemeDataModel.themes.map(
        (theme) => _NavigationItem(label: theme.title, route: theme.type.route, icon: theme.icon),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.small.height),
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small.width),
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: navigationItems.length,
        itemBuilder: (context, index) {
          final item = navigationItems[index];
          final isActive = item.route == AppRouter.home
              ? false
              : _currentLocation.contains(item.route);
          return _buildMobileNavItem(item, isActive);
        },
        separatorBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.small.height),
            margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small.width),
            child: Divider(height: 1, color: AppTheme.colors.gray200),
          );
        },
      ),
    );
  }

  Widget _buildMobileNavItem(_NavigationItem item, bool isActive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateAndClose(item.route),
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.dimensions.space.medium.width,
            vertical: AppTheme.dimensions.space.small.height,
          ),
          child: Row(
            spacing: AppTheme.dimensions.space.medium.width,
            mainAxisAlignment: (_isTablet || _isSmallDesktop)
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 32.scale,
                color: isActive ? AppTheme.colors.darkOrange : AppTheme.colors.gray500,
              ),
              Flexible(
                child: Text(
                  item.label,
                  style: AppTheme.typography.title.small.copyWith(
                    color: isActive ? AppTheme.colors.gray900 : AppTheme.colors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(_NavigationItem item, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small.width),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.dimensions.space.small.width,
              vertical: AppTheme.dimensions.space.small.height,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.colors.darkOrange.withValues(alpha: 0.1)
                  : Colors.transparent,
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
