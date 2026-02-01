import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/home/components/carousel/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ThemesRow extends StatefulWidget {
  const ThemesRow({super.key});

  @override
  State<ThemesRow> createState() => _ThemesRowState();
}

class _ThemesRowState extends State<ThemesRow> {
  final int _currentIndex = 0;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.medium),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.medium),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppTheme.dimensions.space.medium,
            children: [
              ...ThemeDataModel.themes.map(
                (theme) => ThemeCard(
                  key: ValueKey(theme.type.route),
                  theme: theme,
                  onTap: () => context.go(theme.type.route),
                  isCurrent: _currentIndex == ThemeDataModel.themes.indexOf(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
