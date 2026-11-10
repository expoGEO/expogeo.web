import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/core/components/form/form_select_field.dart';
import 'package:expogeo/core/components/reading/reference_code.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_card.dart';
import 'package:expogeo/features/admin/panel/presentation/editor/object_editor_form.dart';
import 'package:flutter/material.dart';

/// "Onde aparece": tema, subtema e o código gerado a partir deles.
class ObjectEditorWhere extends StatelessWidget {
  const ObjectEditorWhere({required this.form, required this.code, super.key});

  static const String codeLabel = 'Código de referência';
  static const String noCode = 'Escolha o tema e o subtema';

  final ObjectEditorForm form;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final theme = form.theme;
    final code = this.code;

    return ObjectEditorCard(
      title: 'Onde aparece',
      children: [
        FormSelectField<ThemeEnum?>(
          label: 'Tema',
          focusNode: form.focusOf(EditorField.theme),
          value: theme,
          options: [
            const AppFilterOption(null, 'Escolha'),
            for (final model in ThemeDataModel.themes) AppFilterOption(model.type, model.type.name),
          ],
          validator: (_) => form.problemOf(EditorField.theme),
          onSelected: (value) => form.theme = value,
        ),
        FormSelectField<SubthemeEnum?>(
          label: 'Subtema',
          focusNode: form.focusOf(EditorField.subtheme),
          value: form.subtheme,
          isDisabled: theme == null,
          options: [
            const AppFilterOption(null, 'Escolha'),
            for (final model in ThemeDataModel.themes)
              if (model.type == theme)
                for (final subtheme in model.subthemes)
                  AppFilterOption(subtheme.type, subtheme.type.name),
          ],
          validator: (_) => form.problemOf(EditorField.subtheme),
          onSelected: (value) => form.subtheme = value,
        ),
        Semantics(
          container: true,
          label: '$codeLabel: ${code ?? noCode}',
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(codeLabel, style: styles.formLabel.copyWith(color: colors.ink)),
              SizedBox(height: components.editorCodeGap),
              if (code != null)
                ReferenceCode(code)
              else
                Text(noCode, style: styles.formHelper.copyWith(color: colors.inkSecondary)),
              SizedBox(height: components.editorCodeGap),
              Text(
                'Gerado a partir do tema e do subtema.',
                style: styles.formHelper.copyWith(color: colors.inkSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// O cartão do site como vai aparecer, sem ação e fora do Tab.
class ObjectEditorPreview extends StatelessWidget {
  const ObjectEditorPreview({required this.form, required this.code, super.key});

  static const String label = 'Prévia do cartão';

  final ObjectEditorForm form;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return ObjectEditorCard(
      title: label,
      children: [
        ExcludeSemantics(
          child: ExcludeFocus(
            child: IgnorePointer(
              child: ObjectCard(
                content: form.preview(code: code ?? ''),
                subtheme: form.subtheme,
                onOpen: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
