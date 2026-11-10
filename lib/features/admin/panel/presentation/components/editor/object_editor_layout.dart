import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

/// Duas colunas no desktop (campos e lateral). Abaixo disso, uma coluna: o aviso, "Onde aparece",
/// os campos e, por último, a prévia, para escolher o lugar antes e ver o cartão depois.
class ObjectEditorLayout extends StatelessWidget {
  const ObjectEditorLayout({
    required this.controller,
    required this.where,
    required this.cards,
    required this.preview,
    this.alert,
    super.key,
  });

  final ScrollController controller;
  final Widget? alert;
  final Widget where;
  final List<Widget> cards;
  final Widget preview;

  static Widget _column(List<Widget> children) {
    final gap = AppTheme.dimensions.components.editorCardsGap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, child) in children.indexed) ...[
          if (index > 0) SizedBox(height: gap),
          child,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final alert = this.alert;

    final content = breakpoint == Breakpoint.desktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _column([?alert, ...cards])),
              SizedBox(width: components.editorColumnsGap),
              SizedBox(width: components.editorSideWidth, child: _column([where, preview])),
            ],
          )
        : _column([?alert, where, ...cards, preview]);

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.editorMaxWidth),
            child: Padding(
              padding: EdgeInsets.all(components.editorPadding(breakpoint)),
              child: FocusTraversalGroup(policy: WidgetOrderTraversalPolicy(), child: content),
            ),
          ),
        ),
      ),
    );
  }
}
