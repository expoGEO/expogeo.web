import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PanelSectionHeader extends StatefulWidget {
  const PanelSectionHeader({
    required this.title,
    this.eyebrow = 'Curadoria',
    this.summary,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? summary;

  @override
  State<PanelSectionHeader> createState() => _PanelSectionHeaderState();
}

class _PanelSectionHeaderState extends State<PanelSectionHeader> {
  final _titleFocus = FocusNode(skipTraversal: true);

  @override
  void initState() {
    super.initState();
    _focusTitle();
  }

  // Trocar de vista ou de tema leva o foco ao título, para o leitor de tela dizer onde se está.
  @override
  void didUpdateWidget(covariant PanelSectionHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) _focusTitle();
  }

  void _focusTitle() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final summary = widget.summary;

    return Padding(
      padding: EdgeInsets.only(bottom: components.panelHeadMarginBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.eyebrow.toUpperCase(),
            semanticsLabel: widget.eyebrow,
            style: styles.label.copyWith(color: colors.accentStrong),
          ),
          SizedBox(height: components.panelHeadTitleGap),
          Focus(
            focusNode: _titleFocus,
            child: Semantics(
              header: true,
              headingLevel: 1,
              child: Text(widget.title, style: styles.panelTitle.copyWith(color: colors.ink)),
            ),
          ),
          if (summary != null) ...[
            SizedBox(height: components.panelHeadSummaryGap),
            Text(summary, style: styles.panelSummary.copyWith(color: colors.inkSecondary)),
          ],
        ],
      ),
    );
  }
}
