import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:flutter/material.dart';

/// Iniciais do e-mail de quem está conectado; no desktop, também o e-mail.
class PanelUserBadge extends StatelessWidget {
  const PanelUserBadge({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final showEmail = breakpoint == Breakpoint.desktop;
    final showDivider = breakpoint != Breakpoint.mobile;
    final stroke = AppTheme.dimensions.stroke.small;

    // Sem nome nem foto, uma cor fixa de contraste conhecido no lugar da cor por pessoa.
    final avatar = SizedBox.square(
      dimension: components.panelAvatar,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: colors.line, width: stroke),
        ),
        child: Center(
          child: Text(
            initialsOf(email),
            maxLines: 1,
            // O círculo tem tamanho fixo; ampliar as iniciais as faria vazar.
            textScaler: TextScaler.noScaling,
            style: styles.panelAvatarInitials.copyWith(color: colors.ink),
          ),
        ),
      ),
    );

    return Semantics(
      label: 'Conectado como $email',
      excludeSemantics: true,
      child: Tooltip(
        message: email,
        excludeFromSemantics: true,
        constraints: BoxConstraints(maxWidth: components.tooltipMaxWidth),
        padding: EdgeInsets.symmetric(
          horizontal: components.tooltipPaddingH,
          vertical: components.tooltipPaddingV,
        ),
        decoration: BoxDecoration(
          color: colors.ink,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
        ),
        textStyle: styles.tooltip.copyWith(color: colors.white),
        child: Container(
          padding: EdgeInsets.only(left: showDivider ? components.panelUserDividerGap : 0),
          decoration: BoxDecoration(
            border: showDivider
                ? Border(
                    left: BorderSide(color: colors.line, width: stroke),
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatar,
              if (showEmail) ...[
                SizedBox(width: components.panelUserGap),
                Flexible(
                  child: Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.panelUserName.copyWith(color: colors.ink),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
