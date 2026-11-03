import 'dart:io';

import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const pngImages = {AppImages.logo, AppImages.logoSimple, AppImages.observatorio};

  group('AppImages.path', () {
    for (final image in AppImages.values) {
      test('${image.name} aponta para um arquivo que existe', () {
        expect(File(image.path).existsSync(), isTrue, reason: image.path);
      });

      test('${image.name} tem caminho sem acento nem maiúscula', () {
        expect(image.path, matches(RegExp(r'^[a-z0-9_./]+$')));
      });
    }

    test('ilustrações e logos de apoio usam WebP; marca e Observatório, PNG; símbolo, SVG', () {
      for (final image in AppImages.values) {
        final extension = switch (image) {
          AppImages.observatorioSimbolo => '.svg',
          _ when pngImages.contains(image) => '.png',
          _ => '.webp',
        };
        expect(image.path, endsWith(extension), reason: image.name);
      }
    });
  });
}
