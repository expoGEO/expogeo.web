import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Pacote de assets que falha nas ilustrações, para conferir o placeholder do medalhão.
class FailingImageBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.webp')) throw FlutterError('Ilustração indisponível: $key');
    return rootBundle.load(key);
  }
}
