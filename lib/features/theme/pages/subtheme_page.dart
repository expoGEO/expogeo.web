import 'package:expogeo/core/components/loading/circular_loading.dart';
import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/theme/components/content_grid.dart';
import 'package:expogeo/features/theme/components/subtheme_banner.dart';
import 'package:expogeo/features/theme/components/subtheme_error.dart';
import 'package:expogeo/features/theme/presentation/stores/content_pagination_state.dart';
import 'package:expogeo/features/theme/presentation/stores/content_pagination_store.dart';
import 'package:expogeo/features/theme/theme_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SubthemePage extends StatefulWidget {
  final String themeId;
  final String subthemeId;

  const SubthemePage({super.key, required this.themeId, required this.subthemeId});

  @override
  State<SubthemePage> createState() => _SubthemePageState();
}

class _SubthemePageState extends State<SubthemePage> {
  late final _contentStore = ThemeSetup.getIt<ContentPaginationStore>();

  @override
  void initState() {
    super.initState();

    _loadContent();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getCurrentTheme();
    final subtheme = _getCurrentSubtheme(theme);

    return Scaffold(
      backgroundColor: AppTheme.colors.gray100,
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SubthemeBanner(theme: theme, subtheme: subtheme),
                  Observer(
                    builder: (context) {
                      final state = _contentStore.state;

                      if (state.isLoading &&
                          (!state.isNextPageLoading && !state.isPreviousPageLoading)) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppTheme.dimensions.space.huge.scale),
                            child: const CircularLoading(),
                          ),
                        );
                      }

                      if (state.isError) {
                        return SubthemeError(
                          message: (state as ContentPaginationStateError).message,
                          onRetry: _loadContent,
                        );
                      }

                      if (state.isSuccess) {
                        final successState = state as ContentPaginationStateSuccess;
                        final paginationData = successState.paginationData;

                        return ContentGrid(
                          contents: paginationData.items,
                          currentPage: paginationData.displayPage,
                          totalPages: paginationData.totalPages,
                          totalCount: paginationData.totalCount,
                          hasNextPage: paginationData.hasNextPage,
                          hasPreviousPage: paginationData.hasPreviousPage,
                          onNextPage: _contentStore.nextPage,
                          onPreviousPage: _contentStore.previousPage,
                          isLoadingNextPage: state.isNextPageLoading,
                          isLoadingPreviousPage: state.isPreviousPageLoading,
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: AppTheme.dimensions.space.large.height),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loadContent() {
    final theme = _getCurrentTheme();
    final subtheme = _getCurrentSubtheme(theme);

    _contentStore.loadContentsBySubtheme(subtheme: subtheme.type, theme: theme.type);
  }

  ThemeModel _getCurrentTheme() {
    return ThemeDataModel.themes.firstWhere(
      (t) => t.type.value == widget.themeId,
      orElse: () => ThemeDataModel.themes.first,
    );
  }

  SubthemeModel _getCurrentSubtheme(ThemeModel theme) {
    return theme.subthemes.firstWhere(
      (s) => s.type.value == widget.subthemeId,
      orElse: () => theme.subthemes.first,
    );
  }
}
