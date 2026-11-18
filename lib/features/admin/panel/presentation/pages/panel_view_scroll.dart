import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

/// Área rolável de uma vista do painel, com as margens da faixa de largura.
class PanelViewScroll extends StatelessWidget {
  const PanelViewScroll({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        components.panelMainPaddingH(breakpoint),
        components.panelMainPaddingTop(breakpoint),
        components.panelMainPaddingH(breakpoint),
        components.panelMainPaddingBottom(breakpoint),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}
