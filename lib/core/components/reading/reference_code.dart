import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Código de referência em destaque (ex.: NMA_BH_03).
class ReferenceCode extends StatelessWidget {
  const ReferenceCode(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(dimensions.radii.r6),
        border: Border.all(color: colors.line, width: dimensions.stroke.small),
      ),
      child: Padding(
        padding: dimensions.components.referenceCodePadding,
        child: Text(code, style: AppTheme.typography.of(context).code.copyWith(color: colors.ink)),
      ),
    );
  }
}
