import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/components/button/secondary_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/components/loading/circular_loading.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_empty.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_error.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_form_dialog.dart';
import 'package:expogeo/features/admin/panel/presentation/components/content_list.dart';
import 'package:expogeo/features/admin/panel/presentation/components/theme_subtheme_selector.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_state.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  late final _contentStore = AdminSetup.getIt<ContentStore>();
  late final _authStore = AdminSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _reactions = [
      reaction((_) => _authStore.user, (User? user) {
        if (user == null) {
          GoRouter.of(context).go('/admin');
        }
      }),
      reaction((_) => _contentStore.state, (state) {
        if (state.isError) {
          Messenger.showError(context, (state as ContentStateError).message);
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isMobile = ScreenUtils.isMobile(context);
    bool isTablet = ScreenUtils.isTablet(context);

    return Scaffold(
      backgroundColor: AppTheme.colors.lightGray,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme.colors.white),
        backgroundColor: AppTheme.colors.black,
        title: isMobile
            ? Text(
                'PAINEL ADMINISTRATIVO',
                style: AppTheme.typography.body.big.copyWith(
                  color: AppTheme.colors.white,
                  fontWeight: FontWeight.w900,
                ),
              )
            : Text(
                'PAINEL ADMINISTRATIVO',
                style: AppTheme.typography.headline.small.copyWith(
                  color: AppTheme.colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small.width),
            child: AppIconButton(
              icon: Icons.exit_to_app,
              color: AppTheme.colors.white,
              size: 32,
              onPressed: _authStore.logout,
            ),
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
          child: Center(
            child: SizedBox(
              width: size.width * (isMobile ? 1 : (isTablet ? 0.9 : 0.95)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Observer(
                    builder: (context) {
                      return RoundedCard(
                        padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
                        child: ThemeSubthemeSelector(
                          onThemeSelected: (theme) {
                            _contentStore.loadContentsByTheme(theme: theme);
                          },
                          onSubthemeSelected: (theme, subtheme) {
                            _contentStore.loadContentsBySubtheme(subtheme: subtheme);
                          },
                          initialTheme: _contentStore.selectedTheme,
                          initialSubtheme: _contentStore.selectedSubtheme,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppTheme.dimensions.space.large.height),
                  Observer(
                    builder: (_) {
                      final hasSelection =
                          _contentStore.selectedTheme != null &&
                          _contentStore.selectedSubtheme != null;

                      return PrimaryButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ContentFormDialog(
                              contentStore: _contentStore,
                              theme: _contentStore.selectedTheme!,
                              subtheme: _contentStore.selectedSubtheme,
                            ),
                          );
                        },
                        label: "Novo Conteúdo",
                        isDisabled: !hasSelection,
                      );
                    },
                  ),
                  SizedBox(height: AppTheme.dimensions.space.large.height),
                  Observer(
                    builder: (_) {
                      if (_contentStore.state.isLoading) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppTheme.dimensions.space.huge.scale),
                            child: const CircularLoading(),
                          ),
                        );
                      }

                      if (_contentStore.state.isError) {
                        return ContentError(contentStore: _contentStore);
                      }

                      if (_contentStore.contents.isEmpty) {
                        return ContentEmpty(contentStore: _contentStore);
                      }

                      return ContentList(
                        contents: _contentStore.contents,
                        onEdit: (content) {
                          showDialog(
                            context: context,
                            builder: (context) => ContentFormDialog(
                              contentStore: _contentStore,
                              theme: _contentStore.selectedTheme!,
                              subtheme: _contentStore.selectedSubtheme,
                              content: content,
                            ),
                          );
                        },
                        onDelete: (content) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              insetPadding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
                              title: Text(
                                'Confirmar Exclusão',
                                style: AppTheme.typography.title.small,
                              ),
                              content: Text(
                                'Tem certeza que deseja deletar o conteúdo "${content.contentInfo.title}"?',
                                style: AppTheme.typography.body.small,
                              ),
                              actions: [
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: AppTheme.dimensions.space.small.height,
                                  ),
                                  child: SecondaryButton(
                                    onPressed: () => Navigator.pop(context),
                                    label: 'Cancelar',
                                  ),
                                ),
                                PrimaryButton(
                                  onPressed: () {
                                    _contentStore.deleteContent(
                                      subtheme: _contentStore.selectedSubtheme!,
                                      contentId: content.docId,
                                    );
                                    Navigator.pop(context);
                                  },
                                  label: 'Deletar',
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
