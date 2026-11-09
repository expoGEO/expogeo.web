import 'dart:math';

import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_state.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_sidebar.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_top_bar.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

/// Barra, menu lateral (ou gaveta) e a vista atual do painel.
class PanelShell extends StatefulWidget {
  const PanelShell({required this.location, required this.child, super.key});

  final Uri location;
  final Widget child;

  @override
  State<PanelShell> createState() => _PanelShellState();
}

class _PanelShellState extends State<PanelShell> {
  late final _authStore = AdminSetup.getIt<AuthStore>();
  late final _contentStore = AdminSetup.getIt<ContentStore>();
  late final _catalogStore = AdminSetup.getIt<CatalogStore>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _menuButtonFocus = FocusNode();
  bool _isDrawerOpen = false;
  bool _navigatedFromDrawer = false;

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _authStore.currentUser();
    // Recarrega ao abrir para não mostrar contagens de antes do login.
    _catalogStore.refresh();

    _reactions = [
      reaction((_) => _authStore.user, (User? user) {
        if (user == null && mounted) GoRouter.of(context).go(AppRouter.admin);
      }),
      reaction((_) => _authStore.state.logoutState, (LogoutState logoutState) {
        if (logoutState is LogoutStateError && mounted) {
          Messenger.showError(context, 'Não deu para sair. Tente de novo.');
        }
      }),
      reaction((_) => _contentStore.savedCount, (_) => _catalogStore.refresh()),
    ];
  }

  @override
  void dispose() {
    _menuButtonFocus.dispose();
    for (final reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  PanelView? get _view => PanelAddress.viewOf(widget.location.path);

  PanelSelection get _selection => PanelSelection.fromQuery(widget.location.queryParameters);

  void _navigate(String location) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _navigatedFromDrawer = true;
      _scaffoldKey.currentState?.closeDrawer();
    }

    // Voltar ao mesmo endereço não refaz a vista; a escolha do seletor volta à do endereço.
    if (location == widget.location.toString()) {
      if (_view == PanelView.objects) {
        _contentStore.selectFromAddress(theme: _selection.theme, subtheme: _selection.subtheme);
      }
      return;
    }
    GoRouter.of(context).go(location);
  }

  // A gaveta fica por cima do aviso curto; fechá-la antes deixa à vista a falha ao sair.
  void _logout() {
    _scaffoldKey.currentState?.closeDrawer();
    _authStore.logout();
  }

  void _toggleDrawer() {
    final scaffold = _scaffoldKey.currentState;
    if (scaffold == null) return;
    scaffold.isDrawerOpen ? scaffold.closeDrawer() : scaffold.openDrawer();
  }

  // Fechada sem escolha, o foco volta ao botão do menu; com escolha, vai para o título da vista.
  void _onDrawerChanged(bool isOpen) {
    setState(() => _isDrawerOpen = isOpen);
    if (isOpen) return;
    if (!_navigatedFromDrawer) _menuButtonFocus.requestFocus();
    _navigatedFromDrawer = false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final width = MediaQuery.sizeOf(context).width;
    final collapsed = width < components.panelCollapseWidth;
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    Widget sidebar({required bool isDrawer}) => PanelSidebar(
      catalogStore: _catalogStore,
      view: _view,
      theme: _selection.theme,
      isDrawer: isDrawer,
      onNavigate: _navigate,
      onLogout: _logout,
      onOpenSite: isDrawer && isMobile ? () => UrlUtils.openUrl(siteHomeUrl) : null,
    );

    // A vista fica num Navigator próprio, cuja barreira de página tira da árvore de acessibilidade
    // tudo o que foi pintado antes dela no mesmo contêiner: a barra e o menu sumiriam.
    final content = Semantics(
      container: true,
      child: ColoredBox(color: colors.surface, child: widget.child),
    );

    return Material(
      color: colors.page,
      child: Column(
        children: [
          Observer(
            builder: (_) => PanelTopBar(
              email: _authStore.user?.email,
              showMenuButton: collapsed,
              isMenuOpen: _isDrawerOpen,
              onMenuPressed: _toggleDrawer,
              menuFocusNode: _menuButtonFocus,
              onBrandPressed: () => _navigate(PanelAddress.objectsOf()),
            ),
          ),
          Expanded(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: colors.surface,
              drawerScrimColor: colors.scrim,
              onDrawerChanged: _onDrawerChanged,
              drawer: collapsed
                  ? Drawer(
                      width: min(
                        components.panelDrawerMaxWidth,
                        width * components.panelDrawerWidthFactor,
                      ),
                      backgroundColor: colors.page,
                      shape: const RoundedRectangleBorder(),
                      child: sidebar(isDrawer: true),
                    )
                  : null,
              body: collapsed
                  ? content
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: components.panelSidebarWidth,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: colors.line,
                                width: AppTheme.dimensions.stroke.small,
                              ),
                            ),
                          ),
                          child: FocusTraversalGroup(child: sidebar(isDrawer: false)),
                        ),
                        Expanded(child: content),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
