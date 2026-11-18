import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_location.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/components/structure/page_meta_scope.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  static const String title = 'Este lugar não está no mapa';
  static const String message =
      'O endereço pode ter mudado ou o conteúdo saiu da curadoria. '
      'Volte aos temas para continuar explorando.';

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    // Um endereço que começa por um tema não marca "Temas": o lugar pedido não existe.
    return PageMetaScope(
      meta: PageMeta.titled(
        title: title,
        description: message,
        path: AppRouter.home,
        noIndex: true,
      ),
      child: NavbarLocationScope.none(
        child: SiteScaffold(
          slivers: [
            SliverToBoxAdapter(
              child: PageContent(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: components.notFoundPaddingTop,
                    bottom: components.notFoundPaddingBottom,
                  ),
                  child: StateMessageBox(
                    leading: Text(
                      '404',
                      style: styles.stateCode.copyWith(color: AppTheme.colors.accent),
                    ),
                    title: title,
                    headingLevel: 1,
                    message: message,
                    announce: false,
                    action: AppButton.primary(
                      text: 'Ir para o início',
                      onPressed: () => context.go(AppRouter.home),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
