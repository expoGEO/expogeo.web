import 'package:expogeo/core/components/button/secondary_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class SubthemeError extends StatelessWidget {
  const SubthemeError({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.dimensions.space.large.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Erro ao carregar conteúdos',
              style: AppTheme.typography.title.big.copyWith(color: AppTheme.colors.primaryRed),
            ),
            SizedBox(height: AppTheme.dimensions.space.medium.height),
            Text(message, textAlign: TextAlign.center, style: AppTheme.typography.body.small),
            SizedBox(height: AppTheme.dimensions.space.medium.height),
            IntrinsicWidth(
              child: SecondaryButton(onPressed: onRetry, label: 'Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
