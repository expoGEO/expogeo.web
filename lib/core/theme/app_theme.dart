library;

import 'dart:math' as math;

import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'app_colors/app_colors.dart';
part 'app_dimensions/app_dimensions.dart';
part 'app_gradients/app_gradients.dart';
part 'app_typography/app_typography.dart';

class AppTheme {
  const AppTheme._();

  static AppColors get colors => AppColors.instance;
  static AppDimensions get dimensions => AppDimensions.instance;
  static AppTypography get typography => AppTypography.instance;
  static AppGradients get gradients => AppGradients.instance;
}
