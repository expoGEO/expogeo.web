import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ReadingColumn extends StatelessWidget {
  const ReadingColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(
          top: components.readingPaddingTop,
          bottom: components.readingPaddingBottom,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.readingMaxWidth),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
          ),
        ),
      ),
    );
  }
}
