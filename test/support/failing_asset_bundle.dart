import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Pacote de assets que falha nas imagens WebP (ilustrações e logos), para conferir os substitutos.
class FailingImageBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.webp')) throw FlutterError('Imagem indisponível: $key');
    return rootBundle.load(key);
  }
}
