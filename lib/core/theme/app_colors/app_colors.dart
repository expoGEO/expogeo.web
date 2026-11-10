part of '../app_theme.dart';

class AppColors {
  AppColors._();
  static AppColors get instance => AppColors._();

  Color white = const Color(0xFFFFFFFF);
  Color black = const Color(0xFF000000);

  Color page = const Color(0xFFFFFFFF);
  Color surface = const Color(0xFFF7F5F2);
  Color ink = const Color(0xFF1F1B18);
  Color inkSecondary = const Color(0xFF5E5852);
  Color line = const Color(0xFFE6E1DA);

  /// Contorno de seletor no hover e com o menu aberto.
  Color lineStrong = const Color(0xFFCFC8BE);

  /// Contorno de campo de formulário, que não tem outro limite visível: 3,8:1 sobre [page].
  Color fieldBorder = const Color(0xFF8A8178);

  /// Cor de tudo que é clicável.
  Color accent = const Color(0xFFC94400);
  Color textSelection = const Color(0x40C94400);

  /// Hover, e texto ou ícone laranja sobre [surface] e [accentSoft],
  /// onde [accent] fica abaixo de 4,5:1.
  Color accentStrong = const Color(0xFFA33600);
  Color accentSoft = const Color(0xFFFFF0E6);

  Color footerBackground = const Color(0xFF1C1917);
  Color footerLine = const Color(0xFF37322E);
  Color footerText = const Color(0xFFD8D2CA);
  Color footerHighlight = const Color(0xFFFF9A62);
  Color footerMuted = const Color(0xFFB9B1A7);
  Color footerSubtle = const Color(0xFFA39A8F);

  Color skeletonBase = const Color(0xFFEEEAE4);
  Color skeletonHighlight = const Color(0xFFF8F6F3);

  /// Anel tracejado interno do anel dos temas, só decorativo.
  Color orbitDashed = const Color(0xFFD6CABB);

  /// Tracejado da caixa de estado, só decorativo.
  Color stateBoxBorder = const Color(0xFFD4CDC3);

  /// Fundo escurecido atrás da gaveta e dos diálogos do painel.
  Color scrim = const Color(0x731C1917);

  /// Fundo da linha de lista no hover.
  Color rowHover = const Color(0xFFFCFBF9);

  /// Ícone do aviso curto sobre [ink].
  Color toastIcon = const Color(0xFF9FD8AE);

  /// Faixa de aviso do ambiente de testes.
  Color environmentBanner = const Color(0xFFFDE047);

  Color error = const Color(0xFFB3261E);

  /// Hover do botão de perigo.
  Color errorStrong = const Color(0xFF8F1D17);
  Color errorSurface = const Color(0xFFFBE9E7);
  Color success = const Color(0xFF1C6B34);
  Color successSurface = const Color(0xFFE4F3E8);
}
