import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final ThemeEnum type;
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final List<SubthemeModel> subthemes;

  const ThemeModel({
    required this.type,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.subthemes,
  });
}
