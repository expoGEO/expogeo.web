import "package:expogeo/core/utils/enums/app_images.dart";
import "package:flutter/material.dart";

class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  final AppImages image;

  final double? width;
  final double? height;

  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(image.path, width: width, height: height, fit: fit);
  }
}
