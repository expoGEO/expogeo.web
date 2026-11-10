import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/validators/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.multiline = false,
    this.minLines,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.obscureText = false,
    this.suffix,
    this.hintText,
    this.helperText,
    this.optional = false,
    this.inputFormatters,
    this.maxLength,
    this.prominent = false,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormValidator? validator;

  /// Enter quebra linha, e a altura cresce com o texto até o limite do tema.
  final bool multiline;

  /// Linhas visíveis no campo vazio de [multiline], no lugar do mínimo do tema.
  final int? minLines;

  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  /// Esconde o texto digitado e desliga sugestões e autocorreção.
  final bool obscureText;

  /// Fica dentro da caixa, à direita do texto, e recebe o foco depois do campo.
  final Widget? suffix;

  /// Exemplo dentro do campo vazio; não substitui o rótulo.
  final String? hintText;

  /// Dica visível abaixo do campo, lida junto com o rótulo.
  final String? helperText;

  /// Mostra "opcional" ao lado do rótulo, e o nome acessível o inclui.
  final bool optional;

  final List<TextInputFormatter>? inputFormatters;

  /// Limite de caracteres, sem contador visível.
  final int? maxLength;

  /// Texto maior, como o título de um editor.
  final bool prominent;

  /// Nome acessível do campo: o rótulo, mais "opcional" quando for o caso.
  String get accessibleLabel => optional ? '$label, opcional' : label;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant FormTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocus);
      widget.focusNode.addListener(_handleFocus);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocus);
    super.dispose();
  }

  void _handleFocus() {
    if (_focused != widget.focusNode.hasFocus) {
      setState(() => _focused = widget.focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);
    final spacing = AppTheme.dimensions.spacing;
    final multiline = widget.multiline;
    final suffix = widget.suffix;
    final helper = widget.helperText;
    final maxLength = widget.maxLength;
    final inputFormatters = [
      ...?widget.inputFormatters,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
    final textStyle = widget.prominent ? styles.editorTitleField : styles.regular;
    final paddingV = multiline || widget.prominent
        ? components.formFieldPaddingV
        : components.formFieldPaddingVSingleLine;

    return FormField<String>(
      initialValue: widget.controller.text,
      validator: (_) => widget.validator?.call(widget.controller.text),
      builder: (field) {
        final error = field.errorText;
        final hasError = error != null;
        final borderColor = hasError
            ? colors.error
            : _focused
            ? colors.accent
            : colors.fieldBorder;
        final ringColor = hasError ? colors.errorSurface : colors.accentSoft;

        // Rótulo e erro visíveis ficam fora da semântica: o campo os lê no próprio nó.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Text.rich(
                TextSpan(
                  text: widget.label,
                  children: [
                    if (widget.optional)
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
            AnimatedContainer(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : components.menuAnimation,
              constraints: BoxConstraints(minHeight: components.formFieldHeight),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: colors.page,
                borderRadius: radius,
                border: Border.all(color: borderColor, width: components.formFieldBorder),
                boxShadow: [
                  BoxShadow(
                    color: _focused ? ringColor : ringColor.withValues(alpha: 0),
                    spreadRadius: components.formFieldFocusRing,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      // O motor web ignora `hint` em campo de texto; no rótulo, dica e erro são
                      // lidos com ele.
                      label: joinSentences([widget.accessibleLabel, ?helper, ?error]),
                      validationResult: hasError
                          ? SemanticsValidationResult.invalid
                          : SemanticsValidationResult.none,
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        onChanged: field.didChange,
                        onSubmitted: widget.onSubmitted,
                        obscureText: widget.obscureText,
                        enableSuggestions: !widget.obscureText,
                        autocorrect: !widget.obscureText,
                        keyboardType: multiline ? TextInputType.multiline : widget.keyboardType,
                        textInputAction: multiline
                            ? TextInputAction.newline
                            : widget.textInputAction,
                        autofillHints: widget.autofillHints,
                        inputFormatters: inputFormatters.isEmpty ? null : inputFormatters,
                        minLines: multiline ? widget.minLines ?? components.formMessageMinLines : 1,
                        maxLines: multiline ? components.formMessageMaxLines : 1,
                        style: textStyle.copyWith(color: colors.ink),
                        cursorColor: colors.accent,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: textStyle.copyWith(color: colors.inkSecondary),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: components.formFieldPaddingH - components.formFieldBorder,
                            vertical: paddingV - components.formFieldBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (suffix != null)
                    Padding(
                      padding: EdgeInsets.only(right: spacing.s4 - components.formFieldBorder),
                      child: suffix,
                    ),
                ],
              ),
            ),
            if (helper != null) ...[
              SizedBox(height: components.formFieldLabelGap),
              ExcludeSemantics(
                child: Text(helper, style: styles.formHelper.copyWith(color: colors.inkSecondary)),
              ),
            ],
            if (hasError) ...[
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

/// Junta partes de um nome acessível em frases, sem ponto dobrado quando uma já termina em ponto.
String joinSentences(List<String> parts) {
  final buffer = StringBuffer();
  for (final (index, part) in parts.indexed) {
    if (index > 0) buffer.write(' ');
    final isLast = index == parts.length - 1;
    buffer.write(isLast || part.endsWith('.') ? part : '$part.');
  }
  return buffer.toString();
}
