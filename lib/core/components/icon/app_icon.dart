import "package:expogeo/core/utils/enums/app_icons.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:expogeo/core/utils/extensions/num_extension.dart";

class AppIcon extends StatelessWidget {
  const AppIcon({required this.icon, this.color, this.size, super.key});

  final AppIcons icon;
  final Color? color;

  final double? size;

  @override
  Widget build(BuildContext context) {
    final size = this.size?.scale;

    return SvgPicture.asset(
      icon.path,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
