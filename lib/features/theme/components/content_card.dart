import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

class ContentCard extends StatefulWidget {
  final ContentModel content;

  const ContentCard({super.key, required this.content});

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        _animationController.forward();
      },
      onExit: (_) {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: () => UrlUtils.openUrl(widget.content.registrationInfo.location),
              child: RoundedCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppTheme.dimensions.space.large.height,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppTheme.dimensions.space.small),
                              decoration: BoxDecoration(
                                color: AppTheme.colors.darkOrange.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.content.originInfo.type.icon,
                                size: 40,
                                color: AppTheme.colors.darkOrange,
                              ),
                            ),
                            SizedBox(width: AppTheme.dimensions.space.medium.width),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.content.originInfo.type.value,
                                    style: AppTheme.typography.body.big.copyWith(
                                      color: AppTheme.colors.mediumGray,
                                    ),
                                  ),
                                  if (widget.content.registrationInfo.issueYear != null)
                                    Text(
                                      '${widget.content.registrationInfo.issueYear}',
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
                          widget.content.contentInfo.title,
                          style: AppTheme.typography.title.big.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.darkGray,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.content.contentInfo.description,
                          style: AppTheme.typography.body.medium.copyWith(
                            color: AppTheme.colors.mediumGray,
                          ),
                        ),
                        if (widget.content.contentInfo.subjects.isNotEmpty) ...[
                          SizedBox(height: AppTheme.dimensions.space.medium.height),
                          Wrap(
                            spacing: AppTheme.dimensions.space.small.width,
                            runSpacing: AppTheme.dimensions.space.small.height,
                            children: widget.content.contentInfo.subjects.map((subject) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.dimensions.space.small.width,
                                  vertical: AppTheme.dimensions.space.mini.height,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.lightGray,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.dimensions.radius.small,
                                  ),
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
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.open_in_new,
                          size: 16.scale,
                          color: AppTheme.colors.primaryOrange,
                        ),
                        SizedBox(width: AppTheme.dimensions.space.small.width),
                        Text(
                          'Abrir conteúdo',
                          style: AppTheme.typography.body.medium.copyWith(
                            color: AppTheme.colors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
