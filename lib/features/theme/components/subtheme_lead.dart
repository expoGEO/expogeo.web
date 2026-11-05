import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class SubthemeLead extends StatelessWidget {
  const SubthemeLead({super.key, required this.subtheme, this.store});

  final SubthemeEnum subtheme;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  @override
  Widget build(BuildContext context) {
    final store = this.store ?? GetIt.I<CatalogStore>();
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).reading;
    final line = style.fontSize! * style.height!;

    return Observer(
      builder: (context) {
        final child = switch (store.state) {
          CatalogStateSuccess(:final catalog) => _text(catalog.countBySubtheme(subtheme), style),
          CatalogStateError() => null,
          // A altura da linha evita que o cabeçalho pule quando a frase chega.
          CatalogStateInitial() || CatalogStateLoading() => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.subthemeLeadSkeletonWidth),
            child: SizedBox(
              height: line,
              child: Center(
                child: AppSkeleton(height: line * components.objectCardSkeletonBarFill),
              ),
            ),
          ),
        };
        if (child == null) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(top: components.pageHeadLeadGap),
          child: Align(alignment: Alignment.centerLeft, child: child),
        );
      },
    );
  }

  Widget? _text(int count, TextStyle style) {
    if (count == 0) return null;

    final name = subtheme.name.toLowerCase();
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: AppTheme.dimensions.components.readingMaxWidth),
      child: Text(
        count == 1
            ? '1 objeto digital selecionado sobre $name.'
            : '$count objetos digitais selecionados sobre $name.',
        style: style.copyWith(color: AppTheme.colors.inkSecondary),
      ),
    );
  }
}
