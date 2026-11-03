import 'package:expogeo/core/models/content_model.dart';
import 'package:flutter/material.dart';

extension ContentTypeDisplay on ContentType {
  IconData get cardIcon => switch (this) {
    ContentType.site => Icons.language,
    ContentType.video => Icons.play_circle_outline,
    ContentType.documento => Icons.description_outlined,
    ContentType.aplicativo => Icons.apps_outlined,
    ContentType.imagem => Icons.image_outlined,
    ContentType.outro => Icons.link,
  };
}

/// "Tipo · Formato", sem o formato quando ele não acrescenta nada ("Outro" ou igual ao tipo).
String typeLine(ContentType type, ContentFormat format) {
  if (format == ContentFormat.outro || format.value == type.value) return type.value;
  return '${type.value} · ${format.value}';
}
