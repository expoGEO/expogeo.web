import 'dart:math';

import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/components/structure/observatory_strip.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SiteScaffold extends StatelessWidget {
  const SiteScaffold({super.key, required this.slivers, this.background, this.controller});

  final List<Widget> slivers;
  final Color? background;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? AppTheme.colors.page,
      // Textos soltos podem ser selecionados e copiados; os clicáveis desligam a seleção em si mesmos.
      body: SelectionArea(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            const SliverToBoxAdapter(child: ObservatoryStrip()),
            const NavbarSliver(),
            ...slivers,
            // `SliverFillRemaining` mediria o rodapé pela altura intrínseca, que ignora a largura
            // máxima do conteúdo: com texto ampliado, a medida sai menor que a real e ele estoura.
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final remaining =
                    constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;

                return SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: max(remaining, 0)),
                    child: const Footer(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
