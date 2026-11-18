import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Lista de escolha de formulário: rótulo, a lista em largura total e o erro abaixo, como o
/// `FormTextField`.
class FormSelectField<T> extends StatelessWidget {
  const FormSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onSelected,
    this.focusNode,
    this.validator,
    this.optional = false,
    this.isDisabled = false,
  });

  final String label;
  final List<AppFilterOption<T>> options;
  final T value;
  final ValueChanged<T> onSelected;
  final FocusNode? focusNode;

  /// Recebe o valor escolhido e devolve o erro, ou nulo.
  final String? Function(T value)? validator;

  /// Mostra "opcional" ao lado do rótulo, e o nome acessível o inclui.
  final bool optional;
  final bool isDisabled;

  String get accessibleLabel => optional ? '$label, opcional' : label;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return FormField<T>(
      initialValue: value,
      validator: (_) => validator?.call(value),
      builder: (field) {
        final error = field.errorText;

        // Rótulo e erro visíveis ficam fora da semântica: a lista os lê no próprio nome.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Text.rich(
                TextSpan(
                  text: label,
                  children: [
                    if (optional)
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
            AppFilterSelect<T>(
              semanticLabel: joinSentences([accessibleLabel, ?error]),
              options: options,
              value: value,
              focusNode: focusNode,
              isDisabled: isDisabled,
              expand: true,
              formField: true,
              invalid: error != null,
              onSelected: (selected) {
                field.didChange(selected);
                onSelected(selected);
              },
            ),
            if (error != null) ...[
              SizedBox(height: components.formFieldLabelGap),
              ExcludeSemantics(
                child: Text(error, style: styles.formError.copyWith(color: colors.error)),
              ),
            ],
          ],
        );
      },
    );
  }
}
