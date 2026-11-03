import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _channel = MethodChannel('plugins.flutter.io/url_launcher');

/// Responde ao canal do `url_launcher` e guarda os endereços abertos.
List<String> fakeUrlLauncher() {
  final opened = <String>[];
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(_channel, (call) async {
    final url = (call.arguments as Map)['url'] as String;
    if (call.method == 'launch') opened.add(url);
    return true;
  });
  addTearDown(() => messenger.setMockMethodCallHandler(_channel, null));
  return opened;
}
