import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PasswordVisibilityButton extends StatefulWidget {
  const PasswordVisibilityButton({super.key, required this.visible, required this.onPressed});

  final bool visible;
  final VoidCallback onPressed;

  @override
  State<PasswordVisibilityButton> createState() => _PasswordVisibilityButtonState();
}

class _PasswordVisibilityButtonState extends State<PasswordVisibilityButton> {
  final _tooltipKey = GlobalKey<TooltipState>();
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // O Tooltip do Flutter só abre com mouse ou toque; pelo teclado, precisa ser chamado.
  void _handleFocus(bool hasFocus) {
    setState(() => _focused = hasFocus);
    if (!hasFocus) {
      Tooltip.dismissAllToolTips();
    } else if (FocusManager.instance.highlightMode == FocusHighlightMode.traditional) {
      _tooltipKey.currentState?.ensureTooltipVisible();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final label = widget.visible ? 'Esconder senha' : 'Mostrar senha';

    return Tooltip(
      key: _tooltipKey,
      message: label,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        // O motor web publica o estado como marcado/desmarcado; não há `aria-pressed`.
        toggled: widget.visible,
        label: label,
        onTap: widget.onPressed,
        // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
        focusable: true,
        focused: _focused,
        onFocus: _focusNode.requestFocus,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              focusNode: _focusNode,
              borderRadius: radius,
              onTap: widget.onPressed,
              onFocusChange: _handleFocus,
              hoverColor: colors.surface,
              focusColor: Colors.transparent,
              mouseCursor: SystemMouseCursors.click,
              child: SizedBox.square(
                dimension: components.minTapTarget,
                child: Icon(
                  widget.visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: components.menuIconSize,
                  color: colors.inkSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
