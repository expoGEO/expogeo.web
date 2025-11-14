import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/contact/components/contact_info.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.large.width),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Formulário de Contato',
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppTheme.dimensions.space.large),
            decoration: BoxDecoration(
              color: AppTheme.colors.lightGray,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
              border: Border.all(
                color: AppTheme.colors.mediumGray.withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: AppTheme.dimensions.stroke.small,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.construction,
                  size: 48.scale,
                  color: AppTheme.colors.mediumGray.withValues(alpha: 0.7),
                ),
                SizedBox(height: AppTheme.dimensions.space.large.height),
                Text(
                  'Formulário em Desenvolvimento',
                  style: AppTheme.typography.title.big.copyWith(
                    color: AppTheme.colors.mediumGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.dimensions.space.small.height),
                Text(
                  'Em breve, você poderá enviar mensagens diretamente através desta página.',
                  style: AppTheme.typography.body.big.copyWith(
                    color: AppTheme.colors.mediumGray,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          Text(
            'Contato Alternativo',
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          ContactInfo(icon: Icons.email, title: 'Email', content: 'expogeo@edu.com', onTap: () {}),
          SizedBox(height: AppTheme.dimensions.space.small.height),
          ContactInfo(icon: Icons.people, title: 'Instagram', content: '@expogeo', onTap: () {}),
        ],
      ),
    );
  }
}
