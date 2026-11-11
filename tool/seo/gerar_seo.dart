// Gera as páginas para o Google a partir do build. Roda depois de `flutter build web`:
//
//   flutter test tool/seo/gerar_seo.dart --dart-define=APP_ENV=prod
//
// Os modelos do app importam o Flutter, por isso o ponto de entrada é um teste: é o jeito de
// executar este código sem compilá-lo como app. Fica fora de `test/` para a suíte não rodá-lo.
import 'dart:io';

import 'package:expogeo/core/utils/browser/page_meta_data.dart';
import 'package:expogeo/core/utils/environment/app_environment.dart';
import 'package:expogeo/firebase_options_dev.dart' as dev_options;
import 'package:expogeo/firebase_options_prod.dart' as prod_options;
import 'package:flutter_test/flutter_test.dart';

import 'firestore_reader.dart';
import 'site_pages.dart';
import 'site_writer.dart';

const String _devOrigin = 'https://dev.expogeo.com.br';

void main() {
  test('gera as páginas para o Google', () async {
    HttpOverrides.global = null;

    final isProd = AppEnvironment.current.isProd;
    final options = isProd
        ? prod_options.DefaultFirebaseOptions.web
        : dev_options.DefaultFirebaseOptions.web;
    final buildDir = Directory('build/web');
    final index = File('${buildDir.path}/index.html');
    if (!index.existsSync()) {
      throw const SeoException('Não achei build/web/index.html: rode `flutter build web` antes.');
    }

    final catalog = await FirestoreReader(
      projectId: options.projectId,
      apiKey: options.apiKey,
    ).fetchCatalog();
    final result = writeSite(
      pages: buildSitePages(catalog),
      template: index.readAsStringSync(),
      outDir: buildDir,
      origin: isProd ? siteOrigin : _devOrigin,
      noIndex: !isProd,
      withSitemap: isProd,
    );

    // ignore: avoid_print
    print(
      'Páginas para o Google (${options.projectId}): ${result.pages} no total, '
      '${result.objects} de objetos${result.sitemap ? ', com sitemap.xml' : ', sem sitemap.xml'}.',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}
