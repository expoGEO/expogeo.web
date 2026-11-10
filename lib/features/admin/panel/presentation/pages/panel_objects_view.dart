import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/dialog/confirm_dialog.dart';
import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/core/components/field/app_search_field.dart';
import 'package:expogeo/core/components/state/state_error_box.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_filter_bar.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_object_row.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_objects_list.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_view_scroll.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_list_memory.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/panel_objects_store.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

/// Lista de todos os objetos, com busca e filtros guardados no endereço.
class PanelObjectsView extends StatefulWidget {
  const PanelObjectsView({required this.selection, super.key});

  final PanelSelection selection;

  @override
  State<PanelObjectsView> createState() => _PanelObjectsViewState();
}

class _PanelObjectsViewState extends State<PanelObjectsView> {
  late final _contentStore = AdminSetup.getIt<ContentStore>();
  late final _catalogStore = AdminSetup.getIt<CatalogStore>();
  late final _store = PanelObjectsStore(_catalogStore);
  late final _listMemory = AdminSetup.getIt<PanelListMemory>();

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final Map<String, FocusNode> _titleFocus = {};

  // Buscas que a própria vista mandou para o endereço: quando voltam, o campo já tem o texto.
  final List<String?> _sentQueries = [];

  // O título só recebe o foco quando o tema muda por fora dos filtros (menu, endereço).
  bool _themeChangedByFilter = false;
  bool _focusTitleOnChange = true;

  late final ReactionDisposer _outcomeReaction;

  @override
  void initState() {
    super.initState();
    _store.applySelection(widget.selection);
    _listMemory.remember(PanelAddress.objectsWith(widget.selection));
    _searchController.text = widget.selection.query ?? '';
    _outcomeReaction = reaction((_) => _contentStore.outcome, _handleOutcome);
  }

  @override
  void didUpdateWidget(covariant PanelObjectsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selection = widget.selection;
    if (oldWidget.selection == selection) return;

    _store.applySelection(selection);
    _listMemory.remember(PanelAddress.objectsWith(selection));

    final ownIndex = _sentQueries.indexOf(selection.query);
    if (ownIndex >= 0) {
      _sentQueries.removeRange(0, ownIndex + 1);
    } else {
      _sentQueries.clear();
      _searchController.text = selection.query ?? '';
    }

    _focusTitleOnChange = !_themeChangedByFilter;
    _themeChangedByFilter = false;
  }

  @override
  void dispose() {
    _outcomeReaction();
    _searchController.dispose();
    _searchFocus.dispose();
    for (final node in _titleFocus.values) {
      node.dispose();
    }
    super.dispose();
  }

  FocusNode _titleFocusOf(CatalogItem item) =>
      _titleFocus.putIfAbsent(item.content.docId, FocusNode.new);

  void _go(PanelSelection next, {bool fromSearch = false}) {
    final location = PanelAddress.objectsWith(next);
    if (fromSearch) {
      _sentQueries.add(next.query);
      // Uma letra a mais não vira uma entrada nova no histórico do navegador.
      Router.neglect(context, () => GoRouter.of(context).go(location));
    } else {
      GoRouter.of(context).go(location);
    }
  }

  void _onSearchChanged(String text) {
    final selection = widget.selection;
    final query = text.trim();
    if (query == (selection.query ?? '')) return;
    _go(
      PanelSelection(
        theme: selection.theme,
        subtheme: selection.subtheme,
        type: selection.type,
        query: query.isEmpty ? null : query,
      ),
      fromSearch: true,
    );
  }

  void _onThemeSelected(ThemeEnum? theme) {
    final selection = widget.selection;
    if (theme == selection.theme) return;
    _themeChangedByFilter = true;
    _go(PanelSelection(theme: theme, type: selection.type, query: selection.query));
  }

  void _onSubthemeSelected(SubthemeEnum? subtheme) {
    final selection = widget.selection;
    if (subtheme == selection.subtheme) return;
    _go(
      PanelSelection(
        theme: selection.theme,
        subtheme: subtheme,
        type: selection.type,
        query: selection.query,
      ),
    );
  }

  void _onTypeSelected(ContentType? type) {
    final selection = widget.selection;
    if (type == selection.type) return;
    _go(
      PanelSelection(
        theme: selection.theme,
        subtheme: selection.subtheme,
        type: type,
        query: selection.query,
      ),
    );
  }

