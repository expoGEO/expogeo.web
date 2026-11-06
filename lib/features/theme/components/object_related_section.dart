import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/components/card/object_card_grid.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ObjectRelatedSection extends StatelessWidget {
  const ObjectRelatedSection({super.key, required this.item, required this.catalog});

  static const int count = 3;

  final CatalogItem item;
  final CatalogModel catalog;

  @override
  Widget build(BuildContext context) {
    final others = catalog.othersOf(item, count);
    if (others.isEmpty) return const SizedBox.shrink();

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final subtheme = item.subtheme;

    return ColoredBox(
      color: colors.surface,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.objectRelatedPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: components.objectRelatedHeadGap,
                runSpacing: components.objectRelatedHeadGap,
                children: [
                  Semantics(
                    container: true,
                    header: true,
                    headingLevel: 2,
                    child: Text(
                      'Outros objetos de ${subtheme.name}',
                      style: AppTheme.typography.of(context).h2.copyWith(color: colors.ink),
                    ),
                  ),
                  AppButton.ghost(
                    text: 'Ver todos',
                    semanticLabel: 'Ver todos os objetos de ${subtheme.name}',
                    size: AppButtonSize.small,
                    trailingIcon: Icons.arrow_forward,
                    onPressed: () => context.go(subtheme.route),
                  ),
                ],
              ),
              SizedBox(height: components.sectionHeadGap),
              ObjectCardGrid(
                children: [
                  for (final other in others)
                    ObjectCard(
                      content: other.content,
                      subtheme: other.subtheme,
                      onOpen: () => context.go(other.route),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
