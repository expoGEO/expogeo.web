import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AppFilterOption<T> {
  const AppFilterOption(this.value, this.label);

  final T value;
  final String label;
}

/// Seletor de filtro: botão com a opção escolhida e um menu com as opções.
class AppFilterSelect<T> extends StatefulWidget {
  const AppFilterSelect({
    super.key,
    required this.semanticLabel,
    required this.options,
    required this.value,
    required this.onSelected,
    this.isDisabled = false,
    this.expand = false,
    this.focusNode,
    this.formField = false,
    this.invalid = false,
  });

  final String semanticLabel;
  final List<AppFilterOption<T>> options;
  final T value;
  final ValueChanged<T> onSelected;

  /// Fica fora do Tab e é lido como indisponível.
  final bool isDisabled;

  /// Ocupa toda a largura recebida, com a seta encostada à direita.
  final bool expand;
  final FocusNode? focusNode;

  /// Altura, contorno e cantos de campo de formulário, para ficar ao lado dos campos de texto.
  final bool formField;

  /// Contorno de erro, para lista obrigatória sem escolha.
  final bool invalid;

  @override
  State<AppFilterSelect<T>> createState() => _AppFilterSelectState<T>();
}

class _AppFilterSelectState<T> extends State<AppFilterSelect<T>> {
  final _controller = MenuController();
  final _selectedFocus = FocusNode();
  FocusNode? _ownFocus;

  FocusNode get _buttonFocus => widget.focusNode ?? (_ownFocus ??= FocusNode());

  @override
  void dispose() {
    _ownFocus?.dispose();
    _selectedFocus.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.isDisabled) return;
    _controller.isOpen ? _controller.close() : _controller.open();
    setState(() {});
  }

  // Aberto pelo teclado, o foco entra no menu na opção atual; pelo mouse, fica no botão.
  void _handleOpen() {
    if (!_buttonFocus.hasFocus) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_controller.isOpen) _selectedFocus.requestFocus();
    });
  }

  // O menu prende o Tab dentro dele; aqui o Tab sai do menu (as setas andam entre as opções).
  KeyEventResult _handleMenuKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    final backwards = HardwareKeyboard.instance.isShiftPressed;
    _controller.close();
    _buttonFocus.requestFocus();
    if (!backwards) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _buttonFocus.nextFocus());
    }
    setState(() {});
    return KeyEventResult.handled;
  }

  void _select(T value) {
    _buttonFocus.requestFocus();
    widget.onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final options = widget.options;
    final selected = options.firstWhere(
      (option) => option.value == widget.value,
      orElse: () => options.first,
    );

    return MenuAnchor(
      controller: _controller,
      childFocusNode: _buttonFocus,
      // Um clique fora só fecha o menu, sem acionar o que estiver por baixo.
      consumeOutsideTap: true,
      onOpen: _handleOpen,
      onClose: () {
        if (mounted) setState(() {});
      },
      style: _menuStyle(),
      alignmentOffset: Offset(0, components.filterSelectMenuOffset),
      menuChildren: [
        Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _handleMenuKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final option in options)
                Semantics(
                  selected: option == selected,
                  child: MenuItemButton(
                    focusNode: option == selected ? _selectedFocus : null,
                    requestFocusOnHover: false,
                    style: _menuItemStyle(styles.filterOption),
                    trailingIcon: option == selected
                        ? Icon(Icons.check, size: components.filterSelectIcon)
                        : null,
                    onPressed: () => _select(option.value),
                    child: Text(option.label),
                  ),
                ),
            ],
          ),
        ),
      ],
      builder: (context, controller, _) => _FilterButton(
        focusNode: _buttonFocus,
        semanticLabel: widget.semanticLabel,
        label: selected.label,
        expanded: controller.isOpen,
        isDisabled: widget.isDisabled,
        expand: widget.expand,
        formField: widget.formField,
        invalid: widget.invalid,
        onPressed: _toggle,
      ),
    );
  }

  MenuStyle _menuStyle() {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll(colors.page),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      shadowColor: WidgetStatePropertyAll(colors.ink.withValues(alpha: components.scrimOpacity)),
      elevation: WidgetStatePropertyAll(components.filterSelectMenuElevation),
      padding: WidgetStatePropertyAll(EdgeInsets.all(components.filterSelectMenuPadding)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          side: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      maximumSize: WidgetStatePropertyAll(
        Size(double.infinity, components.filterSelectMenuMaxHeight),
      ),
    );
  }

  ButtonStyle _menuItemStyle(TextStyle textStyle) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final focus = AppTheme.dimensions.focus;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)
            ? colors.surface
            : Colors.transparent,
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(colors.ink),
      iconColor: WidgetStatePropertyAll(colors.accentStrong),
      textStyle: WidgetStatePropertyAll(textStyle),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: components.filterSelectMenuItemPaddingV,
          horizontal: components.filterSelectMenuItemPaddingH,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(Size(0, components.buttonMinHeightSmall)),
      side: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? BorderSide(color: focus.color, width: focus.width)
            : BorderSide.none,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8)),
      ),
    );
  }
}

class _FilterButton extends StatefulWidget {
  const _FilterButton({
    required this.focusNode,
    required this.semanticLabel,
    required this.label,
    required this.expanded,
    required this.isDisabled,
    required this.expand,
    required this.formField,
    required this.invalid,
    required this.onPressed,
  });

  final FocusNode focusNode;
  final String semanticLabel;
  final String label;
  final bool expanded;
  final bool isDisabled;
  final bool expand;
  final bool formField;
  final bool invalid;
  final VoidCallback onPressed;

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final formField = widget.formField;
    final radius = BorderRadius.circular(
      formField ? AppTheme.dimensions.radii.r12 : AppTheme.dimensions.radii.r10,
    );
    final disabled = widget.isDisabled;

    final borderColor = widget.invalid
        ? colors.error
        : formField
        ? (!disabled && widget.expanded ? colors.accent : colors.fieldBorder)
        : !disabled && (_hovered || widget.expanded)
        ? colors.lineStrong
        : colors.line;

    return Semantics(
      button: true,
      enabled: !disabled,
      expanded: disabled ? null : widget.expanded,
      label: widget.semanticLabel,
      value: widget.label,
      onTap: disabled ? null : widget.onPressed,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: !disabled,
      focused: !disabled && widget.focusNode.hasFocus,
      onFocus: disabled ? null : widget.focusNode.requestFocus,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: disabled ? colors.surface : colors.page,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: borderColor,
              width: formField ? components.formFieldBorder : components.filterSelectBorder,
            ),
          ),
          child: InkWell(
            focusNode: widget.focusNode,
            canRequestFocus: !disabled,
            onTap: disabled ? null : widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (_) => setState(() {}),
            mouseCursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: formField ? components.formFieldHeight : components.panelFilterHeight,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: components.filterSelectPaddingStart,
                  end: components.filterSelectPaddingEnd,
                ),
                child: Row(
                  mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: widget.expand ? FlexFit.tight : FlexFit.loose,
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (formField ? styles.regular : styles.filterSelect).copyWith(
                          color: disabled ? colors.inkSecondary : colors.ink,
                        ),
                      ),
                    ),
                    SizedBox(width: components.filterSelectIconGap),
                    AnimatedRotation(
                      turns: widget.expanded ? 0.5 : 0,
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : components.menuAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: components.filterSelectIcon,
                        color: colors.inkSecondary,
                      ),
                    ),
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
