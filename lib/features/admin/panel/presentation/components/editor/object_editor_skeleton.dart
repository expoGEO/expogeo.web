import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_card.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_layout.dart';
import 'package:flutter/material.dart';

/// Cartões e lateral enquanto o catálogo não chega.
class ObjectEditorSkeleton extends StatelessWidget {
  const ObjectEditorSkeleton({required this.controller, super.key});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    Widget block(double height) => AppSkeleton(width: double.infinity, height: height);
    Widget field() => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: components.panelSkeletonMetaWidth,
          child: block(components.editorSkeletonLineHeight),
        ),
        SizedBox(height: components.formFieldLabelGap),
        block(components.editorSkeletonFieldHeight),
      ],
    );
    Widget card(int fields) => ObjectEditorCard(
      children: [
        FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: components.panelSkeletonMetaWidth,
          child: block(components.editorSkeletonLineHeight),
        ),
        for (var i = 0; i < fields; i++) field(),
      ],
    );

    return Semantics(
      label: 'Carregando o editor',
      child: ExcludeSemantics(
        child: ObjectEditorLayout(
          controller: controller,
          where: card(2),
          cards: [card(3), card(2), card(2)],
          preview: ObjectEditorCard(children: [block(components.editorSkeletonSideHeight)]),
        ),
      ),
    );
  }
}
