import 'package:expogeo/core/components/brand/app_brand.dart';
import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.footerGap;
    final line = AppTheme.dimensions.stroke.small;

    final columns = <Widget>[
      const _BrandColumn(),
      _LinksColumn(
        title: 'Temas',
        links: [
          for (final theme in ThemeDataModel.themes)
            _FooterLinkData(theme.title, route: theme.type.route),
        ],
      ),
      const _LinksColumn(
        title: 'Curadoria',
        links: [
          _FooterLinkData('Sobre a expoGEO', route: AppRouter.about),
          _FooterLinkData('Metadados da curadoria', url: AppLinks.curationMetadata),
          _FooterLinkData('Tese de doutorado', url: AppLinks.thesis),
          _FooterLinkData('Fale com a gente', route: AppRouter.contact),
        ],
      ),
      const _LinksColumn(
        title: 'Observatório',
        links: [
          _FooterLinkData('Visitar o site', url: AppLinks.observatory),
          _FooterLinkData(AppLinks.email, url: AppLinks.emailUrl, sameTab: true),
        ],
        trailing: _SocialButtons(),
      ),
    ];

    final Widget grid = switch (breakpoint) {
      Breakpoint.desktop => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: columns[0]),
          for (final column in columns.skip(1)) ...[
            SizedBox(width: gap),
            Expanded(flex: 2, child: column),
          ],
        ],
      ),
      Breakpoint.tablet => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < columns.length; i += 2) ...[
            if (i > 0) SizedBox(height: gap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: columns[i]),
                SizedBox(width: gap),
                Expanded(child: columns[i + 1]),
              ],
            ),
          ],
        ],
      ),
      Breakpoint.mobile => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            columns[i],
          ],
        ],
      ),
    };

    final bottomStyle = styles.small.copyWith(
      fontSize: components.footerBottomText,
      color: colors.footerSubtle,
    );

    return ColoredBox(
      color: colors.footerBackground,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.only(
            top: components.footerPaddingTop,
            bottom: components.footerPaddingBottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              grid,
              SizedBox(height: spacing.s40),
              Divider(height: line, thickness: line, color: colors.footerLine),
              SizedBox(height: spacing.s20),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: spacing.s12,
                runSpacing: spacing.s8,
                children: [
                  Text(
                    '© ${DateTime.now().year} expoGEO · Desenvolvido para fins educativos',
                    style: bottomStyle,
                  ),
                  Text(
                    'Uma iniciativa do Observatório do Ensino de História e Geografia',
                    style: bottomStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppBrand(onDark: true, tagline: 'Conhecimento, Tecnologia e Interatividade'),
        SizedBox(height: AppTheme.dimensions.spacing.s16),
        Text(
          AppLinks.address.join('\n'),
          style: AppTheme.typography
              .of(context)
              .small
              .copyWith(
                fontSize: components.footerText,
                height: 1.7,
                color: AppTheme.colors.footerMuted,
              ),
        ),
      ],
    );
  }
}

class _FooterLinkData {
  const _FooterLinkData(this.label, {this.route, this.url, this.sameTab = false});

  final String label;
  final String? route;
  final String? url;
  final bool sameTab;
}

class _LinksColumn extends StatelessWidget {
  const _LinksColumn({required this.title, required this.links, this.trailing});

  final String title;
  final List<_FooterLinkData> links;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;
    final trailing = this.trailing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: AppTheme.typography.of(context).label.copyWith(color: AppTheme.colors.white),
          ),
        ),
        SizedBox(height: spacing.s8),
        for (final link in links) _FooterLink(data: link),
        if (trailing != null) ...[SizedBox(height: spacing.s16), trailing],
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.data});

  final _FooterLinkData data;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  bool get _opensNewTab => widget.data.url != null && !widget.data.sameTab;

  void _open() {
    final data = widget.data;
    final route = data.route;
    if (route != null) {
      GoRouter.of(context).go(route);
    } else if (data.url case final url?) {
      UrlUtils.openUrl(url, sameTab: data.sameTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    final color = _hovered ? colors.footerHighlight : colors.footerText;
    final style = AppTheme.typography
        .of(context)
        .small
        .copyWith(fontSize: components.footerText, color: color);

    return Semantics(
      link: true,
      label: _opensNewTab ? '${widget.data.label}, abre em nova aba' : widget.data.label,
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
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: components.minTapTarget - spacing.s8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(widget.data.label, style: style)),
                if (_opensNewTab) ...[
                  SizedBox(width: spacing.s4),
                  Icon(Icons.north_east, size: style.fontSize, color: color),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    // O Ink pinta no Material mais próximo; sem um aqui, a borda ficaria no lugar errado.
    return Material(
      type: MaterialType.transparency,
      child: Wrap(
        spacing: spacing.s8,
        runSpacing: spacing.s8,
        children: const [
          _SocialButton(icon: 'instagram', label: 'Instagram', url: AppLinks.observatoryInstagram),
          _SocialButton(icon: 'facebook', label: 'Facebook', url: AppLinks.observatoryFacebook),
          _SocialButton(icon: 'youtube', label: 'YouTube', url: AppLinks.observatoryYoutube),
        ],
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({required this.icon, required this.label, required this.url});

  final String icon;
  final String label;
  final String url;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  void _open() => UrlUtils.openUrl(widget.url);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final name = '${widget.label} do Observatório';
    final iconColor = _hovered ? colors.footerHighlight : colors.footerText;
    final borderColor = _hovered ? colors.footerHighlight : colors.footerLine;

    return Tooltip(
      message: name,
      child: Semantics(
        link: true,
        label: '$name, abre em nova aba',
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
            child: Ink(
              width: components.socialButton,
              height: components.socialButton,
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/${widget.icon}.svg',
                  width: components.navIcon,
                  height: components.navIcon,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
