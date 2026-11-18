import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/components/card/object_card_grid.dart';
import 'package:expogeo/core/components/skeleton/loading_region.dart';
import 'package:expogeo/core/components/state/state_error_inline.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class HomeRecentSection extends StatelessWidget {
  const HomeRecentSection({super.key, this.store});

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  static const int count = 6;

  @override
  Widget build(BuildContext context) {
    final store = this.store ?? GetIt.I<CatalogStore>();

    return Observer(
      builder: (context) {
        final Widget content;
        switch (store.state) {
          case CatalogStateInitial() || CatalogStateLoading():
            content = LoadingRegion(
              child: ObjectCardGrid(children: List.filled(count, const ObjectCardSkeleton())),
            );
          case CatalogStateError():
            content = StateErrorInline(
              message: 'Não conseguimos carregar os objetos recentes',
              onRetry: store.ensureLoaded,
            );
          case CatalogStateSuccess(:final catalog):
            final items = catalog.latest(count);
            if (items.isEmpty) return const SizedBox.shrink();
            content = ObjectCardGrid(
              children: [
                for (final item in items)
                  ObjectCard(
                    content: item.content,
                    subtheme: item.subtheme,
                    onOpen: () => GoRouter.of(context).go(item.route),
                  ),
              ],
            );
        }
        return _Section(child: content);
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final padding = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };

    return PageContent(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              headingLevel: 2,
              child: Text(
                'Adicionados recentemente',
                style: styles.h2.copyWith(color: AppTheme.colors.ink),
              ),
            ),
            SizedBox(height: components.sectionHeadGap),
            child,
          ],
        ),
      ),
    );
  }
}
