part of '../app_theme.dart';

class AppTypography {
  const AppTypography._();

  /// The singleton instance of the [AppTypography] class.
  static const AppTypography instance = AppTypography._();

  /// Estilos com tamanho fixo por faixa de largura, sem escalar com a tela.
  AppTextStyles of(BuildContext context) {
    return AppTextStyles.forWidth(MediaQuery.sizeOf(context).width);
  }
}
