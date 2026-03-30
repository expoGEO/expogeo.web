import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Messenger {
  static showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.colors.primaryRed));
  }

  static showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.colors.primaryGreen));
  }

  static showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.colors.primaryBlue));
  }
}
