import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Grupo de campos do editor, com o título em maiúsculas.
class ObjectEditorCard extends StatelessWidget {
  const ObjectEditorCard({required this.children, this.title, this.semanticLabel, super.key});

  final String? title;
  final List<Widget> children;

  /// Nome do grupo quando ele não deve ler os filhos, como a prévia do cartão.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final title = this.title;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
        child: Padding(
          padding: EdgeInsets.all(components.editorCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Semantics(
                  header: true,
                  headingLevel: 2,
                  label: title,
                  excludeSemantics: true,
                  child: Text(
                    title.toUpperCase(),
                    style: AppTheme.typography
                        .of(context)
                        .editorCardTitle
                        .copyWith(color: colors.inkSecondary),
                  ),
                ),
                SizedBox(height: components.editorCardTitleGap),
              ],
              for (final (index, child) in children.indexed) ...[
                if (index > 0) SizedBox(height: components.formFieldGap),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
