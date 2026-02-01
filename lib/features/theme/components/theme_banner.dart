import 'package:expogeo/core/components/button/back_to_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class ThemeBanner extends StatelessWidget {
  const ThemeBanner({required this.theme, super.key});

  final ThemeModel theme;

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return RoundedCard(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large.width,
        vertical: AppTheme.dimensions.space.large.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackToButton(label: 'Voltar para início', route: AppRouter.home),
          SizedBox(height: AppTheme.dimensions.space.large),
          if (isMobile)
            Column(
              spacing: AppTheme.dimensions.space.large.height,
              children: [_icon, _text(isMobile)],
            )
          else
            Row(
              spacing: AppTheme.dimensions.space.large.width,
              children: [
                _icon,
                Expanded(child: _text(isMobile)),
              ],
            ),
        ],
      ),
    );
  }

  Widget get _icon {
    return Container(
      padding: EdgeInsets.all(AppTheme.dimensions.space.small),
      decoration: BoxDecoration(
        color: AppTheme.colors.darkOrange.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(theme.icon, size: 40.scale, color: AppTheme.colors.darkOrange),
    );
  }

  Widget _text(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      spacing: AppTheme.dimensions.space.small,
      children: [
        Text(
          theme.title,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: AppTheme.typography.title.big.copyWith(color: AppTheme.colors.darkGray),
        ),
        Text(
          theme.description,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.mediumGray),
        ),
      ],
    );
  }
}
