part of '../app_theme.dart';

class AppGradients {
  AppGradients._();
  static AppGradients get instance => AppGradients._();

  /// Assinatura da expoGEO, só decorativa: nunca sob texto nem em botões.
  /// A rotação de 30° sobre o eixo horizontal dá a inclinação de 120° (medida do topo, no sentido horário).
  LinearGradient brand = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0, 0.45, 1],
    transform: GradientRotation(math.pi / 6),
    colors: [Color(0xFFF97316), Color(0xFFFB923C), Color(0xFFFACC15)],
  );
}
