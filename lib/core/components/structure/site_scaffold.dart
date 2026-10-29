import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/components/structure/observatory_strip.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Estrutura das páginas públicas: a faixa rola junto, a navbar fica presa e o rodapé
/// encosta na base quando o conteúdo é curto.
class SiteScaffold extends StatelessWidget {
  const SiteScaffold({super.key, required this.slivers, this.background, this.controller});

  final List<Widget> slivers;
  final Color? background;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? AppTheme.colors.page,
      body: CustomScrollView(
        controller: controller,
        slivers: [
          const SliverToBoxAdapter(child: ObservatoryStrip()),
          const NavbarSliver(),
          ...slivers,
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Align(alignment: Alignment.bottomCenter, child: Footer()),
          ),
        ],
      ),
    );
  }
}
