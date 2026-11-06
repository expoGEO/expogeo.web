import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ThemeHeaderStats extends StatelessWidget {
  const ThemeHeaderStats({super.key, required this.theme, this.store});

  final ThemeModel theme;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  @override
  Widget build(BuildContext context) {
    final store = this.store ?? GetIt.I<CatalogStore>();
    final components = AppTheme.dimensions.components;
    final subthemes = theme.subthemes.length;

    return Padding(
      padding: EdgeInsets.only(top: components.themeStatsTop),
      child: Observer(
        builder: (context) {
          final state = store.state;
          return Wrap(
            spacing: components.themeStatsGapH,
            runSpacing: components.themeStatsGapV,
            children: [
              _Stat(value: subthemes, singular: 'subtema', plural: 'subtemas'),
              ...switch (state) {
                CatalogStateSuccess(:final catalog) => [
                  _Stat(
                    value: catalog.countByTheme(theme.type),
                    singular: 'objeto digital',
                    plural: 'objetos digitais',
                  ),
                ],
                CatalogStateError() => const <Widget>[],
                CatalogStateInitial() || CatalogStateLoading() => const [
                  _Stat(singular: 'objeto digital', plural: 'objetos digitais'),
                ],
              },
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.singular, required this.plural, this.value});

  final String singular;
  final String plural;

  /// Sem valor, mostra o esqueleto no lugar do número e fica fora da leitura de tela.
  final int? value;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final base = AppTheme.typography
        .of(context)
        .small
        .copyWith(fontSize: components.themeStatsText, color: colors.inkSecondary);
    final value = this.value;
    final noun = value == 1 ? singular : plural;

    final text = Text.rich(
      TextSpan(
        style: base,
        children: [
          if (value == null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: AppSkeleton(width: components.themeStatsSkeletonWidth, height: base.fontSize),
            )
          else
            TextSpan(
              text: '$value',
              style: base.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          TextSpan(text: ' $noun'),
        ],
      ),
    );

    if (value == null) return ExcludeSemantics(child: text);
    return Semantics(container: true, label: '$value $noun', excludeSemantics: true, child: text);
  }
}
