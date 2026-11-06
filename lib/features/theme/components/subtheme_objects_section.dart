import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/theme/components/object_row.dart';
import 'package:expogeo/features/theme/components/subtheme_subjects.dart';
import 'package:expogeo/features/theme/components/subtheme_toolbar.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class SubthemeObjectsSection extends StatefulWidget {
  const SubthemeObjectsSection({
    super.key,
    required this.theme,
    required this.store,
    required this.controller,
    required this.searchFocusNode,
  });

  static const int skeletonRows = 3;

  final ThemeModel theme;
  final SubthemeObjectsStore store;
  final TextEditingController controller;
  final FocusNode searchFocusNode;

  @override
  State<SubthemeObjectsSection> createState() => _SubthemeObjectsSectionState();
}

class _SubthemeObjectsSectionState extends State<SubthemeObjectsSection> {
  final FocusNode _firstNewFocusNode = FocusNode();
  int? _firstNewIndex;

  SubthemeObjectsStore get _store => widget.store;

  @override
  void dispose() {
    _firstNewFocusNode.dispose();
    super.dispose();
  }

  void _setText(String text) {
    widget.controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _applySubject(String subject) {
    _store.applySubject(subject);
    _setText(subject);
  }

  void _clearAll() {
    _store.reset();
    _setText('');
    widget.searchFocusNode.requestFocus();
  }

  void _loadMore() {
    setState(() => _firstNewIndex = _store.visible.length);
    _store.loadMore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _firstNewFocusNode.requestFocus();
      final target = _firstNewFocusNode.context;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageContent(
      child: Observer(
        builder: (context) => switch (_store.catalogState) {
          CatalogStateInitial() || CatalogStateLoading() => _skeleton(),
          CatalogStateError() => _withTop(
            StateMessageBox(
              icon: Icons.cloud_off_outlined,
              tone: StateMessageTone.error,
              title: 'Não conseguimos carregar os objetos',
              message: 'Confira sua conexão com a internet e tente de novo.',
              action: AppButton.secondary(text: 'Tentar de novo', onPressed: _store.retry),
            ),
          ),
          CatalogStateSuccess() when _store.items.isEmpty => _withTop(
            StateMessageBox(
              icon: Icons.inbox_outlined,
              title: 'Nenhum objeto neste subtema ainda',
              action: AppButton.ghost(
                text: 'Voltar a ${widget.theme.title}',
                onPressed: () => context.go(widget.theme.type.route),
              ),
            ),
          ),
          CatalogStateSuccess() => _content(),
        },
      ),
    );
  }

  Widget _withTop(Widget child) => Padding(
    padding: EdgeInsets.only(top: AppTheme.dimensions.components.toolbarPaddingTop),
    child: child,
  );

  Widget _skeleton() {
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.only(
        top: components.toolbarPaddingTop,
        bottom: components.objectListPaddingBottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < SubthemeObjectsSection.skeletonRows; i++) const ObjectRowSkeleton(),
        ],
      ),
    );
  }

  Widget _content() {
    final components = AppTheme.dimensions.components;
    final colors = AppTheme.colors;
    final style = AppTheme.typography
        .of(context)
        .small
        .copyWith(fontSize: components.resultCountText, color: colors.inkSecondary);
    final subthemeName = _store.subtheme.name;
    final search = _store.query.trim();
    final summary = _store.summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SubthemeToolbar(
          store: _store,
          controller: widget.controller,
          focusNode: widget.searchFocusNode,
        ),
        SubthemeSubjects(store: _store, onSelected: _applySubject),
        if (summary.isEmpty)
          StateMessageBox(
            icon: Icons.search_off,
            title: 'Nenhum objeto encontrado',
            message:
                'Nada em $subthemeName combina com “$search”. '
                'Tente outra palavra ou veja todos os tipos.',
            action: AppButton.secondary(text: 'Limpar busca', onPressed: _clearAll),
          )
        else ...[
          Padding(
            padding: EdgeInsets.only(
              top: components.resultCountPaddingTop,
              bottom: components.resultCountPaddingBottom,
            ),
            child: Semantics(
              container: true,
              liveRegion: true,
              label: summary,
              excludeSemantics: true,
              child: Text(summary, style: style),
            ),
          ),
          for (final (index, item) in _store.visible.indexed)
            ObjectRow(
              key: ValueKey(item.content.docId),
              item: item,
              detailsRoute: item.route,
              primaryFocusNode: index == _firstNewIndex ? _firstNewFocusNode : null,
            ),
          if (_store.hasMore)
            Padding(
              padding: EdgeInsets.only(top: components.loadMorePaddingTop),
              child: Center(
                child: AppButton.secondary(text: 'Carregar mais', onPressed: _loadMore),
              ),
            ),
          SizedBox(height: components.objectListPaddingBottom),
        ],
      ],
    );
  }
}
