import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

/// Faixa escura acima da navbar, ligando a expoGEO ao Observatório.
class ObservatoryStrip extends StatelessWidget {
  const ObservatoryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final textStyle = AppTheme.typography
        .of(context)
        .small
        .copyWith(fontSize: components.stripText, height: 1.4, color: colors.footerText);

    return ColoredBox(
      color: colors.footerBackground,
      child: PageContent(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: components.stripMinHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.s4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isMobile
                        ? 'Observatório do Ensino de História e Geografia'
                        : 'Um projeto do Observatório do Ensino de História e Geografia · UFU',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
                SizedBox(width: spacing.s12),
                _VisitLink(style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VisitLink extends StatefulWidget {
  const _VisitLink({required this.style});

  final TextStyle style;

  @override
  State<_VisitLink> createState() => _VisitLinkState();
}

class _VisitLinkState extends State<_VisitLink> {
  bool _hovered = false;

  void _open() => UrlUtils.openUrl(AppLinks.observatory);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    final color = _hovered ? colors.footerHighlight : colors.white;

    return Semantics(
      link: true,
      label: 'Visitar o site do Observatório, abre em nova aba',
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        color: colors.footerHighlight,
        child: InkWell(
          borderRadius: radius,
          onTap: _open,
          onHover: (value) => setState(() => _hovered = value),
          hoverColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Visitar',
                  style: widget.style.copyWith(fontWeight: FontWeight.w600, color: color),
                ),
                SizedBox(width: spacing.s4),
                Icon(Icons.north_east, size: widget.style.fontSize, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
