import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

class AppMedallion extends StatelessWidget {
  const AppMedallion({super.key, required this.size, this.image, this.semanticLabel});

  final double size;
  final AppImages? image;

  /// Sem rótulo, o medalhão é decorativo e fica fora da árvore de acessibilidade.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final image = this.image;

    final Widget content = image == null
        ? const _Placeholder()
        : Image.asset(
            image.path,
            fit: BoxFit.contain,
            width: size,
            height: size,
            errorBuilder: (context, error, stackTrace) => const _Placeholder(),
          );

    final medallion = SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.page,
          shape: BoxShape.circle,
          border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
        child: ClipOval(child: content),
      ),
    );

    final label = semanticLabel;
    if (label == null) return ExcludeSemantics(child: medallion);
    return Semantics(
      image: true,
      label: label,
      child: ExcludeSemantics(child: medallion),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.colors.accentSoft,
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Icon(
            Icons.map_outlined,
            size: constraints.biggest.shortestSide / 2,
            color: AppTheme.colors.accentStrong,
          ),
        ),
      ),
    );
  }
}
