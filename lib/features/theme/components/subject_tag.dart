import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SubjectTag extends StatelessWidget {
  const SubjectTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;

    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(dimensions.radii.r6),
        ),
        child: Padding(
          padding: components.objectRowTagPadding,
          child: Text(
            text,
            style: AppTheme.typography
                .of(context)
                .small
                .copyWith(fontSize: components.objectRowTagText, color: colors.inkSecondary),
          ),
        ),
      ),
    );
  }
}
