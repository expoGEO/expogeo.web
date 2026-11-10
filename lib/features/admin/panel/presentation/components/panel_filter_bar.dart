import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum PanelFilterLayout { singleRow, twoRows, grid }

/// Busca e três seletores numa caixa: numa linha, em duas (busca e seletores) ou, estreita, busca
/// e grade de 2 colunas.
class PanelFilterBar extends StatelessWidget {
  const PanelFilterBar({
    required this.search,
    required this.theme,
    required this.subtheme,
    required this.type,
    super.key,
  });

  final Widget search;

  /// Recebem se o seletor deve ocupar toda a largura da coluna.
  final Widget Function(bool expand) theme;
  final Widget Function(bool expand) subtheme;
  final Widget Function(bool expand) type;

  /// Decide pela largura disponível, e não pela da janela, porque o menu lateral ocupa parte dela.
  static PanelFilterLayout layoutFor(double width) {
    final components = AppTheme.dimensions.components;
    final gap = components.panelFilterGap;
    final singleRow =
        components.panelFilterSearchMinWidth + 3 * (components.panelFilterSelectMaxWidth + gap);
    if (width >= singleRow) return PanelFilterLayout.singleRow;
    if (width >= 3 * components.panelFilterSelectMinWidth + 2 * gap) {
      return PanelFilterLayout.twoRows;
    }
    return PanelFilterLayout.grid;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final stroke = AppTheme.dimensions.stroke.small;
    final gap = components.panelFilterGap;

    return Padding(
      padding: EdgeInsets.only(bottom: components.panelFilterMarginBottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          border: Border.all(color: colors.line, width: stroke),
        ),
        child: Padding(
          padding: EdgeInsets.all(components.panelFilterPadding),
          child: FocusTraversalGroup(
            child: LayoutBuilder(
              builder: (context, constraints) {
                switch (layoutFor(constraints.maxWidth)) {
                  case PanelFilterLayout.singleRow:
                    Widget limited(Widget child) => ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: components.panelFilterSelectMaxWidth),
                      child: child,
                    );
                    return Row(
                      children: [
                        Expanded(child: search),
                        SizedBox(width: gap),
                        limited(theme(false)),
                        SizedBox(width: gap),
                        limited(subtheme(false)),
                        SizedBox(width: gap),
                        limited(type(false)),
                      ],
                    );
                  case PanelFilterLayout.twoRows:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        search,
                        SizedBox(height: gap),
                        Row(
                          children: [
                            Expanded(child: theme(true)),
                            SizedBox(width: gap),
                            Expanded(child: subtheme(true)),
                            SizedBox(width: gap),
                            Expanded(child: type(true)),
                          ],
                        ),
                      ],
                    );
                  case PanelFilterLayout.grid:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        search,
                        SizedBox(height: gap),
                        Row(
                          children: [
                            Expanded(child: theme(true)),
                            SizedBox(width: gap),
                            Expanded(child: subtheme(true)),
                          ],
                        ),
                        SizedBox(height: gap),
                        Row(
                          children: [
                            Expanded(child: type(true)),
                            SizedBox(width: gap),
                            const Spacer(),
                          ],
                        ),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
