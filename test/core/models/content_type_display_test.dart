import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cada tipo tem o seu ícone', () {
    expect(ContentType.site.cardIcon, Icons.language);
    expect(ContentType.video.cardIcon, Icons.play_circle_outline);
    expect(ContentType.documento.cardIcon, Icons.description_outlined);
    expect(ContentType.aplicativo.cardIcon, Icons.apps_outlined);
    expect(ContentType.imagem.cardIcon, Icons.image_outlined);
    expect(ContentType.outro.cardIcon, Icons.link);
  });

  test('junta tipo e formato', () {
    expect(typeLine(ContentType.site, ContentFormat.html), 'Site · HTML');
    expect(typeLine(ContentType.documento, ContentFormat.pdf), 'Documento · PDF');
    expect(typeLine(ContentType.aplicativo, ContentFormat.texto), 'Aplicativo · Texto');
    expect(typeLine(ContentType.outro, ContentFormat.audio), 'Outro · Áudio');
  });

  test('omite o formato igual ao tipo', () {
    expect(typeLine(ContentType.video, ContentFormat.video), 'Vídeo');
    expect(typeLine(ContentType.imagem, ContentFormat.imagem), 'Imagem');
  });

  test('omite o formato "Outro"', () {
    expect(typeLine(ContentType.site, ContentFormat.outro), 'Site');
    expect(typeLine(ContentType.outro, ContentFormat.outro), 'Outro');
  });
}
