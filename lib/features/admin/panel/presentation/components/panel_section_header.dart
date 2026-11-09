import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';

class PanelSectionHeader extends StatefulWidget {
  const PanelSectionHeader({
    required this.title,
    this.eyebrow = 'Curadoria',
    this.summary,
    this.announceSummary = false,
    this.action,
    this.focusTitleOnChange = true,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? summary;

  /// O leitor de tela lê o resumo quando ele muda (por exemplo, a contagem depois de um filtro).
  final bool announceSummary;

  /// À direita do título; no celular, abaixo dele e em largura total.
  final Widget? action;

  /// Falso quando o título muda por um campo que deve manter o foco.
  final bool focusTitleOnChange;

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
    if (oldWidget.title != widget.title && widget.focusTitleOnChange) _focusTitle();
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

    final texts = Column(
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
          Semantics(
            liveRegion: widget.announceSummary,
            child: Text(summary, style: styles.panelSummary.copyWith(color: colors.inkSecondary)),
          ),
        ],
      ],
    );

    final action = widget.action;
    final Widget content;
    if (action == null) {
      content = texts;
    } else if (ScreenUtils.breakpointOf(context) == Breakpoint.mobile) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          texts,
          SizedBox(height: components.panelHeadActionGap),
          action,
        ],
      );
    } else {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: texts),
          SizedBox(width: components.panelHeadActionGap),
          action,
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: components.panelHeadMarginBottom),
      child: content,
    );
  }
}
