import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PanelNavItem extends StatefulWidget {
  const PanelNavItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.trailingIcon,
    this.count,
    this.isCountLoading = false,
    this.isCurrent = false,
    this.isParentOfCurrent = false,
    this.isSubItem = false,
    this.isMuted = false,
    this.isExternal = false,
    this.autofocus = false,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final IconData? trailingIcon;

  /// Some quando a contagem falhou; com [isCountLoading], vira um esqueleto curto.
  final int? count;
  final bool isCountLoading;

  final bool isCurrent;
  final bool isParentOfCurrent;
  final bool isSubItem;
  final bool isMuted;

  /// Abre em outra aba: é lido como link e avisa isso no nome.
  final bool isExternal;
  final bool autofocus;

  @override
  State<PanelNavItem> createState() => _PanelNavItemState();
}

class _PanelNavItemState extends State<PanelNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    final foreground = widget.isCurrent || widget.isParentOfCurrent
        ? colors.accentStrong
        : widget.isMuted
        ? colors.inkSecondary
        : colors.ink;
    final background = widget.isCurrent
        ? colors.accentSoft
        : _hovered
        ? colors.surface
        : Colors.transparent;

    final baseStyle = widget.isSubItem ? styles.panelNavSub : styles.panelNav;
    final textStyle = baseStyle.copyWith(
      color: foreground,
      fontWeight: widget.isSubItem && widget.isCurrent ? FontWeight.w700 : null,
    );

    final count = widget.isCountLoading ? null : widget.count;
    final semanticLabel = [
      widget.title,
      if (count != null) '$count',
      if (widget.isExternal) 'abre em nova aba',
    ].join(', ');

    return Semantics(
      button: !widget.isExternal,
      link: widget.isExternal,
      selected: widget.isCurrent,
      label: semanticLabel,
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: background,
          borderRadius: radius,
          child: InkWell(
            autofocus: widget.autofocus,
            borderRadius: radius,
            onTap: widget.onTap,
            onHover: (value) => setState(() => _hovered = value),
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.isSubItem
                    ? components.panelNavSubItemPaddingV
                    : components.panelNavItemPaddingV,
                horizontal: widget.isSubItem
                    ? components.panelNavSubItemPaddingH
                    : components.panelNavItemPaddingH,
              ),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: components.panelNavIcon, color: foreground),
                    SizedBox(width: components.panelNavItemGap),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      // Os nomes dos temas não cabem numa linha na largura do menu.
                      maxLines: widget.isSubItem ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                  if (widget.isCountLoading) ...[
                    SizedBox(width: components.panelNavCountGap),
                    AppSkeleton(
                      width: components.panelNavCountSkeletonWidth,
                      height: components.panelNavCountSkeletonHeight,
                    ),
                  ] else if (count != null) ...[
                    SizedBox(width: components.panelNavCountGap),
                    Text(
                      '$count',
                      maxLines: 1,
                      style: styles.panelCount.copyWith(color: colors.inkSecondary),
                    ),
                  ],
                  if (widget.trailingIcon != null) ...[
                    SizedBox(width: components.panelNavCountGap),
                    Icon(widget.trailingIcon, size: components.panelNavIcon, color: foreground),
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
