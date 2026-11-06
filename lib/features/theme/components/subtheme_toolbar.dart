import 'package:expogeo/core/components/chip/filter_chip_button.dart';
import 'package:expogeo/core/components/field/app_search_field.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SubthemeToolbar extends StatelessWidget {
  const SubthemeToolbar({super.key, required this.store, required this.controller, this.focusNode});

  final SubthemeObjectsStore store;
  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final desktop = ScreenUtils.breakpointOf(context) == Breakpoint.desktop;
    final search = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: components.searchFieldMaxWidth),
      child: AppSearchField(
        controller: controller,
        focusNode: focusNode,
        hint: 'Buscar por título, assunto ou autor',
        semanticLabel: 'Buscar neste subtema',
        onChanged: store.setQuery,
        onClear: store.clearSearch,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: components.toolbarPaddingTop,
        bottom: components.toolbarPaddingBottom,
      ),
      child: desktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: search),
                SizedBox(width: components.toolbarGap),
                Expanded(
                  child: _TypeChips(store: store, alignment: WrapAlignment.end),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                search,
                SizedBox(height: components.toolbarGap),
                _TypeChips(store: store, alignment: WrapAlignment.start),
              ],
            ),
    );
  }
}

class _TypeChips extends StatelessWidget {
  const _TypeChips({required this.store, required this.alignment});

  static const _unit = (singular: 'objeto', plural: 'objetos');

  final SubthemeObjectsStore store;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.chipGap;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Filtrar por tipo',
      child: Observer(
        builder: (context) {
          final selected = store.type;
          final counts = store.typeCounts;
          return Wrap(
            alignment: alignment,
            spacing: gap,
            runSpacing: gap,
            children: [
              FilterChipButton(
                label: 'Todos',
                count: store.matches.length,
                countUnit: _unit,
                selected: selected == null,
                onPressed: () => store.selectType(null),
              ),
              for (final type in store.chipTypes)
                FilterChipButton(
                  label: type.value,
                  count: counts[type],
                  countUnit: _unit,
                  selected: selected == type,
                  onPressed: () => store.selectType(type),
                ),
            ],
          );
        },
      ),
    );
  }
}
