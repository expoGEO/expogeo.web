import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FilterChipButton extends StatefulWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.count,
    this.countUnit,
  });

  final String label;
  final int? count;

  /// Unidade da [count] na leitura de tela ("Site, 4 objetos").
  final ({String singular, String plural})? countUnit;
  final bool selected;
  final VoidCallback onPressed;

  @override
  State<FilterChipButton> createState() => _FilterChipButtonState();
}

class _FilterChipButtonState extends State<FilterChipButton> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String get _semanticLabel {
    final count = widget.count;
    final unit = widget.countUnit;
    if (count == null) return widget.label;
    if (unit == null) return '${widget.label}, $count';
    return '${widget.label}, $count ${count == 1 ? unit.singular : unit.plural}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final style = AppTheme.typography.of(context).chip;
    final radius = BorderRadius.circular(dimensions.radii.pill);
    final selected = widget.selected;
    final count = widget.count;
    final shape = RoundedRectangleBorder(
      borderRadius: radius,
      side: BorderSide(
        color: selected || _hovered ? colors.ink : colors.line,
        width: dimensions.stroke.small,
      ),
    );

    return Semantics(
      button: true,
      toggled: selected,
      label: _semanticLabel,
      onTap: widget.onPressed,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: selected ? colors.ink : colors.page,
          shape: shape,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: components.minTapTarget),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: components.chipPaddingH),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: style.copyWith(color: selected ? colors.white : colors.ink),
                    ),
                    if (count != null) ...[
                      SizedBox(width: components.chipCountGap),
                      Text(
                        '$count',
                        style: style.copyWith(
                          fontWeight: FontWeight.w500,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: selected ? colors.white : colors.inkSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
