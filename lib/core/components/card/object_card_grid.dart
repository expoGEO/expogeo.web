import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

/// Com menos itens que colunas, as vagas ficam em branco e os cartões não esticam.
class ObjectCardGrid extends StatelessWidget {
  const ObjectCardGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.recentGridGap;
    final columns = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => 1,
      Breakpoint.tablet => 2,
      Breakpoint.desktop => 3,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var start = 0; start < children.length; start += columns) ...[
          if (start > 0) SizedBox(height: gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = start; i < start + columns; i++) ...[
                  if (i > start) SizedBox(width: gap),
                  Expanded(child: i < children.length ? children[i] : const SizedBox.shrink()),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
