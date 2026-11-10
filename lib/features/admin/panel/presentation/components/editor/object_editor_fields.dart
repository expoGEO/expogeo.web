import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/core/components/form/form_select_field.dart';
import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/date/date.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_card.dart';
import 'package:expogeo/features/admin/panel/presentation/editor/object_editor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Os quatro grupos de campos do objeto, na ordem do site.
class ObjectEditorFields {
  const ObjectEditorFields._();

  static List<Widget> cards(
    BuildContext context,
    ObjectEditorForm form, {
    required DateTime today,
  }) {
    final components = AppTheme.dimensions.components;
    final sideBySide = ScreenUtils.breakpointOf(context) != Breakpoint.mobile;

    Widget pair(Widget first, Widget second) => sideBySide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: first),
              SizedBox(width: components.editorFieldsGap),
              Expanded(child: second),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              first,
              SizedBox(height: components.formFieldGap),
              second,
            ],
          );

    Widget text(
      EditorField field,
      String label,
      TextEditingController controller, {
      bool optional = false,
      bool multiline = false,
      bool prominent = false,
      String? helperText,
      String? hintText,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      int? maxLength,
    }) => FormTextField(
      label: label,
      controller: controller,
      focusNode: form.focusOf(field),
      optional: optional,
      multiline: multiline,
      minLines: multiline ? components.editorTextMinLines : null,
      prominent: prominent,
      helperText: helperText,
      hintText: hintText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      textInputAction: multiline ? null : TextInputAction.next,
      validator: optional && field != EditorField.issueYear ? null : (_) => form.problemOf(field),
    );

    return [
      ObjectEditorCard(
        title: 'Conteúdo',
        children: [
          text(EditorField.title, 'Título', form.title, prominent: true),
          text(
            EditorField.description,
            'Descrição',
            form.description,
            multiline: true,
            helperText: 'Uma ou duas frases. Aparece no cartão do objeto.',
          ),
          text(
            EditorField.subjects,
            'Assuntos',
            form.subjects,
            helperText: 'Separe por vírgula. Viram filtros na página do subtema.',
          ),
          text(EditorField.note, 'Nota de conteúdo', form.note, optional: true, multiline: true),
        ],
      ),
      ObjectEditorCard(
        title: 'Autoria',
        children: [
          pair(
            text(EditorField.creator, 'Criador', form.creator),
            text(EditorField.collaborator, 'Colaborador', form.collaborator, optional: true),
          ),
        ],
      ),
      ObjectEditorCard(
        title: 'Origem e registro',
        children: [
          text(
            EditorField.location,
            'Endereço do recurso',
            form.location,
            hintText: 'https://',
            keyboardType: TextInputType.url,
          ),
          pair(
            FormSelectField<ContentType?>(
              label: 'Tipo',
              focusNode: form.focusOf(EditorField.type),
              value: form.type,
              options: [
                const AppFilterOption(null, 'Escolha'),
                for (final type in ContentType.values) AppFilterOption(type, type.value),
              ],
              validator: (_) => form.problemOf(EditorField.type),
              onSelected: (value) => form.type = value,
            ),
            FormSelectField<ContentFormat?>(
              label: 'Formato',
              focusNode: form.focusOf(EditorField.format),
              value: form.format,
              options: [
                const AppFilterOption(null, 'Escolha'),
                for (final format in ContentFormat.values) AppFilterOption(format, format.value),
              ],
              validator: (_) => form.problemOf(EditorField.format),
              onSelected: (value) => form.format = value,
            ),
          ),
          pair(
            text(EditorField.language, 'Idioma', form.language),
            text(
              EditorField.issueYear,
              'Ano de emissão',
              form.issueYear,
              optional: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 4,
            ),
          ),
          text(
            EditorField.requirements,
            'Requisitos',
            form.requirements,
            optional: true,
            helperText: 'Ex.: acesso à internet',
          ),
          text(
            EditorField.registrationRules,
            'Regras de registro',
            form.registrationRules,
            optional: true,
            multiline: true,
          ),
        ],
      ),
      ObjectEditorCard(
        title: 'Direitos e preservação',
        children: [
          text(EditorField.rights, 'Direitos', form.rights),
          text(EditorField.preservation, 'Ação de preservação', form.preservation),
          _ReviewFields(form: form, years: form.reviewYears(today)),
        ],
      ),
    ];
  }
}

/// "Próxima revisão do link", com mês e ano lado a lado em todas as larguras.
class _ReviewFields extends StatelessWidget {
  const _ReviewFields({required this.form, required this.years});

  static const String label = 'Próxima revisão do link';

  final ObjectEditorForm form;
  final List<int> years;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: '$label, opcional',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                text: label,
                children: [
                  TextSpan(
                    text: '  opcional',
                    style: styles.formOptional.copyWith(color: colors.inkSecondary),
                  ),
                ],
              ),
              style: styles.formLabel.copyWith(color: colors.ink),
            ),
          ),
          SizedBox(height: components.formFieldLabelGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormSelectField<int?>(
                  label: 'Mês',
                  focusNode: form.focusOf(EditorField.reviewMonth),
                  value: form.reviewMonth,
                  options: [
                    const AppFilterOption(null, '—'),
                    for (final (index, month) in monthNames.indexed)
                      AppFilterOption(index + 1, month),
                  ],
                  validator: (_) => form.problemOf(EditorField.reviewMonth),
                  onSelected: (value) => form.reviewMonth = value,
                ),
              ),
              SizedBox(width: components.editorFieldsGap),
              Expanded(
                child: FormSelectField<int?>(
                  label: 'Ano',
                  focusNode: form.focusOf(EditorField.reviewYear),
                  value: form.reviewYear,
                  options: [
                    const AppFilterOption(null, '—'),
                    for (final year in years) AppFilterOption(year, '$year'),
                  ],
                  validator: (_) => form.problemOf(EditorField.reviewYear),
                  onSelected: (value) => form.reviewYear = value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
