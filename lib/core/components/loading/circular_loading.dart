import "package:expogeo/core/theme/app_theme.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";
import "package:flutter/material.dart";

class CircularLoading extends StatelessWidget {
  const CircularLoading({this.color, this.size, super.key});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 24.scale,
        height: size ?? 24.scale,
        child: CircularProgressIndicator(color: color ?? AppTheme.colors.gray900),
      ),
    );
  }
}
