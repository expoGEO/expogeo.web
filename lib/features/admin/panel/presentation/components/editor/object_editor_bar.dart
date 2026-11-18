import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/reading/reference_code.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

/// Barra fixa do editor: voltar à lista, título com o código e as ações.
class ObjectEditorBar extends StatelessWidget {
  const ObjectEditorBar({
    required this.title,
    required this.onBack,
    required this.onCancel,
    required this.onSave,
    this.code,
    this.showActions = true,
    this.saving = false,
    super.key,
  });

  static const String backLabel = 'Objetos digitais';

  final String title;
  final String? code;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  /// Sem o objeto carregado, não há o que salvar.
  final bool showActions;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final isMobile = breakpoint == Breakpoint.mobile;
    final code = this.code;

    final back = AppButton.ghost(
      text: backLabel,
      size: AppButtonSize.small,
      leadingIcon: Icons.arrow_back,
      semanticLabel: 'Voltar a $backLabel',
      isDisabled: saving,
      onPressed: onBack,
    );

    final titleArea = Wrap(
      spacing: components.editorBarTitleGap,
      runSpacing: components.editorBarGapV / 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(title, style: styles.editorBarTitle.copyWith(color: colors.ink)),
        ),
        if (code != null)
          Semantics(
            label: 'Código de referência: $code',
            excludeSemantics: true,
            child: ReferenceCode(code),
          ),
      ],
    );

    final cancel = AppButton.secondary(
      text: 'Cancelar',
      size: AppButtonSize.small,
      isDisabled: saving,
      fullWidth: isMobile,
      onPressed: onCancel,
    );
    final save = AppButton.primary(
      text: saving ? 'Salvando…' : 'Salvar',
      size: AppButtonSize.small,
      isLoading: saving,
      fullWidth: isMobile,
      onPressed: onSave,
    );
    final actionsGap = SizedBox(width: components.editorBarActionsGap);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.editorBarPaddingH(breakpoint),
          vertical: components.editorBarPaddingV,
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(alignment: AlignmentDirectional.centerStart, child: back),
                  SizedBox(height: components.editorBarGapV),
                  titleArea,
                  if (showActions) ...[
                    SizedBox(height: components.editorBarGapV),
                    Row(
                      children: [
                        Expanded(child: cancel),
                        actionsGap,
                        Expanded(child: save),
                      ],
                    ),
                  ],
                ],
              )
            : Row(
                children: [
                  back,
                  SizedBox(width: components.editorBarGapH),
                  Expanded(child: titleArea),
                  if (showActions) ...[
                    SizedBox(width: components.editorBarGapH),
                    cancel,
                    actionsGap,
                    save,
                  ],
                ],
              ),
      ),
    );
  }
}
