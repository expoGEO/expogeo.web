import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentCard extends StatelessWidget {
  final ContentModel content;

  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final contentTypeColor = content.originInfo.type.color;
    final contentTypeIcon = content.originInfo.type.icon;

    return RoundedCard(
      padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
      borderColor: AppTheme.colors.gray50,
      boxShadow: [
        BoxShadow(
          color: AppTheme.colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
      child: InkWell(
        onTap: () => _handleContentTap(context),
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.huge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
                  decoration: BoxDecoration(
                    color: contentTypeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                  ),
                  child: Icon(contentTypeIcon, color: contentTypeColor, size: 24.scale),
                ),
                SizedBox(width: AppTheme.dimensions.space.medium.width),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.originInfo.type.label,
                        style: AppTheme.typography.body.small.copyWith(
                          color: AppTheme.colors.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (content.registrationInfo.issueYear != null)
                        Text(
                          '${content.registrationInfo.issueYear}',
                          style: AppTheme.typography.body.small.copyWith(
                            color: AppTheme.colors.mediumGray,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.dimensions.space.large.height),
            Text(
              content.contentInfo.title,
              style: AppTheme.typography.title.big.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.colors.darkGray,
              ),
            ),
            SizedBox(height: AppTheme.dimensions.space.medium.height),
            Text(
              content.contentInfo.description,
              style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.mediumGray),
            ),
            if (content.contentInfo.subjects.isNotEmpty) ...[
              SizedBox(height: AppTheme.dimensions.space.medium.height),
              Wrap(
                spacing: AppTheme.dimensions.space.small.width,
                runSpacing: AppTheme.dimensions.space.small.height,
                children: content.contentInfo.subjects.take(3).map((subject) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.dimensions.space.small.width,
                      vertical: AppTheme.dimensions.space.mini.height,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.lightGray,
                      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
                    ),
                    child: Text(
                      subject,
                      style: AppTheme.typography.body.small.copyWith(
                        color: AppTheme.colors.darkGray,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            SizedBox(height: AppTheme.dimensions.space.large.height),
            Row(
              children: [
                Icon(Icons.open_in_new, size: 16.scale, color: contentTypeColor),
                SizedBox(width: AppTheme.dimensions.space.small.width),
                Text(
                  'Abrir conteúdo',
                  style: AppTheme.typography.body.medium.copyWith(
                    color: contentTypeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleContentTap(BuildContext context) {
    final route = content.route;

    if (route == null) {
      _openUrl(content.registrationInfo.location);
      return;
    }

    final contentType = content.originInfo.type;

    context.push(route, extra: {'type': contentType});
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
