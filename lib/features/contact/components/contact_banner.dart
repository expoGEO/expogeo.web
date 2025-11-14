import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class ContactBanner extends StatelessWidget {
  const ContactBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large.width,
        vertical: AppTheme.dimensions.space.large.height,
      ),
      padding: EdgeInsets.all(AppTheme.dimensions.space.large),
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64.scale,
            height: 64.scale,
            decoration: BoxDecoration(
              color: AppTheme.colors.primaryOrange,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
            ),
            child: Icon(Icons.contact_mail, size: 32.scale, color: AppTheme.colors.white),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Text(
            'Entre em Contato',
            textAlign: TextAlign.center,
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.small.height),
          Text(
            'Tem dúvidas sobre o ExpoGEO? Quer sugerir melhorias ou reportar problemas? Entre em contato conosco!',
            style: AppTheme.typography.body.big.copyWith(
              color: AppTheme.colors.mediumGray,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
