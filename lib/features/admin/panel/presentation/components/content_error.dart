import 'package:expogeo/core/components/button/secondary_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_state.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter/material.dart';

class ContentError extends StatelessWidget {
  const ContentError({required this.contentStore, super.key});

  final ContentStore contentStore;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppTheme.dimensions.space.medium.height,
          children: [
            Icon(Icons.error_outline, size: 48.scale, color: AppTheme.colors.primaryRed),
            Text(
              (contentStore.state as ContentStateError).message,
              style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.primaryRed),
              textAlign: TextAlign.center,
            ),
            SecondaryButton(
              onPressed: () => contentStore.loadAllContents(),
              label: 'Tentar Novamente',
            ),
          ],
        ),
      ),
    );
  }
}
