import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

class SubthemeModel {
  final SubthemeEnum type;
  final String title;
  final String description;
  final AppImages image;
  final Color color;
  final List<ContentModel> contents;

  const SubthemeModel({
    required this.type,
    required this.title,
    required this.description,
    required this.image,
    required this.color,
    this.contents = const [],
  });
}
