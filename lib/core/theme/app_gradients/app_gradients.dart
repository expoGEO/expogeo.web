part of '../app_theme.dart';

class AppGradients {
  AppGradients._();
  static AppGradients get instance => AppGradients._();

  // Gradiente principal da home (laranja/amarelo)
  LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF97316), // primaryOrange
      Color(0xFFFB923C), // secondaryOrange
      Color(0xFFFDE047), // primaryYellow
    ],
  );

  // Gradiente para cards
  LinearGradient cardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF97316), // primaryOrange
      Color(0xFFEA580C), // darkOrange
    ],
  );

  // Gradiente azul para páginas de temas
  LinearGradient blueGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E40AF), // primaryBlue
      Color(0xFF3B82F6), // secondaryBlue
    ],
  );

  // Gradiente verde para temas ambientais
  LinearGradient greenGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF16A34A), // primaryGreen
      Color(0xFF22C55E), // secondaryGreen
    ],
  );

  // Gradiente vermelho para representações
  LinearGradient redGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDC2626), // primaryRed
      Color(0xFFEF4444), // secondaryRed
    ],
  );

  // Gradiente cinza para elementos neutros
  LinearGradient grayGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF374151), // darkGray
      Color(0xFF6B7280), // mediumGray
    ],
  );

  /// Assinatura da expoGEO, só decorativa: nunca sob texto nem em botões.
  /// A rotação de 30° sobre o eixo horizontal reproduz o ângulo de 120° do CSS.
  LinearGradient brand = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0, 0.45, 1],
    transform: GradientRotation(math.pi / 6),
    colors: [Color(0xFFF97316), Color(0xFFFB923C), Color(0xFFFACC15)],
  );
}
