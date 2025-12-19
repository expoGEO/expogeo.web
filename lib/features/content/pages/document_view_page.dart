// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewPage extends StatelessWidget {
  final String documentUrl;
  final String? title;

  const DocumentViewPage({super.key, required this.documentUrl, this.title});

  static String route(String documentUrl, {String? title}) {
    final encodedUrl = Uri.encodeComponent(documentUrl);
    final encodedTitle = title != null ? Uri.encodeComponent(title) : null;
    if (encodedTitle != null) {
      return '/conteudo/documento?url=$encodedUrl&title=$encodedTitle';
    }
    return '/conteudo/documento?url=$encodedUrl';
  }

  bool _isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf') ||
        url.toLowerCase().contains('.pdf?') ||
        url.toLowerCase().contains('pdf');
  }

  @override
  Widget build(BuildContext context) {
    final decodedUrl = Uri.decodeComponent(documentUrl);
    final decodedTitle = title != null ? Uri.decodeComponent(title!) : null;
    final isPdf = _isPdf(decodedUrl);

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
                          // Documento
                          Container(
                            height: MediaQuery.of(context).size.height * 0.7,
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
                              child: isPdf
                                  ? _buildPdfViewer(decodedUrl)
                                  : _buildGenericDocumentViewer(decodedUrl),
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

  Widget _buildPdfViewer(String pdfUrl) {
    // Usa Syncfusion PDF Viewer para melhor experiência
    return SfPdfViewer.network(
      pdfUrl,
      enableDoubleTapZooming: true,
      enableTextSelection: true,
      canShowScrollHead: true,
      canShowScrollStatus: true,
    );
  }

  Widget _buildGenericDocumentViewer(String url) {
    // Para outros tipos de documento, tenta usar iframe direto
    final iframeId = 'doc-iframe-${url.hashCode}';

    final iframe = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';

    ui_web.platformViewRegistry.registerViewFactory(iframeId, (int viewId) {
      return iframe;
    });

    return HtmlElementView(viewType: iframeId);
  }
}
