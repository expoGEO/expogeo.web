import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/environment/app_environment.dart';
import 'package:flutter/material.dart';

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppEnvironment.current.isProd) return const SizedBox.shrink();

    // A faixa fica fora das páginas, sem Material acima; sem ele o texto herda o sublinhado de erro.
    return Material(
      color: AppTheme.colors.primaryYellow,
      child: SizedBox(
        height: AppTheme.dimensions.environmentBannerHeight,
        child: Center(
          child: Text(
            'Ambiente de testes',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.typography.label.medium.copyWith(color: AppTheme.colors.gray900),
          ),
        ),
      ),
    );
  }
}
