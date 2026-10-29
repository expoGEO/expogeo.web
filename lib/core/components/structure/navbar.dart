import 'dart:ui';

import 'package:expogeo/core/components/brand/app_brand.dart';
import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_dropdown.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_item.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_location.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_mobile_menu.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_themes_menu.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final _menuButtonFocus = FocusNode(debugLabel: 'Navbar menu button');

  bool _isMenuOpen = false;

  @override
  void dispose() {
    _menuButtonFocus.dispose();
    super.dispose();
  }

  Future<void> _openMenu(NavbarLocation location) async {
    final components = AppTheme.dimensions.components;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : components.menuAnimation;

    setState(() => _isMenuOpen = true);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar menu',
      barrierColor: AppTheme.colors.ink.withValues(alpha: components.scrimOpacity),
      transitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return NavbarMobileMenu(location: location);
      },
    );

    if (!mounted) return;
    setState(() => _isMenuOpen = false);
    _menuButtonFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final spacing = AppTheme.dimensions.spacing;
    final location = NavbarLocation.of(context);
    final isWide = MediaQuery.sizeOf(context).width > components.navbarCollapseWidth;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: components.navbarBlur, sigmaY: components.navbarBlur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.page.withValues(alpha: components.navbarOpacity),
            border: Border(bottom: BorderSide(color: colors.line)),
          ),
          child: PageContent(
            child: SizedBox(
              height: components.navbarHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AppBrand(
                        tagline: isWide ? 'Curadoria digital do saber geográfico' : null,
                        onTap: () => GoRouter.of(context).go(AppRouter.home),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.s24),
                  if (isWide) ...[
                    NavbarDropdown(
                      label: 'Temas',
                      isActive: location.section == NavbarSection.themes,
                      menuBuilder: (context, close) =>
                          NavbarThemesMenu(selectedTheme: location.theme, onSelected: close),
                    ),
                    SizedBox(width: spacing.s4),
                    NavbarItem(
                      label: 'Sobre',
                      isActive: location.section == NavbarSection.about,
                      onTap: () => GoRouter.of(context).go(AppRouter.about),
                    ),
                    SizedBox(width: spacing.s4),
                    NavbarItem(
                      label: 'Contato',
                      isActive: location.section == NavbarSection.contact,
                      onTap: () => GoRouter.of(context).go(AppRouter.contact),
                    ),
                    SizedBox(width: spacing.s16),
                    const AppButton.ghost(
                      text: 'Observatório',
                      size: AppButtonSize.small,
                      externalUrl: AppLinks.observatory,
                    ),
                  ] else
                    _MenuButton(
                      focusNode: _menuButtonFocus,
                      isOpen: _isMenuOpen,
                      onPressed: () => _openMenu(location),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.focusNode, required this.isOpen, required this.onPressed});

  final FocusNode focusNode;
  final bool isOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final label = isOpen ? 'Fechar menu' : 'Abrir menu';

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        expanded: isOpen,
        label: label,
        onTap: onPressed,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: InkWell(
            focusNode: focusNode,
            borderRadius: radius,
            onTap: onPressed,
            hoverColor: AppTheme.colors.surface,
            mouseCursor: SystemMouseCursors.click,
            child: SizedBox.square(
              dimension: components.minTapTarget,
              child: Icon(Icons.menu, size: components.menuIconSize, color: AppTheme.colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Navbar presa ao topo dentro de um `CustomScrollView`.
class NavbarSliver extends StatelessWidget {
  const NavbarSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(pinned: true, delegate: _NavbarHeaderDelegate());
  }
}

class _NavbarHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => AppTheme.dimensions.components.navbarHeight;

  @override
  double get maxExtent => AppTheme.dimensions.components.navbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => const Navbar();

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
