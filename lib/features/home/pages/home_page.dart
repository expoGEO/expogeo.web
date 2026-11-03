import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/home_sections.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/home_explore_section.dart';
import 'package:expogeo/features/home/components/home_hero.dart';
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
    return SiteScaffold(
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
      ],
    );
  }
}
