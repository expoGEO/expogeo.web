import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ObjectNote extends StatelessWidget {
  const ObjectNote({super.key, required this.text});

  static const String _label = 'Nota de conteúdo';

  final String text;

  @override
  Widget build(BuildContext context) {
    final note = text.trim();
    if (note.isEmpty) return const SizedBox.shrink();

    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Padding(
      padding: EdgeInsets.only(top: components.objectNoteTop),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(dimensions.radii.r14),
        ),
        child: Padding(
          padding: components.objectNotePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.description_outlined,
                      size: components.objectNoteLabelIcon,
                      color: colors.accentStrong,
                    ),
                  ),
                  SizedBox(width: components.objectNoteLabelGap),
                  Expanded(
                    // O rótulo em caixa alta seria soletrado; a leitura de tela recebe o texto normal.
                    child: Semantics(
                      container: true,
                      label: _label,
                      excludeSemantics: true,
                      child: Text(
                        _label.toUpperCase(),
                        style: styles.label.copyWith(
                          fontSize: components.objectNoteLabelText,
                          color: colors.accentStrong,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: components.objectNoteLabelBottom),
              Semantics(
                container: true,
                child: Text(
                  note,
                  style: styles.regular.copyWith(
                    fontSize: components.objectNoteText,
                    height: components.objectNoteTextHeight,
                    color: colors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
