import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Erro de uma seção só, com nova tentativa, sem tirar o resto da página do ar.
class StateErrorInline extends StatelessWidget {
  const StateErrorInline({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final spacing = dimensions.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(dimensions.radii.r16),
        border: Border.all(color: colors.line, width: dimensions.stroke.small),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s24),
        child: Wrap(
          spacing: spacing.s16,
          runSpacing: spacing.s12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              message,
              style: AppTheme.typography.of(context).regular.copyWith(color: colors.inkSecondary),
            ),
            AppButton.secondary(
              text: 'Tentar de novo',
              size: AppButtonSize.small,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
