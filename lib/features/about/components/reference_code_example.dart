import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class ReferenceCodeExample extends StatelessWidget {
  const ReferenceCodeExample({super.key});

  static const List<(String, String, String)> parts = [
    ('RE', 'Tema geral', 'Representações Espaciais'),
    ('LM', 'Tema específico', 'Leitura de Mapas'),
    ('01', 'Número de referência', 'na curadoria'),
  ];

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.codeExampleGap;
    final blocks = [
      for (final (code, title, detail) in parts)
        _CodeBlock(code: code, title: title, detail: detail),
    ];

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Exemplo de código de referência',
      child: ScreenUtils.breakpointOf(context) == Breakpoint.mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < blocks.length; i++) ...[
                  if (i > 0) SizedBox(height: gap),
                  blocks[i],
                ],
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < blocks.length; i++) ...[
                    if (i > 0) SizedBox(width: gap),
                    Expanded(child: blocks[i]),
                  ],
                ],
              ),
            ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, required this.title, required this.detail});

  final String code;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(dimensions.radii.r12),
        border: Border.all(color: colors.line, width: dimensions.stroke.small),
      ),
      child: Padding(
        padding: components.codeExamplePadding,
        child: MergeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: styles.code.copyWith(
                  fontSize: components.codeExampleText,
                  color: colors.accentStrong,
                ),
              ),
              SizedBox(height: components.codeExampleCaptionGap),
              Text('$title\n$detail', style: styles.small.copyWith(color: colors.inkSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
