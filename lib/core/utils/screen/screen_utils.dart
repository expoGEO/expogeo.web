import 'package:flutter/material.dart';

class ScreenUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isSmallMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isLaptop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024 && MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static bool isSmallDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  }
}
