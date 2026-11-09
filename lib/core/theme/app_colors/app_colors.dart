part of '../app_theme.dart';

class AppColors {
  AppColors._();
  static AppColors get instance => AppColors._();

  // Cores principais baseadas no design original do ExpoGEO
  Color primaryOrange = const Color(0xFFF97316); // orange-500
  Color secondaryOrange = const Color(0xFFFB923C); // orange-400
  Color lightOrange = const Color(0xFFFED7AA); // orange-200
  Color darkOrange = const Color(0xFFEA580C); // orange-600

  Color primaryYellow = const Color(0xFFFDE047); // yellow-300
  Color secondaryYellow = const Color(0xFFFACC15); // yellow-400

  Color primaryBlue = const Color(0xFF1E40AF); // blue-800
  Color secondaryBlue = const Color(0xFF3B82F6); // blue-500
  Color lightBlue = const Color(0xFF93C5FD); // blue-300

  Color primaryGreen = const Color(0xFF16A34A); // green-600
  Color secondaryGreen = const Color(0xFF22C55E); // green-500

  Color primaryRed = const Color(0xFFDC2626); // red-600
  Color secondaryRed = const Color(0xFFEF4444); // red-500

  Color darkGray = const Color(0xFF374151); // gray-700
  Color mediumGray = const Color(0xFF6B7280); // gray-500
  Color lightGray = const Color(0xFFF3F4F6); // gray-100

  Color white = const Color(0xFFFFFFFF);
  Color black = const Color(0xFF000000);

  // Neutral colors
  Color get gray900 => Color(0xFF18181B);
  Color get gray800 => Color(0xFF27272A);
  Color get gray700 => Color(0xFF3F3F46);
  Color get gray600 => Color(0xFF52525B);
  Color get gray500 => Color(0xFF71717A);
  Color get gray400 => Color(0xFFa1a1aa);
  Color get gray300 => Color(0xFFd4d4d8);
  Color get gray200 => Color(0xFFE4E4E7);
  Color get gray100 => Color(0xFFEFEFF4);
  Color get gray50 => Color(0xFFFAFCFE);

  Color page = const Color(0xFFFFFFFF);
  Color surface = const Color(0xFFF7F5F2);
  Color ink = const Color(0xFF1F1B18);
  Color inkSecondary = const Color(0xFF5E5852);
  Color line = const Color(0xFFE6E1DA);

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

  Color error = const Color(0xFFB3261E);

  /// Hover do botão de perigo.
  Color errorStrong = const Color(0xFF8F1D17);
  Color errorSurface = const Color(0xFFFBE9E7);
  Color success = const Color(0xFF1C6B34);
  Color successSurface = const Color(0xFFE4F3E8);
}
