import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/accessibility/announce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Aviso único de um formulário, acima dos campos.
class FormErrorAlert extends StatefulWidget {
  const FormErrorAlert({super.key, required this.message});

  final String message;

  @override
  State<FormErrorAlert> createState() => _FormErrorAlertState();
}

class _FormErrorAlertState extends State<FormErrorAlert> {
  @override
  void initState() {
    super.initState();
    _announce();
  }

  @override
  void didUpdateWidget(covariant FormErrorAlert oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) _announce();
  }

  // O motor web não aceita região viva num nó com papel; o aviso precisa ser anunciado.
  void _announce() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announceToScreenReader(
        widget.message,
        Directionality.of(context),
        assertiveness: Assertiveness.assertive,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorSurface,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: components.formAlertPaddingH,
            vertical: components.formAlertPaddingV,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.error_outline,
                  size: components.formAlertIcon,
                  color: colors.error,
                ),
              ),
              SizedBox(width: components.formAlertGap),
              Expanded(
                child: Text(
                  widget.message,
                  style: AppTheme.typography.of(context).formError.copyWith(color: colors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
