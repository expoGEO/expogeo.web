import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/home_sections.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/home/components/carousel/themes_row.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/home_hero.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _themesKey = GlobalKey();

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
    super.dispose();
  }

  void _scrollToThemes() {
    if (!HomeSections.themesRequested.value) return;
    final target = _themesKey.currentContext;
    if (target == null) return;

    HomeSections.themesRequested.value = false;
    _ensureThemesVisible(target);
  }

  void _exploreThemes() {
    final target = _themesKey.currentContext;
    if (target != null) _ensureThemesVisible(target);
  }

  void _ensureThemesVisible(BuildContext target) {
    Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : AppTheme.dimensions.components.menuAnimation * 3,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final space = SliverToBoxAdapter(child: SizedBox(height: AppTheme.dimensions.space.massive));

    return SiteScaffold(
      background: AppTheme.colors.gray100,
      slivers: [
        SliverToBoxAdapter(child: HomeHero(onExploreThemes: _exploreThemes)),
        space,
        SliverToBoxAdapter(
          child: Center(key: _themesKey, child: const ThemesRow()),
        ),
        space,
      ],
    );
  }
}
