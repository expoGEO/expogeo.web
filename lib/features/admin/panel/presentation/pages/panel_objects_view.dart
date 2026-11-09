import 'package:expogeo/features/admin/admin_setup.dart';
import 'package:expogeo/features/admin/panel/presentation/components/legacy_objects_area.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_view_scroll.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter/material.dart';

class PanelObjectsView extends StatefulWidget {
  const PanelObjectsView({required this.selection, super.key});

  final PanelSelection selection;

  @override
  State<PanelObjectsView> createState() => _PanelObjectsViewState();
}

class _PanelObjectsViewState extends State<PanelObjectsView> {
  late final _contentStore = AdminSetup.getIt<ContentStore>();

  @override
  void initState() {
    super.initState();
    _select();
  }

  @override
  void didUpdateWidget(covariant PanelObjectsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selection != widget.selection) _select();
  }

  void _select() => _contentStore.selectFromAddress(
    theme: widget.selection.theme,
    subtheme: widget.selection.subtheme,
  );

  @override
  Widget build(BuildContext context) {
    return PanelViewScroll(
      children: [
        PanelSectionHeader(title: widget.selection.theme?.name ?? 'Objetos digitais'),
        LegacyObjectsArea(contentStore: _contentStore),
      ],
    );
  }
}
