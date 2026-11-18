import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.semanticLabel,
    required this.onChanged,
    required this.onClear,
    this.focusNode,
    this.height,
    this.radius,
  });

  final TextEditingController controller;
  final String hint;
  final String semanticLabel;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final FocusNode? focusNode;

  /// Sem valor, a altura e o raio do campo de busca do site.
  final double? height;
  final double? radius;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  FocusNode? _ownFocusNode;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocus);
    widget.controller.addListener(_handleText);
  }

  @override
  void didUpdateWidget(covariant AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleText);
      widget.controller.addListener(_handleText);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_handleFocus);
      _focusNode.addListener(_handleFocus);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleText);
    _focusNode.removeListener(_handleFocus);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (_focused != _focusNode.hasFocus) setState(() => _focused = _focusNode.hasFocus);
  }

  void _handleText() => setState(() {});

  void _clear() {
    widget.controller.clear();
    widget.onClear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(widget.radius ?? AppTheme.dimensions.radii.r12);
    final hasText = widget.controller.text.isNotEmpty;

    // A borda fica no contêiner: o InputDecorator não estica até a altura pedida.
    return AnimatedContainer(
      duration: components.menuAnimation,
      constraints: BoxConstraints(minHeight: widget.height ?? components.searchFieldHeight),
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: radius,
        border: Border.all(
          color: _focused ? colors.accent : colors.line,
          width: components.searchFieldBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: _focused ? colors.accentSoft : colors.accentSoft.withValues(alpha: 0),
            spreadRadius: components.searchFieldFocusRing,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Semantics(
            label: widget.semanticLabel,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              // O filtro já roda a cada tecla; sem isto, o Enter tira o foco do campo.
              onEditingComplete: () {},
              style: styles.regular.copyWith(color: colors.ink),
              cursorColor: colors.accent,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: styles.regular.copyWith(color: colors.inkSecondary),
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: EdgeInsetsDirectional.only(
                  start: components.searchFieldPaddingStart - components.searchFieldBorder,
                  // Vazio, o texto de ajuda usa o espaço do "Limpar" e não corta em tela estreita.
                  end:
                      (hasText
                          ? components.searchFieldPaddingEnd
                          : components.searchFieldPaddingEndEmpty) -
                      components.searchFieldBorder,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: components.searchFieldIconInset - components.searchFieldBorder,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Icon(Icons.search, size: components.navIcon, color: colors.inkSecondary),
              ),
            ),
          ),
          if (hasText)
            PositionedDirectional(
              end: components.searchFieldClearInset - components.searchFieldBorder,
              child: _ClearButton(onPressed: _clear),
            ),
        ],
      ),
    );
  }
}

class _ClearButton extends StatefulWidget {
  const _ClearButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    return Semantics(
      button: true,
      label: 'Limpar busca',
      onTap: widget.onPressed,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: _hovered ? colors.surface : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.searchFieldClearPaddingH,
                vertical: components.searchFieldClearPaddingV,
              ),
              child: Text(
                'Limpar',
                style: AppTheme.typography
                    .of(context)
                    .chip
                    .copyWith(color: _hovered ? colors.ink : colors.inkSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
