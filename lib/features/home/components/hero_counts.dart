import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HeroCounts extends StatelessWidget {
  const HeroCounts({super.key, this.store});

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  @override
  Widget build(BuildContext context) {
    final store = this.store ?? GetIt.I<CatalogStore>();
    final components = AppTheme.dimensions.components;
    final subthemes = ThemeDataModel.themes.fold<int>(0, (sum, t) => sum + t.subthemes.length);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: components.heroCountsTop),
      padding: EdgeInsets.only(top: components.heroCountsPaddingTop),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Observer(
        builder: (context) {
          final state = store.state;
          return Wrap(
            spacing: components.heroCountsGapH,
            runSpacing: components.heroCountsGapV,
            children: [
              ...switch (state) {
                CatalogStateSuccess(:final catalog) => [
                  _Count(value: catalog.total, label: 'objetos digitais'),
                ],
                CatalogStateError() => const <Widget>[],
                CatalogStateInitial() ||
                CatalogStateLoading() => const [_Count(label: 'objetos digitais')],
              },
              _Count(value: subthemes, label: 'subtemas'),
              _Count(value: ThemeDataModel.themes.length, label: 'temas'),
            ],
          );
        },
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, this.value});

  final String label;

  /// Sem valor, mostra o esqueleto no lugar do número.
  final int? value;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final value = this.value;

    final numberStyle = styles.h1.copyWith(
      fontSize: components.heroCountNumber,
      height: 1.1,
      letterSpacing: components.heroCountNumber * -0.03,
      color: colors.ink,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Semantics(
      label: value == null ? 'Carregando $label' : '$value $label',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value == null)
            SizedBox(
              height: components.heroCountNumber * 1.1,
              child: Center(
                widthFactor: 1,
                child: AppSkeleton(
                  width: components.heroCountSkeletonWidth,
                  height: components.heroCountNumber,
                ),
              ),
            )
          else
            Text('$value', style: numberStyle),
          Text(label, style: styles.small.copyWith(color: colors.inkSecondary)),
        ],
      ),
    );
  }
}
