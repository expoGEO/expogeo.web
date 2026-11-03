import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/navigation/home_sections.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarThemesMenu extends StatelessWidget {
  const NavbarThemesMenu({super.key, this.selectedTheme, this.onSelected, this.showSeeAll = true});

  final ThemeEnum? selectedTheme;

  /// Chamado antes de navegar, para quem abriu o menu fechá-lo.
  final VoidCallback? onSelected;

  final bool showSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final theme in ThemeDataModel.themes)
          NavbarMenuOption(
            label: theme.title,
            leading: AppMedallion(size: components.menuMedallion, image: theme.type.illustration),
            trailing: '${theme.subthemes.length} subtemas',
            isSelected: theme.type == selectedTheme,
            onTap: () {
              final router = GoRouter.of(context);
              onSelected?.call();
              router.go(theme.type.route);
            },
          ),
        if (showSeeAll) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.s4, horizontal: spacing.s8),
            child: Divider(
              height: AppTheme.dimensions.stroke.small,
              thickness: AppTheme.dimensions.stroke.small,
              color: colors.line,
            ),
          ),
          NavbarMenuOption(
            label: 'Ver todos na página inicial',
            onTap: () {
              onSelected?.call();
              HomeSections.openThemes(context);
            },
          ),
        ],
      ],
    );
  }
}

class NavbarMenuOption extends StatefulWidget {
  const NavbarMenuOption({
    super.key,
    required this.label,
    required this.onTap,
    this.leading,
    this.trailing,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final String? trailing;
  final bool isSelected;

  @override
  State<NavbarMenuOption> createState() => _NavbarMenuOptionState();
}

class _NavbarMenuOptionState extends State<NavbarMenuOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final highlighted = _hovered || widget.isSelected;
    final trailing = widget.trailing;
    final leading = widget.leading;

    return Semantics(
      link: true,
      selected: widget.isSelected,
      label: trailing == null ? widget.label : '${widget.label}, $trailing',
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: widget.isSelected ? colors.accentSoft : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            onHover: (value) => setState(() => _hovered = value),
            hoverColor: colors.surface,
            mouseCursor: SystemMouseCursors.click,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s12,
                vertical: components.menuOptionPaddingV,
              ),
              child: Row(
                children: [
                  if (leading != null) ...[leading, SizedBox(width: spacing.s12)],
                  Expanded(
                    child: Text(
                      widget.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styles.regular.copyWith(
                        fontSize: components.menuOptionText,
                        fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                        height: 1.35,
                        color: highlighted ? colors.accentStrong : colors.ink,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    SizedBox(width: spacing.s12),
                    Text(
                      trailing,
                      maxLines: 1,
                      softWrap: false,
                      style: styles.small.copyWith(
                        fontSize: components.menuCountText,
                        height: 1.35,
                        color: colors.inkSecondary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
