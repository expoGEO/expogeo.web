import 'package:expogeo/core/components/skeleton/loading_region.dart';
import 'package:expogeo/core/components/state/state_error_box.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/object_actions.dart';
import 'package:expogeo/features/theme/components/object_head.dart';
import 'package:expogeo/features/theme/components/object_note.dart';
import 'package:expogeo/features/theme/components/object_related_section.dart';
import 'package:expogeo/features/theme/components/object_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ObjectPage extends StatelessWidget {
  final String themeId;
  final String subthemeId;
  final String code;

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  const ObjectPage({
    super.key,
    required this.themeId,
    required this.subthemeId,
    required this.code,
    this.store,
  });

  @override
  Widget build(BuildContext context) {
    for (final theme in ThemeDataModel.themes) {
      if (theme.type.value != themeId) continue;
      for (final subtheme in theme.subthemes) {
        if (subtheme.type.value == subthemeId) {
          // A chave recomeça rolagem e "Link copiado" quando o roteador reaproveita a página.
          return _ObjectView(
            key: ValueKey('$subthemeId/$code'),
            theme: theme,
            subtheme: subtheme,
            code: code,
            store: store,
          );
        }
      }
    }
    return const NotFoundPage();
  }
}

class _ObjectView extends StatefulWidget {
  const _ObjectView({
    super.key,
    required this.theme,
    required this.subtheme,
    required this.code,
    this.store,
  });

  final ThemeModel theme;
  final SubthemeModel subtheme;
  final String code;
  final CatalogStore? store;

  @override
  State<_ObjectView> createState() => _ObjectViewState();
}

class _ObjectViewState extends State<_ObjectView> {
  late final CatalogStore _catalog = widget.store ?? GetIt.I<CatalogStore>();

  @override
  void initState() {
    super.initState();
    _catalog.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => switch (_catalog.state) {
        CatalogStateInitial() || CatalogStateLoading() => _page([
          // Um só "Carregando…" para cabeçalho e ficha; a trilha do cabeçalho já vale e segue legível.
          ObjectHead(theme: widget.theme, subtheme: widget.subtheme),
          const LoadingRegion(child: ObjectSheetSkeleton()),
        ]),
        CatalogStateError() => _page([
          ObjectHead(theme: widget.theme, subtheme: widget.subtheme, failed: true),
          SizedBox(height: AppTheme.dimensions.components.objectHeadTagGap),
          StateErrorBox(title: 'Não conseguimos carregar o objeto', onRetry: _catalog.ensureLoaded),
        ]),
        CatalogStateSuccess(:final catalog) => _loaded(catalog),
      },
    );
  }

  Widget _loaded(CatalogModel catalog) {
    final item = catalog.find(widget.subtheme.type, widget.code);
    if (item == null) return const NotFoundPage();

    final content = item.content;
    final note = content.contentInfo.contentNote;

    return _page([
      ObjectHead(theme: widget.theme, subtheme: widget.subtheme, item: item),
      ObjectActions(address: content.registrationInfo.location),
      if (note != null) ObjectNote(text: note),
      ObjectSheet(item: item),
    ], below: ObjectRelatedSection(item: item, catalog: catalog));
  }

  Widget _page(List<Widget> column, {Widget? below}) {
    return SiteScaffold(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageContent(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppTheme.dimensions.components.objectColumnMaxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: column,
                    ),
                  ),
                ),
              ),
              ?below,
            ],
          ),
        ),
      ],
    );
  }
}