  void _showMore() {
    final firstNew = _store.visible.length;
    _store.showMore();
    final items = _store.visible;
    if (firstNew >= items.length) return;
    final node = _titleFocusOf(items[firstNew]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) node.requestFocus();
    });
  }

  void _newObject() {
    final selection = widget.selection;
    GoRouter.of(
      context,
    ).go(PanelAddress.newObject(theme: selection.theme, subtheme: selection.subtheme));
  }

  void _edit(CatalogItem item) => GoRouter.of(context).go(PanelAddress.editObject(item.content.id));

  Future<void> _delete(CatalogItem item) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir “${item.content.contentInfo.title}”?',
      message: 'O objeto sai do site e do painel. Não dá para desfazer.',
      confirmText: 'Excluir',
      destructive: true,
    );
    if (!confirmed) return;
    await _contentStore.deleteContent(subtheme: item.subtheme, contentId: item.content.docId);
  }

  void _handleOutcome(ContentOutcome? outcome) {
    if (outcome == null || !mounted) return;
    switch (outcome.kind) {
      // Salvar acontece no editor, que mostra o próprio aviso.
      case ContentOutcomeKind.created ||
          ContentOutcomeKind.updated ||
          ContentOutcomeKind.saveFailed:
        return;
      case ContentOutcomeKind.deleted:
        final docId = outcome.docId;
        if (docId != null) _store.hide(docId);
        Messenger.showSuccess(context, 'Objeto excluído');
        // O botão usado sumiu com a linha.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _searchFocus.requestFocus();
        });
      case ContentOutcomeKind.deleteFailed:
        Messenger.showError(context, 'Não deu para excluir. Tente de novo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selection = widget.selection;
    final theme = selection.theme;
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    final newButton = AppButton.primary(
      text: 'Novo objeto',
      leadingIcon: Icons.add,
      fullWidth: isMobile,
      onPressed: _newObject,
    );

    final filters = PanelFilterBar(
      search: AppSearchField(
        controller: _searchController,
        focusNode: _searchFocus,
        hint: 'Buscar por código, título, autor ou assunto',
        semanticLabel: 'Buscar objetos',
        height: AppTheme.dimensions.components.panelFilterHeight,
        radius: AppTheme.dimensions.radii.r10,
        onChanged: _onSearchChanged,
        onClear: () => _onSearchChanged(''),
      ),
      theme: (expand) => AppFilterSelect<ThemeEnum?>(
        semanticLabel: 'Tema',
        expand: expand,
        value: theme,
        options: [
          const AppFilterOption(null, 'Todos os temas'),
          for (final model in ThemeDataModel.themes) AppFilterOption(model.type, model.type.name),
        ],
        onSelected: _onThemeSelected,
      ),
      subtheme: (expand) => AppFilterSelect<SubthemeEnum?>(
        semanticLabel: 'Subtema',
        expand: expand,
        isDisabled: theme == null,
        value: selection.subtheme,
        options: [
          const AppFilterOption(null, 'Todos os subtemas'),
          if (theme != null)
            for (final subtheme in _store.subthemesOf(theme))
              AppFilterOption(subtheme, subtheme.name),
        ],
        onSelected: _onSubthemeSelected,
      ),
      type: (expand) => AppFilterSelect<ContentType?>(
        semanticLabel: 'Tipo',
        expand: expand,
        value: selection.type,
        options: [
          const AppFilterOption(null, 'Todos os tipos'),
          for (final type in contentTypeOrder) AppFilterOption(type, type.value),
        ],
        onSelected: _onTypeSelected,
      ),
    );

    return Observer(
      builder: (context) {
        final status = _store.status;
        return PanelViewScroll(
          children: [
            PanelSectionHeader(
              title: theme?.name ?? 'Objetos digitais',
              summary: status == PanelObjectsStatus.loading || status == PanelObjectsStatus.error
                  ? null
                  : _store.summary,
              announceSummary: true,
              focusTitleOnChange: _focusTitleOnChange,
              action: newButton,
            ),
            filters,
            switch (status) {
              PanelObjectsStatus.loading => const PanelObjectsSkeleton(),
              PanelObjectsStatus.error => StateErrorBox(
                title: 'Não conseguimos carregar os objetos',
                onRetry: _catalogStore.ensureLoaded,
              ),
              PanelObjectsStatus.empty => StateMessageBox(
                icon: Icons.inventory_2_outlined,
                title: 'Nenhum objeto cadastrado ainda',
                headingLevel: 2,
                action: AppButton.primary(
                  text: 'Novo objeto',
                  leadingIcon: Icons.add,
                  onPressed: _newObject,
                ),
              ),
              PanelObjectsStatus.emptyFiltered => const StateMessageBox(
                icon: Icons.search,
                title: 'Nenhum objeto com esses filtros',
                message: 'Mude a busca ou os filtros, ou cadastre um objeto novo.',
                headingLevel: 2,
              ),
              PanelObjectsStatus.ready => PanelObjectsList(
                footer: _store.footer,
                onShowMore: _store.hasMore ? _showMore : null,
                rows: [
                  for (final item in _store.visible)
                    PanelObjectRow(
                      key: ValueKey(item.content.docId),
                      item: item,
                      titleFocusNode: _titleFocusOf(item),
                      onEdit: () => _edit(item),
                      onDelete: () => _delete(item),
                    ),
                ],
              ),
            },
          ],
        );
      },
    );
  }
}
