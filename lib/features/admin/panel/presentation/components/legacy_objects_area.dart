import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/components/dialog/confirm_dialog.dart';
import 'package:expogeo/core/components/loading/circular_loading.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_empty.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_error.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_form_dialog.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_list.dart';
import 'package:expogeo/features/admin/panel/presentation/components/theme_subtheme_selector.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_state.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

/// Seletor de tema e subtema, "Novo Conteúdo" e a tabela com edição e exclusão.
class LegacyObjectsArea extends StatefulWidget {
  const LegacyObjectsArea({required this.contentStore, super.key});

  final ContentStore contentStore;

  @override
  State<LegacyObjectsArea> createState() => _LegacyObjectsAreaState();
}

class _LegacyObjectsAreaState extends State<LegacyObjectsArea> {
  ContentStore get _store => widget.contentStore;

  late final ReactionDisposer _errorReaction;

  @override
  void initState() {
    super.initState();
    _errorReaction = reaction((_) => _store.state, (state) {
      if (state is ContentStateError && mounted) Messenger.showError(context, state.message);
    });
  }

  @override
  void dispose() {
    _errorReaction();
    super.dispose();
  }

  void _openForm({ContentResponseModel? content}) {
    showDialog(
      context: context,
      builder: (context) => ContentFormDialog(
        contentStore: _store,
        theme: _store.selectedTheme!,
        subtheme: _store.selectedSubtheme,
        content: content,
      ),
    );
  }

  Future<void> _confirmDelete(ContentResponseModel content) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Confirmar Exclusão',
      message: 'Tem certeza que deseja deletar o conteúdo "${content.contentInfo.title}"?',
      confirmText: 'Deletar',
      destructive: true,
    );
    if (!confirmed) return;
    _store.deleteContent(subtheme: _store.selectedSubtheme!, contentId: content.docId);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Observer(
          builder: (context) {
            final theme = _store.selectedTheme;
            final subtheme = _store.selectedSubtheme;
            return RoundedCard(
              padding: EdgeInsets.all(spacing.s24),
              // O seletor só copia a escolha inicial quando ela existe; a chave o recria a cada
              // escolha vinda de fora (endereço, menu ou "Limpar Filtro").
              child: ThemeSubthemeSelector(
                key: ValueKey((theme, subtheme)),
                onThemeSelected: (theme) => _store.loadContentsByTheme(theme: theme),
                onSubthemeSelected: (theme, subtheme) =>
                    _store.loadContentsBySubtheme(subtheme: subtheme),
                initialTheme: theme,
                initialSubtheme: subtheme,
              ),
            );
          },
        ),
        SizedBox(height: spacing.s24),
        Observer(
          builder: (_) {
            final hasSelection = _store.selectedTheme != null && _store.selectedSubtheme != null;
            return PrimaryButton(
              onPressed: _openForm,
              label: 'Novo Conteúdo',
              isDisabled: !hasSelection,
            );
          },
        ),
        SizedBox(height: spacing.s24),
        Observer(
          builder: (_) {
            if (_store.state.isLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(spacing.s32),
                  child: const CircularLoading(),
                ),
              );
            }
            if (_store.state.isError) return ContentError(contentStore: _store);
            if (_store.contents.isEmpty) return ContentEmpty(contentStore: _store);

            return ContentList(
              contents: _store.contents,
              onEdit: (content) => _openForm(content: content),
              onDelete: _confirmDelete,
            );
          },
        ),
      ],
    );
  }
}
