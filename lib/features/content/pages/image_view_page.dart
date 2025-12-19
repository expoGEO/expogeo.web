// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageViewPage extends StatelessWidget {
  final String imageUrl;
  final String? title;

  const ImageViewPage({super.key, required this.imageUrl, this.title});

  static String route(String imageUrl, {String? title}) {
    final encodedUrl = Uri.encodeComponent(imageUrl);
    final encodedTitle = title != null ? Uri.encodeComponent(title) : null;
    if (encodedTitle != null) {
      return '/conteudo/imagem?url=$encodedUrl&title=$encodedTitle';
    }
    return '/conteudo/imagem?url=$encodedUrl';
  }

  @override
  Widget build(BuildContext context) {
    final decodedUrl = Uri.decodeComponent(imageUrl);
    final decodedTitle = title != null ? Uri.decodeComponent(title!) : null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppTheme.colors.white),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1200.scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Botão de voltar
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.pop(),
                              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
                              child: Padding(
                                padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 16.scale,
                                      color: AppTheme.colors.mediumGray,
                                    ),
                                    SizedBox(width: AppTheme.dimensions.space.small.width),
                                    Text(
                                      'Voltar',
                                      style: AppTheme.typography.body.medium.copyWith(
                                        color: AppTheme.colors.mediumGray,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppTheme.dimensions.space.large.height),
                          // Título
                          if (decodedTitle != null) ...[
                            Text(
                              decodedTitle,
                              style: AppTheme.typography.title.big.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colors.darkGray,
                              ),
                            ),
                            SizedBox(height: AppTheme.dimensions.space.large.height),
                          ],
                          // Imagem
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppTheme.dimensions.radius.medium,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppTheme.dimensions.radius.medium,
                              ),
                              child: Image.network(
                                decodedUrl,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 400.scale,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 400.scale,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 48.scale,
                                          color: AppTheme.colors.mediumGray,
                                        ),
                                        SizedBox(height: AppTheme.dimensions.space.medium.height),
                                        Text(
                                          'Erro ao carregar imagem',
                                          style: AppTheme.typography.body.medium.copyWith(
                                            color: AppTheme.colors.mediumGray,
                                          ),
                                        ),
                                        SizedBox(height: AppTheme.dimensions.space.small.height),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              html.window.open(decodedUrl, '_blank');
                                            },
                                            borderRadius: BorderRadius.circular(
                                              AppTheme.dimensions.radius.small,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: AppTheme.dimensions.space.medium.width,
                                                vertical: AppTheme.dimensions.space.small.height,
                                              ),
                                              child: Text(
                                                'Abrir em nova aba',
                                                style: AppTheme.typography.body.medium.copyWith(
                                                  color: AppTheme.colors.primaryBlue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
