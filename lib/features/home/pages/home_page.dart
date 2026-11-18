import 'package:expogeo/core/components/partners/partners_section.dart';
import 'package:expogeo/core/components/structure/observatory_card.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/components/structure/page_meta_scope.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/navigation/home_sections.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:expogeo/core/utils/constants/site_copy.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/home_about_section.dart';
import 'package:expogeo/features/home/components/home_explore_section.dart';
import 'package:expogeo/features/home/components/home_hero.dart';
import 'package:expogeo/features/home/components/home_recent_section.dart';
import 'package:expogeo/features/home/components/home_themes_section.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _themesKey = GlobalKey();
  final _themesTitleFocus = FocusNode(debugLabel: 'Por onde começar');

  @override
  void initState() {
    super.initState();
    GetIt.I<CatalogStore>().ensureLoaded();
    HomeSections.themesRequested.addListener(_scrollToThemes);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToThemes());
  }

  @override
  void dispose() {
    HomeSections.themesRequested.removeListener(_scrollToThemes);
    _themesTitleFocus.dispose();
    super.dispose();
  }

  void _scrollToThemes() {
    if (!HomeSections.themesRequested.value) return;
    final target = _themesKey.currentContext;
    if (target == null) return;

    HomeSections.themesRequested.value = false;
    _ensureThemesVisible(target);
  }

  Future<void> _exploreThemes() async {
    final target = _themesKey.currentContext;
    if (target == null) return;

    await _ensureThemesVisible(target);
    if (mounted) _themesTitleFocus.requestFocus();
  }

  Future<void> _ensureThemesVisible(BuildContext target) {
    return Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : AppTheme.dimensions.components.menuAnimation * 3,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final sectionPadding = switch (ScreenUtils.breakpointOf(context)) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };

    return PageMetaScope(
      meta: const PageMeta(
        title: SiteCopy.homeTitle,
        description: SiteCopy.homeDescription,
        path: AppRouter.home,
      ),
      child: SiteScaffold(
        background: AppTheme.colors.page,
        slivers: [
          SliverToBoxAdapter(child: HomeHero(onExploreThemes: _exploreThemes)),
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: _themesKey,
              child: HomeThemesSection(titleFocusNode: _themesTitleFocus),
            ),
          ),
          const SliverToBoxAdapter(child: HomeExploreSection()),
          const SliverToBoxAdapter(child: HomeRecentSection()),
          const SliverToBoxAdapter(child: HomeAboutSection()),
          const SliverToBoxAdapter(child: PartnersSection()),
          SliverToBoxAdapter(
            child: PageContent(
              child: Padding(
                padding: EdgeInsets.only(bottom: sectionPadding),
                child: const ObservatoryCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
