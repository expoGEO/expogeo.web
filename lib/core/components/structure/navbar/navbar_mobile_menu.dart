import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_location.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_themes_menu.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Painel lateral da navbar em telas estreitas.
class NavbarMobileMenu extends StatefulWidget {
  const NavbarMobileMenu({super.key, required this.location});

  final NavbarLocation location;

  @override
  State<NavbarMobileMenu> createState() => _NavbarMobileMenuState();
}

class _NavbarMobileMenuState extends State<NavbarMobileMenu> {
  late bool _themesExpanded = widget.location.section == NavbarSection.themes;

  void _close() => Navigator.of(context).pop();

  void _goTo(String route) {
    final router = GoRouter.of(context);
    _close();
    router.go(route);
  }

  void _openObservatory() {
    _close();
    UrlUtils.openUrl(AppLinks.observatory);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final spacing = AppTheme.dimensions.spacing;
    final width = MediaQuery.sizeOf(context).width;
    final section = widget.location.section;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : components.menuAnimation;
    final line = AppTheme.dimensions.stroke.small;

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
      child: FocusScope(
        autofocus: true,
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: width < components.mobileMenuMaxWidth ? width : components.mobileMenuMaxWidth,
            height: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.page,
                boxShadow: AppTheme.dimensions.shadows.elevated,
              ),
              child: Material(
                type: MaterialType.transparency,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: spacing.s20, right: spacing.s8),
                        child: SizedBox(
                          height: components.navbarHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Menu', style: AppTheme.typography.of(context).h3),
                              ),
                              _CloseButton(onPressed: _close),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: line, thickness: line, color: colors.line),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.s20,
                            vertical: spacing.s8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _PanelRow(
                                label: 'Temas',
                                isActive: section == NavbarSection.themes,
                                isExpandable: true,
                                isExpanded: _themesExpanded,
                                onTap: () => setState(() => _themesExpanded = !_themesExpanded),
                              ),
                              AnimatedSize(
                                duration: duration,
                                curve: Curves.easeOut,
                                alignment: Alignment.topCenter,
                                child: _themesExpanded
                                    ? Container(
                                        margin: EdgeInsets.only(bottom: spacing.s8),
                                        padding: EdgeInsets.all(spacing.s8),
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          borderRadius: BorderRadius.circular(
                                            AppTheme.dimensions.radii.r12,
                                          ),
                                        ),
                                        child: NavbarThemesMenu(
                                          selectedTheme: widget.location.theme,
                                          onSelected: _close,
                                          showSeeAll: false,
                                        ),
                                      )
                                    : const SizedBox(width: double.infinity),
                              ),
                              _PanelRow(
                                label: 'Sobre',
                                isActive: section == NavbarSection.about,
                                onTap: () => _goTo(AppRouter.about),
                              ),
                              _PanelRow(
                                label: 'Contato',
                                isActive: section == NavbarSection.contact,
                                onTap: () => _goTo(AppRouter.contact),
                              ),
                              _PanelRow(
                                label: 'Observatório',
                                isExternal: true,
                                onTap: _openObservatory,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    return Tooltip(
      message: 'Fechar menu',
      child: Semantics(
        button: true,
        label: 'Fechar menu',
        onTap: onPressed,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            mouseCursor: SystemMouseCursors.click,
            child: SizedBox.square(
              dimension: components.minTapTarget,
              child: Icon(Icons.close, size: components.menuIconSize, color: AppTheme.colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelRow extends StatelessWidget {
  const _PanelRow({
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isExpandable = false,
    this.isExpanded = false,
    this.isExternal = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isExpandable;
  final bool isExpanded;
  final bool isExternal;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final color = isActive ? colors.accent : colors.ink;
    final icon = isExpandable
        ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
        : (isExternal ? Icons.north_east : null);

    return Semantics(
      button: isExpandable,
      link: !isExpandable,
      selected: isActive,
      expanded: isExpandable ? isExpanded : null,
      label: isExternal ? '$label, abre em nova aba' : label,
      onTap: onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: components.minTapTarget),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.s4, vertical: spacing.s12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTheme.typography
                          .of(context)
                          .regular
                          .copyWith(fontWeight: FontWeight.w600, color: color),
                    ),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      size: components.navIcon,
                      color: isExternal ? colors.inkSecondary : color,
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
