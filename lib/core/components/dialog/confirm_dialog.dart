import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Devolve `true` só quando a pessoa confirma; "Cancelar", Esc e clique fora devolvem `false`.
/// O foco volta sozinho ao botão que abriu, como em todo `showDialog`.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  bool destructive = false,
  String cancelText = 'Cancelar',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: cancelText,
    barrierColor: AppTheme.colors.scrim,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      destructive: destructive,
    ),
  );

  return confirmed ?? false;
}

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.destructive = false,
    super.key,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool destructive;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  final _cancelFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Começa no botão que não apaga nada, para um Enter distraído não confirmar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _cancelFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _cancelFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    void close(bool value) => Navigator.of(context).pop(value);

    final confirm = widget.destructive
        ? AppButton.danger(
            text: widget.confirmText,
            size: AppButtonSize.small,
            leadingIcon: Icons.delete_outline,
            onPressed: () => close(true),
          )
        : AppButton.primary(
            text: widget.confirmText,
            size: AppButtonSize.small,
            onPressed: () => close(true),
          );

    return Dialog(
      semanticsRole: SemanticsRole.alertDialog,
      backgroundColor: colors.page,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.all(AppTheme.dimensions.spacing.s16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: components.confirmDialogWidth),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: widget.title,
          child: Padding(
            padding: EdgeInsets.all(components.confirmDialogPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    widget.title,
                    style: styles.panelDialogTitle.copyWith(color: colors.ink),
                  ),
                ),
                SizedBox(height: components.confirmDialogTextGap),
                Text(widget.message, style: styles.regular.copyWith(color: colors.inkSecondary)),
                SizedBox(height: components.confirmDialogActionsTop),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: components.confirmDialogActionsGap,
                    runSpacing: components.confirmDialogActionsGap,
                    children: [
                      AppButton.secondary(
                        text: widget.cancelText,
                        size: AppButtonSize.small,
                        focusNode: _cancelFocus,
                        onPressed: () => close(false),
                      ),
                      confirm,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
