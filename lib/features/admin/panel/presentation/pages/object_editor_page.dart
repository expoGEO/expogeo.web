import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/dialog/confirm_dialog.dart';
import 'package:expogeo/core/components/state/state_error_box.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/browser/leave_guard.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:expogeo/features/admin/panel/infra/models/reference_code.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_bar.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_fields.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_layout.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_missing_alert.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_side.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_skeleton.dart';
import 'package:expogeo/features/admin/panel/presentation/editor/object_editor_form.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_list_memory.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

/// Cadastro e edição de um objeto em página própria, fora da moldura do painel.
class ObjectEditorPage extends StatefulWidget {
  const ObjectEditorPage.create({this.selection = const PanelSelection(), super.key}) : code = null;

  const ObjectEditorPage.edit({required String this.code, super.key})
    : selection = const PanelSelection();

  /// Tema e subtema que o novo objeto já traz.
  final PanelSelection selection;

  /// O objeto a editar; nulo no novo.
  final String? code;

  static const String saveFailedMessage = 'Não deu para salvar. Confira a conexão e tente de novo.';

  static final _unsaved = ValueNotifier<bool>(false);
  static String? _location;

  /// Chamado pelo `onExit` das rotas do editor: o botão de voltar, o "voltar" do navegador e links.
  static Future<bool> confirmLeave(BuildContext context) async {
    if (!_unsaved.value) return true;

    final leave = await showConfirmDialog(
      context,
      title: 'Sair sem salvar?',
      message: 'As alterações feitas aqui serão perdidas.',
      confirmText: 'Sair sem salvar',
      cancelText: 'Continuar editando',
    );
    if (leave) {
      _unsaved.value = false;
      return true;
    }

    // No "voltar" do navegador o endereço já mudou; sem isto, ficaria o da lista com o editor na
    // tela.
    final location = _location;
    final current = browserLocation();
    if (context.mounted && location != null && current != null && current != location) {
      final router = GoRouter.of(context);
      final info = router.routeInformationParser.restoreRouteInformation(
        router.routerDelegate.currentConfiguration,
      );
      if (info != null) {
        router.routeInformationProvider.routerReportsNewRouteInformation(
          info,
          type: RouteInformationReportingType.navigate,
        );
      }
    }
    return false;
  }

  @override
  State<ObjectEditorPage> createState() => _ObjectEditorPageState();
}

class _ObjectEditorPageState extends State<ObjectEditorPage> {
  late final _authStore = AdminSetup.getIt<AuthStore>();
  late final _contentStore = AdminSetup.getIt<ContentStore>();
  late final _catalogStore = AdminSetup.getIt<CatalogStore>();
  late final _listMemory = AdminSetup.getIt<PanelListMemory>();

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _alertFocus = FocusNode();
  final _alertKey = GlobalKey();
  late final ReactionDisposer _userReaction;

  ObjectEditorForm? _form;
  CatalogItem? _item;
  bool _notFound = false;

  bool _submitted = false;
  List<EditorProblem>? _problems;
  bool _saving = false;

  bool get _isNew => widget.code == null;

  @override
  void initState() {
    super.initState();
    ObjectEditorPage._unsaved.value = false;
    ObjectEditorPage._unsaved.addListener(_syncLeaveWarning);

    _authStore.currentUser();
    _userReaction = reaction((_) => _authStore.user, (User? user) {
      if (user == null) _leave(AppRouter.admin);
    });
    _catalogStore.ensureLoaded();
  }

