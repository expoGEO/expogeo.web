import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    required this.icon,
    required this.title,
    required this.content,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
        child: Container(
          padding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
          decoration: BoxDecoration(
            color: AppTheme.colors.lightGray,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
            border: Border.all(color: AppTheme.colors.mediumGray.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40.scale,
                height: 40.scale,
                decoration: BoxDecoration(
                  color: AppTheme.colors.primaryOrange,
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
                ),
                child: Icon(icon, color: AppTheme.colors.white, size: 20.scale),
              ),
              SizedBox(width: AppTheme.dimensions.space.large.width),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.typography.title.medium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colors.darkGray,
                      ),
                    ),
                    Text(
                      content,
                      style: AppTheme.typography.body.medium.copyWith(
                        color: AppTheme.colors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.scale,
                color: AppTheme.colors.mediumGray.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
