import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (kDebugMode) print('Could not launch $url');
      }
    } catch (_) {
      if (kDebugMode) print('Could not launch $url');
    }
  }
}
