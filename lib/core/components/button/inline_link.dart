import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

class InlineLink extends StatefulWidget {
  const InlineLink({
    super.key,
    required this.text,
    required this.url,
    this.semanticLabel,
    this.style,
  });

  final String text;

  /// `mailto:` abre na mesma aba; os demais endereços, em nova aba.
  final String url;

  /// Nome acessível no lugar de [text].
  final String? semanticLabel;

  final TextStyle? style;

  @override
  State<InlineLink> createState() => _InlineLinkState();
}

class _InlineLinkState extends State<InlineLink> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _open() => UrlUtils.openUrl(widget.url, sameTab: widget.url.startsWith('mailto:'));

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    // Laranja forte: o normal fica abaixo de 4,5:1 sobre a superfície.
    final color = _hovered ? colors.ink : colors.accentStrong;
    final style = (widget.style ?? AppTheme.typography.of(context).regular).copyWith(
      color: color,
      decoration: TextDecoration.underline,
      decorationColor: color,
    );
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return Semantics(
      // Sem nó próprio, dentro de `WidgetSpan` o link se funde ao parágrafo.
      container: true,
      // Sem `linkUrl`: o `<a href>` do leitor de tela navegaria a própria aba, além do `onTap`.
      link: true,
      label: widget.semanticLabel ?? widget.text,
      onTap: _open,
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
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Text(widget.text, style: style),
          ),
        ),
      ),
    );
  }
}
