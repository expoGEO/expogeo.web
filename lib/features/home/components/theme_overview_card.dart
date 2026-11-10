import 'dart:math' as math;

import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ThemeOverviewCard extends StatefulWidget {
  const ThemeOverviewCard({super.key, required this.theme, this.store});

  final ThemeModel theme;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  static const int visibleSubthemes = 4;
  static const int visibleSubthemesCompact = 3;

  @override
  State<ThemeOverviewCard> createState() => _ThemeOverviewCardState();
}

class _ThemeOverviewCardState extends State<ThemeOverviewCard> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _open() => GoRouter.of(context).go(widget.theme.type.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final compact = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = components.hoverAnimation;
    final radius = BorderRadius.circular(dimensions.radii.r18);
    final medallion = compact
        ? components.themeCardMedallionCompact
        : components.themeCardMedallion;
    final lift = _hovered && !reduceMotion ? -components.themeCardHoverLift : 0.0;
    final turn = _hovered && !reduceMotion ? components.themeCardMedallionTurn / 360 : 0.0;

    final medallionView = AnimatedRotation(
      turns: turn,
      duration: reduceMotion ? Duration.zero : duration,
      curve: Curves.easeOut,
      child: AppMedallion(size: medallion, image: widget.theme.type.illustration),
    );
    final store = widget.store ?? GetIt.I<CatalogStore>();

    // No celular, com o medalhão ao lado, o texto fica numa coluna estreita e o cartão alto demais.
    final body = Padding(
      padding: compact ? components.themeCardPaddingCompact : components.themeCardPadding,
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    medallionView,
                    SizedBox(width: components.themeCardGapCompact),
                    Expanded(child: _CardTitle(theme: widget.theme, compact: true)),
                  ],
                ),
                SizedBox(height: components.themeCardHeaderGapCompact),
                _CardDetails(theme: widget.theme, store: store, compact: true),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                medallionView,
                SizedBox(width: components.themeCardGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(theme: widget.theme, compact: false),
                      SizedBox(height: components.themeCardDescriptionGap),
                      _CardDetails(theme: widget.theme, store: store, compact: false),
                    ],
                  ),
                ),
              ],
            ),
    );

    return SelectionContainer.disabled(
      child: Semantics(
        link: true,
        label: widget.theme.title,
        onTap: _open,
        // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
        focusable: true,
        focused: _focused,
        onFocus: _focusNode.requestFocus,
        container: true,
        explicitChildNodes: true,
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : duration,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, lift, 0),
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
                children: [
                  body,
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    height: components.themeCardStrip,
                    child: ExcludeSemantics(
                      child: DecoratedBox(
                        decoration: BoxDecoration(gradient: AppTheme.gradients.brand),
                      ),
                    ),
                  ),
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

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.theme, required this.compact});

  final ThemeModel theme;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      header: true,
      headingLevel: 3,
      child: Text(
        theme.title,
        style: AppTheme.typography
            .of(context)
            .h3
            .copyWith(
              fontSize: compact ? components.themeCardTitleCompact : components.themeCardTitle,
              color: AppTheme.colors.ink,
            ),
      ),
    );
  }
}

class _CardDetails extends StatelessWidget {
  const _CardDetails({required this.theme, required this.store, required this.compact});

  final ThemeModel theme;
  final CatalogStore store;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final subthemes = theme.subthemes;
    final visible = math.min(
      subthemes.length,
      compact ? ThemeOverviewCard.visibleSubthemesCompact : ThemeOverviewCard.visibleSubthemes,
    );
    final rest = subthemes.length - visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          child: Text(
            theme.description.trim(),
            style: styles.regular.copyWith(
              fontSize: compact
                  ? components.themeCardDescriptionCompact
                  : components.themeCardDescription,
              color: colors.inkSecondary,
            ),
          ),
        ),
        SizedBox(height: components.themeCardStatsGap),
        _CardStats(theme: theme, store: store),
        SizedBox(height: components.miniChipsGap),
        Wrap(
          spacing: components.miniChipSpacing,
          runSpacing: components.miniChipSpacing,
          children: [
            for (final subtheme in subthemes.take(visible)) _MiniChip(text: subtheme.type.name),
            if (rest > 0)
              Semantics(
                container: true,
                label: 'e mais $rest subtemas',
                excludeSemantics: true,
                child: _MiniChip(text: '+$rest'),
              ),
          ],
        ),
      ],
    );
  }
}

class _CardStats extends StatelessWidget {
  const _CardStats({required this.theme, required this.store});

  final ThemeModel theme;
  final CatalogStore store;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final styles = AppTheme.typography.of(context);
    final base = styles.small.copyWith(color: colors.inkSecondary);
    final number = base.copyWith(
      color: colors.ink,
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final subthemes = theme.subthemes.length;

    return Observer(
      builder: (context) {
        final state = store.state;
        final objects = switch (state) {
          CatalogStateSuccess(:final catalog) => catalog.countByTheme(theme.type),
          _ => null,
        };
        final loading = state.isInitial || state.isLoading;

        final label = StringBuffer('$subthemes subtemas');
        if (objects != null) label.write(', $objects objetos');

        return Semantics(
          container: true,
          label: label.toString(),
          excludeSemantics: true,
          child: Text.rich(
            TextSpan(
              style: base,
              children: [
                TextSpan(text: '$subthemes', style: number),
                const TextSpan(text: ' subtemas'),
                if (objects != null || loading) const TextSpan(text: ' · '),
                if (objects != null) TextSpan(text: '$objects', style: number),
                if (loading)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: AppSkeleton(
                      width: AppTheme.dimensions.spacing.s24,
                      height: base.fontSize,
                    ),
                  ),
                if (objects != null || loading) const TextSpan(text: ' objetos'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
        ),
        child: Padding(
          padding: components.miniChipPadding,
          child: Text(
            text,
            style: AppTheme.typography
                .of(context)
                .small
                .copyWith(fontSize: components.miniChipText, color: colors.inkSecondary),
          ),
        ),
      ),
    );
  }
}
