part of '../app_theme.dart';

class AppTextStyles {
  const AppTextStyles._(this.breakpoint);

  factory AppTextStyles.forWidth(double width) {
    return AppTextStyles._(Breakpoint.fromWidth(width));
  }

  final Breakpoint breakpoint;

  static const String _displayFamily = 'BricolageGrotesque';
  static const String _bodyFamily = 'Figtree';

  static const List<String> _fallback = ['system-ui', 'Roboto', 'Arial'];

  double _size({required double mobile, required double tablet, required double desktop}) {
    return switch (breakpoint) {
      Breakpoint.mobile => mobile,
      Breakpoint.tablet => tablet,
      Breakpoint.desktop => desktop,
    };
  }

  TextStyle _display({
    required double size,
    required FontWeight weight,
    required double height,
    required double letterSpacingEm,
  }) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * letterSpacingEm,
    );
  }

  TextStyle _body({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacingEm = 0,
    List<FontFeature>? fontFeatures,
  }) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * letterSpacingEm,
      fontFeatures: fontFeatures,
    );
  }

  TextStyle get h1 => _display(
    size: _size(mobile: 32, tablet: 40, desktop: 52),
    weight: FontWeight.w800,
    height: 1.12,
    letterSpacingEm: -0.03,
  );

  TextStyle get h2 => _display(
    size: _size(mobile: 26, tablet: 30, desktop: 36),
    weight: FontWeight.w700,
    height: 1.12,
    letterSpacingEm: -0.02,
  );

  TextStyle get h3 => _display(
    size: _size(mobile: 18, tablet: 20, desktop: 20),
    weight: FontWeight.w700,
    height: 1.2,
    letterSpacingEm: -0.01,
  );

  TextStyle get reading => _body(
    size: _size(mobile: 17, tablet: 18, desktop: 18),
    weight: FontWeight.w400,
    height: 1.75,
  );

  TextStyle get regular => _body(
    size: _size(mobile: 16, tablet: 16, desktop: 16),
    weight: FontWeight.w400,
    height: 1.55,
  );

  TextStyle get small =>
      _body(size: _size(mobile: 14, tablet: 14, desktop: 14), weight: FontWeight.w400, height: 1.5);

  TextStyle get label => _body(
    size: _size(mobile: 12.5, tablet: 12.5, desktop: 13),
    weight: FontWeight.w700,
    height: 1.4,
    letterSpacingEm: 0.08,
  );

  TextStyle get chip =>
      _body(size: _size(mobile: 14, tablet: 14, desktop: 14), weight: FontWeight.w600, height: 1.2);

  TextStyle get formLabel =>
      _body(size: _size(mobile: 15, tablet: 15, desktop: 15), weight: FontWeight.w600, height: 1.4);

  TextStyle get formError => _body(
    size: _size(mobile: 14, tablet: 14, desktop: 14),
    weight: FontWeight.w500,
    height: 1.45,
  );

  TextStyle get confirmationTitle => _display(
    size: _size(mobile: 22.4, tablet: 25.6, desktop: 25.6),
    weight: FontWeight.w700,
    height: 1.12,
    letterSpacingEm: -0.02,
  );

  TextStyle get loginBrandTitle => _display(
    size: _size(mobile: 25.6, tablet: 25.6, desktop: 44.8),
    weight: FontWeight.w800,
    height: 1.12,
    letterSpacingEm: -0.03,
  );

  TextStyle get loginCardTitle => _display(
    size: _size(mobile: 28, tablet: 28, desktop: 28),
    weight: FontWeight.w700,
    height: 1.12,
    letterSpacingEm: -0.02,
  );

  TextStyle get loginLead => _body(
    size: _size(mobile: 15, tablet: 15, desktop: 15),
    weight: FontWeight.w400,
    height: 1.55,
  );

  TextStyle get toast => _body(
    size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
    weight: FontWeight.w600,
    height: 1.4,
  );

  TextStyle get tooltip => _body(
    size: _size(mobile: 13, tablet: 13, desktop: 13),
    weight: FontWeight.w600,
    height: 1.35,
  );

  TextStyle get panelDialogTitle => _display(
    size: _size(mobile: 20.8, tablet: 20.8, desktop: 20.8),
    weight: FontWeight.w700,
    height: 1.2,
    letterSpacingEm: -0.02,
  );

  /// Número grande no lugar do ícone da caixa de estado, como o "404".
  TextStyle get stateCode => _display(
    size: _size(mobile: 64, tablet: 88, desktop: 112),
    weight: FontWeight.w800,
    height: 1,
    letterSpacingEm: -0.04,
  );

  /// Código de referência (ex.: NMA_BH_03). O Flutter web não alcança fontes do sistema,
  /// então uma monoespaçada cairia numa proporcional; algarismos tabulares mantêm o alinhamento.
  TextStyle get code => _body(
    size: _size(mobile: 13.5, tablet: 13.5, desktop: 13.5),
    weight: FontWeight.w600,
    height: 1.4,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
