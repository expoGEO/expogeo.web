import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

enum AppButtonKind { primary, secondary, ghost }

enum AppButtonSize { regular, small }

class AppButton extends StatefulWidget {
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.regular,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
    this.externalUrl,
    this.focusNode,
  }) : kind = AppButtonKind.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.regular,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
    this.externalUrl,
    this.focusNode,
  }) : kind = AppButtonKind.secondary;

  const AppButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.regular,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
    this.externalUrl,
    this.focusNode,
  }) : kind = AppButtonKind.ghost;

  final AppButtonKind kind;
  final String text;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isDisabled;

  /// Abre em nova aba, mostra a seta de link externo e avisa isso no nome acessível.
  final String? externalUrl;

  final FocusNode? focusNode;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  FocusNode? _ownFocusNode;
  bool _hovered = false;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _handleTap() {
    final url = widget.externalUrl;
    if (url != null) UrlUtils.openUrl(url);
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final isExternal = widget.externalUrl != null;
    final inactive = widget.isDisabled || (widget.onPressed == null && !isExternal);
    final hovered = _hovered && !inactive;

    final (background, foreground, border) = switch (widget.kind) {
      AppButtonKind.primary => (
        hovered ? colors.accentStrong : colors.accent,
        colors.white,
        Colors.transparent,
      ),
      AppButtonKind.secondary => (
        hovered ? colors.ink : Colors.transparent,
        hovered ? colors.white : colors.ink,
        colors.ink,
      ),
      // Laranja forte também em repouso: o normal sobre o fundo do hover fica abaixo de 4,5:1.
      AppButtonKind.ghost => (
        hovered ? colors.accentSoft : Colors.transparent,
        colors.accentStrong,
        Colors.transparent,
      ),
    };

    final (fontSize, minHeight, horizontal, vertical) = switch (widget.size) {
      AppButtonSize.regular => (
        components.buttonTextRegular,
        components.buttonMinHeightRegular,
        widget.kind == AppButtonKind.ghost ? spacing.s12 : spacing.s20,
        spacing.s12,
      ),
      AppButtonSize.small => (
        components.buttonTextSmall,
        components.buttonMinHeightSmall,
        widget.kind == AppButtonKind.ghost ? spacing.s12 : spacing.s16,
        spacing.s8,
      ),
    };

    final textStyle = AppTheme.typography
        .of(context)
        .regular
        .copyWith(fontSize: fontSize, fontWeight: FontWeight.w600, height: 1.2, color: foreground);
    final iconSize = fontSize * components.buttonIconScale;
    final trailingIcon = widget.trailingIcon ?? (isExternal ? Icons.north_east : null);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leadingIcon != null) ...[
          Icon(widget.leadingIcon, size: iconSize, color: foreground),
          SizedBox(width: spacing.s8),
        ],
        Flexible(
          child: Text(widget.text, textAlign: TextAlign.center, style: textStyle),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: spacing.s8),
          Icon(trailingIcon, size: iconSize, color: foreground),
        ],
      ],
    );

    return Semantics(
      button: !isExternal,
      link: isExternal,
      enabled: !inactive,
      label: isExternal ? '${widget.text}, abre em nova aba' : widget.text,
      onTap: inactive ? null : _handleTap,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: !inactive,
      focused: _focused,
      onFocus: inactive ? null : _focusNode.requestFocus,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.isDisabled ? components.disabledOpacity : 1,
        child: AppFocusRing(
          borderRadius: radius,
          child: Material(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: border, width: components.buttonBorder),
            ),
            child: InkWell(
              focusNode: _focusNode,
              canRequestFocus: !inactive,
              onFocusChange: (value) => setState(() => _focused = value),
              customBorder: RoundedRectangleBorder(borderRadius: radius),
              onTap: inactive ? null : _handleTap,
              onHover: (value) => setState(() => _hovered = value),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              mouseCursor: inactive ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
                  child: Center(widthFactor: 1, heightFactor: 1, child: content),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
