import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/structure/footer.dart';
import '../components/structure/navbar.dart';
import '../theme/app_theme.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradients.blueGradient),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
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
                      ElevatedButton(
                        onPressed: () => context.go('/'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.primaryOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.home),
                            const SizedBox(width: 8),
                            Text(
                              'Voltar ao início',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
