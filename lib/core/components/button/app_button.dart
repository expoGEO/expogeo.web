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
    this.semanticLabel,
    this.fullWidth = false,
    this.isLoading = false,
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
    this.semanticLabel,
    this.fullWidth = false,
    this.isLoading = false,
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
    this.semanticLabel,
    this.fullWidth = false,
    this.isLoading = false,
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

  /// Nome acessível no lugar de [text].
  final String? semanticLabel;

  /// Ocupa a largura imposta pelo pai, em vez de acompanhar o texto.
  final bool fullWidth;

  /// Mostra um indicador girando antes do texto e ignora toques, sem esmaecer o botão.
  final bool isLoading;

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
    final isLoading = widget.isLoading;
    final inactive = widget.isDisabled || isLoading || (widget.onPressed == null && !isExternal);
    // Carregando, o botão continua com o foco, para quem usa teclado não perdê-lo no meio da ação.
    final focusable = !inactive || (isLoading && !widget.isDisabled);
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
    final name = widget.semanticLabel ?? widget.text;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox.square(
            dimension: components.buttonSpinner,
            child: CircularProgressIndicator(
              strokeWidth: components.buttonSpinnerStroke,
              color: foreground,
              backgroundColor: foreground.withValues(alpha: components.buttonSpinnerTrackOpacity),
            ),
          ),
          SizedBox(width: spacing.s8),
        ] else if (widget.leadingIcon != null) ...[
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
      label: isExternal ? '$name, abre em nova aba' : name,
      onTap: inactive ? null : _handleTap,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: focusable,
      focused: _focused,
      onFocus: focusable ? _focusNode.requestFocus : null,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.isDisabled ? components.disabledOpacity : 1,
        child: AppFocusRing(
          borderRadius: radius,
          fit: widget.fullWidth ? StackFit.passthrough : StackFit.loose,
          child: Material(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: border, width: components.buttonBorder),
            ),
            child: SelectionContainer.disabled(
              child: InkWell(
                focusNode: _focusNode,
                canRequestFocus: focusable,
                onFocusChange: (value) => setState(() => _focused = value),
                customBorder: RoundedRectangleBorder(borderRadius: radius),
                onTap: inactive ? null : _handleTap,
                onHover: (value) => setState(() => _hovered = value),
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                mouseCursor: isLoading
                    ? SystemMouseCursors.progress
                    : inactive
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.click,
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
      ),
    );
  }
}
