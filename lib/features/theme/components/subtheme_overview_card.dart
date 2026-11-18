import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class SubthemeOverviewCard extends StatefulWidget {
  const SubthemeOverviewCard({super.key, required this.subtheme, this.store});

  final SubthemeModel subtheme;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  @override
  State<SubthemeOverviewCard> createState() => _SubthemeOverviewCardState();
}

class _SubthemeOverviewCardState extends State<SubthemeOverviewCard> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _open() => GoRouter.of(context).go(widget.subtheme.type.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    // Em 600 px a coluna do tablet é mais estreita que a do celular: o nome maior partiria palavras.
    final compact = breakpoint != Breakpoint.desktop;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : components.hoverAnimation;
    final radius = BorderRadius.circular(dimensions.radii.r18);
    final medallion = switch (breakpoint) {
      Breakpoint.mobile => components.subthemeCardMedallionMobile,
      Breakpoint.tablet => components.subthemeCardMedallionTablet,
      Breakpoint.desktop => components.subthemeCardMedallionDesktop,
    };
    final moving = _hovered && !reduceMotion;
    final store = widget.store ?? GetIt.I<CatalogStore>();

    final body = Padding(
      padding: compact ? components.subthemeCardPaddingMobile : components.subthemeCardPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedRotation(
            turns: moving ? components.themeCardMedallionTurn / 360 : 0,
            duration: duration,
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: moving ? components.subthemeCardHoverScale : 1,
              duration: duration,
              curve: Curves.easeOut,
              child: AppMedallion(size: medallion, image: widget.subtheme.image),
            ),
          ),
          SizedBox(height: components.subthemeCardGap + components.subthemeCardNameTop),
          Semantics(
            container: true,
            header: true,
            headingLevel: 3,
            child: Text(
              widget.subtheme.type.name,
              textAlign: TextAlign.center,
              style: styles.h3.copyWith(
                fontSize: compact ? components.subthemeCardNameMobile : components.subthemeCardName,
                height: components.subthemeCardNameHeight,
                color: _hovered ? colors.accent : colors.ink,
              ),
            ),
          ),
          _SubthemeCount(subtheme: widget.subtheme, store: store),
        ],
      ),
    );

    return SelectionContainer.disabled(
      child: Semantics(
        link: true,
        label: widget.subtheme.type.name,
        onTap: _open,
        // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
        focusable: true,
        focused: _focused,
        onFocus: _focusNode.requestFocus,
        container: true,
        explicitChildNodes: true,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: _hovered ? dimensions.shadows.elevated : const [],
          ),
          child: AppFocusRing(
            borderRadius: radius,
            fit: StackFit.passthrough,
            child: Material(
              color: colors.page,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: radius,
                side: BorderSide(
                  color: _hovered ? colors.accent : colors.line,
                  width: dimensions.stroke.small,
                ),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  body,
                  // Por cima do conteúdo e fora da semântica: assim o cabeçalho e os textos
                  // continuam nós próprios dentro do link, sem um segundo ponto de foco.
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: InkWell(
                        focusNode: _focusNode,
                        onTap: _open,
                        onHover: (value) => setState(() => _hovered = value),
                        onFocusChange: (value) => setState(() => _focused = value),
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        mouseCursor: SystemMouseCursors.click,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubthemeCount extends StatelessWidget {
  const _SubthemeCount({required this.subtheme, required this.store});

  final SubthemeModel subtheme;
  final CatalogStore store;

  static String phrase(int count) => switch (count) {
    0 => 'Nenhum objeto ainda',
    1 => '1 objeto',
    _ => '$count objetos',
  };

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography
        .of(context)
        .small
        .copyWith(color: AppTheme.colors.inkSecondary);
    final gap = EdgeInsets.only(top: components.subthemeCardGap);
    // A altura de uma linha, para o cartão não pular quando o número chegar.
    final lineHeight = MediaQuery.textScalerOf(context).scale(style.fontSize!) * style.height!;

    return Observer(
      builder: (context) => switch (store.state) {
        CatalogStateSuccess(:final catalog) => Padding(
          padding: gap,
          child: Semantics(
            container: true,
            child: Text(
              phrase(catalog.countBySubtheme(subtheme.type)),
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ),
        CatalogStateError() => const SizedBox.shrink(),
        CatalogStateInitial() || CatalogStateLoading() => Padding(
          padding: gap,
          child: SizedBox(
            height: lineHeight,
            child: Center(
              widthFactor: 1,
              child: AppSkeleton(
                width: components.subthemeCardCountSkeletonWidth,
                height: style.fontSize,
              ),
            ),
          ),
        ),
      },
    );
  }
}
