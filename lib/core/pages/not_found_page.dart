import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(gradient: AppTheme.gradients.blueGradient),
            padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.spacing.s64),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.primaryRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.error_outline, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Página não encontrada',
                      textAlign: TextAlign.center,
                      style: AppTheme.typography.headline.small.copyWith(
                        color: AppTheme.colors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A página que você está procurando não existe ou foi movida.',
                      textAlign: TextAlign.center,
                      style: AppTheme.typography.body.medium.copyWith(
                        color: AppTheme.colors.mediumGray,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton.primary(
                      text: 'Voltar ao início',
                      leadingIcon: Icons.home,
                      onPressed: () => context.go(AppRouter.home),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
