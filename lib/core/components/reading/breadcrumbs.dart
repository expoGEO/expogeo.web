import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BreadcrumbItem {
  const BreadcrumbItem(this.label, {this.route});

  final String label;

  /// Sem valor, o item aparece como texto; o último item é sempre a página atual.
  final String? route;
}

class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key, required this.items});

  final List<BreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).small;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Você está em',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: components.breadcrumbGap,
        runSpacing: components.breadcrumbGap,
        children: [
          for (final (index, item) in items.indexed)
            // A seta vai junto do item seguinte para não ficar sozinha no fim da linha.
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index > 0) ...[
                  ExcludeSemantics(
                    child: Icon(
                      Icons.chevron_right,
                      size: MediaQuery.textScalerOf(context).scale(components.breadcrumbIcon),
                      color: colors.inkSecondary,
                    ),
                  ),
                  SizedBox(width: components.breadcrumbGap),
                ],
                Flexible(
                  child: switch ((index == items.length - 1, item.route)) {
                    (true, _) => Semantics(
                      label: '${item.label}, página atual',
                      excludeSemantics: true,
                      child: Text(
                        item.label,
                        style: style.copyWith(color: colors.ink, fontWeight: FontWeight.w600),
                      ),
                    ),
                    (false, null) => Text(
                      item.label,
                      style: style.copyWith(color: colors.inkSecondary),
                    ),
                    (false, final route?) => _BreadcrumbLink(
                      label: item.label,
                      route: route,
                      style: style,
                    ),
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _BreadcrumbLink extends StatefulWidget {
  const _BreadcrumbLink({required this.label, required this.route, required this.style});

  final String label;
  final String route;
  final TextStyle style;

  @override
  State<_BreadcrumbLink> createState() => _BreadcrumbLinkState();
}

class _BreadcrumbLinkState extends State<_BreadcrumbLink> {
  bool _hovered = false;

  void _open() => GoRouter.of(context).go(widget.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    final color = _hovered ? colors.accentStrong : colors.inkSecondary;

    return Semantics(
      link: true,
      label: widget.label,
      linkUrl: Uri.parse(widget.route),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: Text(
              widget.label,
              style: widget.style.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
                decorationColor: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
