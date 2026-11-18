import 'dart:ui' show lerpDouble;

import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/models/partner.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';

class PartnerLogo extends StatefulWidget {
  const PartnerLogo({super.key, required this.partner});

  final Partner partner;

  @override
  State<PartnerLogo> createState() => _PartnerLogoState();
}

class _PartnerLogoState extends State<PartnerLogo> {
  static const List<double> _identity = [
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  // Luminância Rec. 709, o mesmo cinza do `grayscale(1)` do CSS.
  static const List<double> _grayscale = [
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  bool _hovered = false;
  bool _focused = false;
  bool _failed = false;

  Partner get _partner => widget.partner;

  bool get _active =>
      _hovered ||
      (_focused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional);

  void _open() => UrlUtils.openUrl(_partner.url);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r14);

    return Semantics(
      link: true,
      label: '${_partner.fullName}, abre em nova aba',
      linkUrl: Uri.parse(_partner.url),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: SelectionContainer.disabled(
            child: InkWell(
              onTap: _open,
              onHover: (value) => setState(() => _hovered = value),
              onFocusChange: (value) => setState(() => _focused = value),
              borderRadius: radius,
              splashFactory: NoSplash.splashFactory,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              mouseCursor: SystemMouseCursors.click,
              child: _content(context, radius),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, BorderRadius radius) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final shadows = AppTheme.dimensions.shadows;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final logo = Image.asset(
      _partner.image.path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // A sigla fica fora do filtro cinza e transparente, que a deixaria sem contraste.
        if (!_failed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _failed = true);
          });
        }
        return Center(
          child: Text(
            _partner.acronym,
            textAlign: TextAlign.center,
            style: AppTheme.typography.of(context).small.copyWith(color: colors.inkSecondary),
          ),
        );
      },
    );

    // Tudo sai de um único valor animado para, em repouso, não pintar sombra transparente
    // nem abrir camadas de opacidade: são seis logos em páginas longas.
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: _active ? 1 : 0),
        duration: components.hoverAnimation,
        child: logo,
        builder: (context, t, logo) => Transform.translate(
          offset: Offset(0, reduceMotion ? 0 : -components.partnerHoverLift * t),
          child: Container(
            constraints: BoxConstraints(minHeight: components.minTapTarget),
            padding: EdgeInsets.all(
              ScreenUtils.breakpointOf(context) == Breakpoint.mobile
                  ? components.partnerPaddingMobile
                  : components.partnerPadding,
            ),
            decoration: t == 0
                ? null
                : BoxDecoration(
                    color: colors.page.withValues(alpha: t),
                    borderRadius: radius,
                    border: Border.all(
                      color: colors.line.withValues(alpha: colors.line.a * t),
                      width: AppTheme.dimensions.stroke.small,
                    ),
                    boxShadow: shadows.fade(shadows.soft, t),
                  ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: components.partnerLogoMaxWidth),
                child: AspectRatio(
                  aspectRatio: components.partnerLogoAspectRatio,
                  child: Transform.scale(
                    scale: reduceMotion ? 1 : lerpDouble(1, components.partnerHoverScale, t)!,
                    child: t == 1 || _failed
                        ? logo
                        : ColorFiltered(
                            colorFilter: ColorFilter.matrix(
                              _lerpMatrix(t, lerpDouble(components.partnerRestOpacity, 1, t)!),
                            ),
                            child: logo,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A opacidade entra na própria matriz (linha do alfa) para não abrir outra camada.
  List<double> _lerpMatrix(double t, double opacity) {
    return [
      for (var i = 0; i < _identity.length; i++)
        lerpDouble(_grayscale[i], _identity[i], t)! * (i == 18 ? opacity : 1),
    ];
  }
}
