import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/components/loading/circular_loading.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/theme/components/content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ContentGrid extends StatelessWidget {
  final List<ContentResponseModel> contents;

  final int currentPage;
  final int totalPages;
  final int totalCount;

  final bool hasNextPage;
  final bool hasPreviousPage;

  final bool isLoadingNextPage;
  final bool isLoadingPreviousPage;

  final Future<void> Function() onNextPage;
  final Future<void> Function() onPreviousPage;

  const ContentGrid({
    super.key,
    required this.contents,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.isLoadingNextPage,
    required this.isLoadingPreviousPage,
    required this.onNextPage,
    required this.onPreviousPage,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);
    final isTablet = ScreenUtils.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.large.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conteúdos Disponíveis ($totalCount)',
            style: AppTheme.typography.title.big.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.darkGray,
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          AlignedGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
            mainAxisSpacing: AppTheme.dimensions.space.large.width,
            crossAxisSpacing: AppTheme.dimensions.space.large.width,
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              return ContentCard(content: content);
            },
          ),
          SizedBox(height: AppTheme.dimensions.space.large.height),
          _PaginationControls(
            currentPage: currentPage,
            totalPages: totalPages,
            hasNextPage: hasNextPage,
            hasPreviousPage: hasPreviousPage,
            onNextPage: onNextPage,
            onPreviousPage: onPreviousPage,
            isLoadingNextPage: isLoadingNextPage,
            isLoadingPreviousPage: isLoadingPreviousPage,
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  final bool hasNextPage;
  final bool hasPreviousPage;

  final bool isLoadingNextPage;
  final bool isLoadingPreviousPage;

  final Future<void> Function() onNextPage;
  final Future<void> Function() onPreviousPage;

  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.isLoadingNextPage,
    required this.isLoadingPreviousPage,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.medium.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoadingPreviousPage)
            Padding(
              padding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
              child: const SizedBox(width: 24, height: 24, child: CircularLoading()),
            )
          else
            AppIconButton(
              onPressed: () {
                if (!hasPreviousPage) return;
                onPreviousPage();
              },
              icon: Icons.arrow_back,
              color: hasPreviousPage ? AppTheme.colors.primaryOrange : AppTheme.colors.gray300,
            ),
          SizedBox(width: AppTheme.dimensions.space.large.width),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.dimensions.space.medium.width,
              vertical: AppTheme.dimensions.space.small.height,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.colors.gray300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Página $currentPage de $totalPages',
              style: AppTheme.typography.body.small.copyWith(
                color: AppTheme.colors.darkGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppTheme.dimensions.space.large.width),
          if (isLoadingNextPage)
            Padding(
              padding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
              child: const SizedBox(width: 24, height: 24, child: CircularLoading()),
            )
          else
            AppIconButton(
              onPressed: () {
                if (!hasNextPage) return;
                onNextPage();
              },
              icon: Icons.arrow_forward,
              color: hasNextPage ? AppTheme.colors.primaryOrange : AppTheme.colors.gray300,
            ),
        ],
      ),
    );
  }
}
