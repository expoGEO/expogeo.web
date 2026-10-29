import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/home_sections.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/home/components/carousel/themes_row.dart';
import 'package:expogeo/features/home/components/home_banner.dart';
import 'package:flutter/material.dart';

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
        const SliverToBoxAdapter(child: HomeBanner()),
        space,
        SliverToBoxAdapter(
          child: Center(key: _themesKey, child: const ThemesRow()),
        ),
        space,
      ],
    );
  }
}
