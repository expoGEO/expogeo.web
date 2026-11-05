import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  /// Só `http` e `https` com host. O teste de espaço existe porque o `Uri` aceita host com espaço.
  static bool isOpenable(String url) {
    final text = url.trim();
    if (text.contains(RegExp(r'\s'))) return false;
    final uri = Uri.tryParse(text);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https')) && uri.host.isNotEmpty;
  }

  /// O domínio sem `www.`; endereço que não abre volta como veio.
  static String displayDomain(String url) {
    final text = url.trim();
    if (!isOpenable(text)) return text;
    final host = Uri.parse(text).host;
    return host.startsWith('www.') ? host.substring(4) : host;
  }

  /// `mailto:` usa [sameTab] para não deixar uma aba em branco.
  static Future<void> openUrl(String url, {bool sameTab = false}) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, webOnlyWindowName: sameTab ? '_self' : null);
      } else {
        if (kDebugMode) print('Could not launch $url');
      }
    } catch (_) {
      if (kDebugMode) print('Could not launch $url');
    }
  }
}
