import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/validators/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.multiline = false,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormValidator? validator;

  /// Enter quebra linha, e a altura cresce com o texto até o limite do tema.
  final bool multiline;

  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

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
    final multiline = widget.multiline;

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
              child: Text(widget.label, style: styles.formLabel.copyWith(color: colors.ink)),
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
              child: Semantics(
                // O motor web ignora `hint` em campo de texto; no rótulo, o erro é lido com ele.
                label: hasError ? '${widget.label}. $error' : widget.label,
                validationResult: hasError
                    ? SemanticsValidationResult.invalid
                    : SemanticsValidationResult.none,
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  onChanged: field.didChange,
                  onSubmitted: widget.onSubmitted,
                  keyboardType: multiline ? TextInputType.multiline : widget.keyboardType,
                  textInputAction: multiline ? TextInputAction.newline : widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  minLines: multiline ? components.formMessageMinLines : 1,
                  maxLines: multiline ? components.formMessageMaxLines : 1,
                  style: styles.regular.copyWith(color: colors.ink),
                  cursorColor: colors.accent,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: components.formFieldPaddingH - components.formFieldBorder,
                      vertical:
                          (multiline
                              ? components.formFieldPaddingV
                              : components.formFieldPaddingVSingleLine) -
                          components.formFieldBorder,
                    ),
                  ),
                ),
              ),
            ),
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
