import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter/material.dart';

class ContentEmpty extends StatelessWidget {
  const ContentEmpty({required this.contentStore, super.key});

  final ContentStore contentStore;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      padding: EdgeInsets.all(AppTheme.dimensions.space.huge.scale),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppTheme.dimensions.space.medium.height,
          children: [
            Icon(Icons.inbox_outlined, size: 48.scale, color: AppTheme.colors.gray400),
            Text(
              'Nenhum conteúdo encontrado',
              style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.gray400),
            ),
          ],
        ),
      ),
    );
  }
}
