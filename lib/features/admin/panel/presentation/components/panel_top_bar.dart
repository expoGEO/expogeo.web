import 'package:expogeo/core/components/brand/app_brand.dart';
import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_user_badge.dart';
import 'package:flutter/material.dart';

/// Endereço absoluto da Home, para abrir em outra aba a partir do painel.
String get siteHomeUrl => Uri.base.resolve(AppRouter.home).toString();

class PanelTopBar extends StatelessWidget {
  const PanelTopBar({
    required this.email,
    required this.showMenuButton,
    required this.isMenuOpen,
    required this.onMenuPressed,
    required this.menuFocusNode,
    required this.onBrandPressed,
    super.key,
  });

  final String? email;
  final bool showMenuButton;
  final bool isMenuOpen;
  final VoidCallback onMenuPressed;
  final FocusNode menuFocusNode;
  final VoidCallback onBrandPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final isMobile = breakpoint == Breakpoint.mobile;
    final gap = components.panelTopBarGap(breakpoint);
    final email = this.email;

    return Container(
      height: components.panelTopBarHeight,
      padding: EdgeInsetsDirectional.only(
        start: components.panelTopBarPaddingStart(breakpoint),
        end: components.panelTopBarPaddingEnd(breakpoint),
      ),
      decoration: BoxDecoration(
        color: colors.page,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Row(
        children: [
          if (showMenuButton) ...[
            AppIconButton(
              icon: isMenuOpen ? Icons.close : Icons.menu,
              color: colors.ink,
              label: 'Abrir menu do painel',
              tooltip: isMenuOpen ? 'Fechar menu do painel' : 'Abrir menu do painel',
              isExpanded: isMenuOpen,
              focusNode: menuFocusNode,
              onPressed: onMenuPressed,
            ),
            SizedBox(width: gap),
          ],
          AppBrand(
            tagline: 'Painel',
            showName: !isMobile,
            semanticLabel: 'Painel da expoGEO, objetos digitais',
            onTap: onBrandPressed,
          ),
          SizedBox(width: gap),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isMobile) ...[
                  AppButton.ghost(
                    text: 'Ver site',
                    size: AppButtonSize.small,
                    externalUrl: siteHomeUrl,
                  ),
                  SizedBox(width: components.panelTopBarActionsGap),
                ],
                if (email != null) Flexible(child: PanelUserBadge(email: email)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
