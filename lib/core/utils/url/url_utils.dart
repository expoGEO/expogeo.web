import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
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