  @override
  void dispose() {
    _userReaction();
    ObjectEditorPage._unsaved.removeListener(_syncLeaveWarning);
    ObjectEditorPage._unsaved.value = false;
    setLeaveWarning(false);
    _form?.dispose();
    _alertFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _syncLeaveWarning() => setLeaveWarning(ObjectEditorPage._unsaved.value);

  void _leave(String location) {
    ObjectEditorPage._unsaved.value = false;
    if (mounted) GoRouter.of(context).go(location);
  }

  void _goBack() => GoRouter.of(context).go(_listMemory.location);

  /// Monta o formulário uma vez, quando o catálogo chega.
  void _prepare(CatalogModel catalog) {
    if (_form != null || _notFound) return;

    final code = widget.code;
    final ObjectEditorForm form;
    if (code == null) {
      form = ObjectEditorForm.create(
        theme: widget.selection.theme,
        subtheme: widget.selection.subtheme,
      );
    } else {
      final item = catalog.findByCode(code);
      if (item == null) {
        _notFound = true;
        return;
      }
      _item = item;
      form = ObjectEditorForm.edit(
        theme: item.theme,
        subtheme: item.subtheme,
        content: item.content,
      );
    }
    form.addListener(_onFormChanged);
    for (final field in [EditorField.theme, EditorField.subtheme]) {
      form.focusOf(field).addListener(() => _revealWhenFocused(form.focusOf(field)));
    }
    _form = form;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final first = form.theme == null || form.subtheme == null
          ? form.focusOf(form.theme == null ? EditorField.theme : EditorField.subtheme)
          : form.focusOf(EditorField.title);
      first.requestFocus();
      if (first == form.focusOf(EditorField.title)) _keepTitleUnselected(form);
    });
  }

  // No desktop e no navegador, o campo ganha o foco com o texto todo selecionado; ao abrir, o
  // cursor fica no fim.
  void _keepTitleUnselected(ObjectEditorForm form) {
    final node = form.focusOf(EditorField.title);
    void collapse() {
      if (!node.hasFocus) return;
      node.removeListener(collapse);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        form.title.selection = TextSelection.collapsed(offset: form.title.text.length);
      });
    }

    if (node.hasFocus) return collapse();
    node.addListener(collapse);
  }

  // Pelo Tab, o foco chega à lateral depois do último campo, que fica acima na tela, e o Flutter
  // não rola para trás nesse caso.
  void _revealWhenFocused(FocusNode node) {
    final context = node.context;
    if (!node.hasFocus || context == null) return;
    Scrollable.ensureVisible(
      context,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
  }

  void _onFormChanged() {
    final form = _form;
    if (form == null || !mounted) return;
    if (!_saving) ObjectEditorPage._unsaved.value = form.hasChanges;
    setState(() {});
  }

  /// O código que o objeto vai ter: o próprio, enquanto não muda de subtema; senão, o próximo do
  /// subtema escolhido.
  String? _codeFor(ObjectEditorForm form, CatalogModel catalog) {
    final subtheme = form.subtheme;
    if (subtheme == null) return null;
    final item = _item;
    if (item != null && item.subtheme == subtheme) return item.content.id;
    return nextCode(catalog.codesOf(subtheme), subtheme);
  }

  void _showProblems(List<EditorProblem> problems) {
    setState(() => _problems = problems);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final alert = _alertKey.currentContext;
      if (alert != null) Scrollable.ensureVisible(alert, alignment: 0.1);
      _alertFocus.requestFocus();
    });
  }

  void _goToField(EditorProblem problem) {
    final node = _form!.focusOf(problem.field);
    final fieldContext = node.context;
    if (fieldContext != null) Scrollable.ensureVisible(fieldContext, alignment: 0.2);
    node.requestFocus();
  }

  Future<void> _save() async {
    final form = _form;
    final catalog = _catalogStore.catalog;
    if (_saving || form == null || catalog == null) return;

    setState(() => _submitted = true);
    _formKey.currentState?.validate();
    final problems = form.missing();
    if (problems.isNotEmpty) return _showProblems(problems);
    setState(() => _problems = null);

    final subtheme = form.subtheme!;
    final shownCode = _codeFor(form, catalog)!;
    final item = _item;
    final moving = item != null && item.subtheme != subtheme;
    if (moving) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Mudar de subtema?',
        message:
            'O objeto vai para ${subtheme.name} e recebe o código $shownCode. '
            'O endereço antigo deixa de funcionar.',
        confirmText: 'Mudar e salvar',
      );
      if (!confirmed || !mounted) return;
    }

    setState(() => _saving = true);
    final ContentOutcome outcome;
    if (item == null) {
      outcome = await _contentStore.createContent(
        subtheme: subtheme,
        content: form.build(code: shownCode, docId: shownCode, insertionDate: DateTime.now()),
      );
    } else {
      final content = form.build(
        code: moving ? shownCode : item.content.id,
        docId: moving ? shownCode : item.content.docId,
        insertionDate: item.content.originInfo.insertionDate,
      );
      outcome = moving
          ? await _contentStore.moveContent(
              from: item.subtheme,
              docId: item.content.docId,
              to: subtheme,
              content: content,
            )
          : await _contentStore.updateContent(
              subtheme: item.subtheme,
              contentId: item.content.docId,
              content: content,
            );
    }
    if (!mounted) return;

    if (outcome.kind == ContentOutcomeKind.saveFailed) {
      setState(() => _saving = false);
      Messenger.showError(context, ObjectEditorPage.saveFailedMessage);
      return;
    }

    ObjectEditorPage._unsaved.value = false;
    _catalogStore.refresh();
    final saved = outcome.code;
    Messenger.showSuccess(
      context,
      item == null
          ? saved != null && saved != shownCode
                ? 'Objeto cadastrado com o código $saved'
                : 'Objeto cadastrado'
          : moving && saved != null && saved != shownCode
          ? 'Alterações salvas. O objeto recebeu o código $saved'
          : 'Alterações salvas',
    );
    GoRouter.of(context).go(_listMemory.location);
  }

  @override
  Widget build(BuildContext context) {
    ObjectEditorPage._location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: AppTheme.colors.surface,
      body: Observer(
        builder: (context) {
          final state = _catalogStore.state;
          final catalog = _catalogStore.catalog;
          if (catalog != null) _prepare(catalog);
          final form = _form;
          final isReady = catalog != null && form != null;
          final code = isReady ? _codeFor(form, catalog) : null;

          final Widget body;
          if (_notFound) {
            body = _message(
              StateMessageBox(
                icon: Icons.search_off,
                title: 'Não encontramos este objeto',
                message: 'Ele pode ter sido excluído ou o endereço está incompleto.',
                headingLevel: 2,
                action: _backButton(),
              ),
            );
          } else if (catalog == null && state is CatalogStateError) {
            body = _message(
              StateMessageBox(
                icon: Icons.error_outline,
                tone: StateMessageTone.error,
                title: 'Não conseguimos carregar o editor',
                message: StateErrorBox.message,
                headingLevel: 2,
                action: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppTheme.dimensions.components.editorBarActionsGap,
                  runSpacing: AppTheme.dimensions.components.editorBarActionsGap,
                  children: [
                    AppButton.primary(
                      text: StateErrorBox.retryLabel,
                      onPressed: _catalogStore.ensureLoaded,
                    ),
                    _backButton(),
                  ],
                ),
              ),
            );
          } else if (isReady) {
            body = _content(form, code);
          } else {
            body = ObjectEditorSkeleton(controller: _scrollController);
          }

          return FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FocusTraversalGroup(
                  child: ObjectEditorBar(
                    title: _isNew ? 'Novo objeto' : 'Editar objeto',
                    code: code,
                    showActions: isReady,
                    saving: _saving,
                    onBack: _goBack,
                    onCancel: _goBack,
                    onSave: _save,
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _backButton() => AppButton.secondary(text: 'Voltar aos objetos', onPressed: _goBack);

  Widget _message(Widget box) {
    final components = AppTheme.dimensions.components;
    return SingleChildScrollView(
      padding: EdgeInsets.all(components.editorPadding(ScreenUtils.breakpointOf(context))),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: components.editorMaxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.colors.page,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
            ),
            child: box,
          ),
        ),
      ),
    );
  }

  Widget _content(ObjectEditorForm form, String? code) {
    final problems = _problems;

    // Deixar os campos só de leitura quebra a digitação no navegador; tirar o foco e o toque já
    // impede a edição enquanto grava.
    return ExcludeFocus(
      excluding: _saving,
      child: AbsorbPointer(
        absorbing: _saving,
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ObjectEditorLayout(
            controller: _scrollController,
            alert: problems == null || problems.isEmpty
                ? null
                : ObjectEditorMissingAlert(
                    key: _alertKey,
                    problems: problems,
                    focusNode: _alertFocus,
                    onSelect: _goToField,
                  ),
            where: ObjectEditorWhere(form: form, code: code),
            cards: ObjectEditorFields.cards(context, form, today: DateTime.now()),
            preview: ObjectEditorPreview(form: form, code: code),
          ),
        ),
      ),
    );
  }
}
