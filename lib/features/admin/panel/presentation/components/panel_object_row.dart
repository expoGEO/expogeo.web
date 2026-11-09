import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/reading/reference_code.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/date/date.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter/material.dart';

/// Linha de um objeto na lista do painel; no celular vira cartão, com as ações numa faixa
/// embaixo.
class PanelObjectRow extends StatefulWidget {
  const PanelObjectRow({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    this.titleFocusNode,
    this.deleteFocusNode,
    super.key,
  });

  final CatalogItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final FocusNode? titleFocusNode;
  final FocusNode? deleteFocusNode;

  @override
  State<PanelObjectRow> createState() => _PanelObjectRowState();
}

class _PanelObjectRowState extends State<PanelObjectRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final item = widget.item;
    final content = item.content;
    final title = content.contentInfo.title;
    final type = content.originInfo.type;
    final location = content.registrationInfo.location;
    final metaStyle = styles.panelMeta.copyWith(color: colors.inkSecondary);

    final medallion = AppMedallion(
      size: components.panelSubthemeMedallion,
      image: item.subtheme.illustration,
    );

    Widget separator() => ExcludeSemantics(child: Text('·', style: metaStyle));

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TitleLink(title: title, focusNode: widget.titleFocusNode, onPressed: widget.onEdit),
        SizedBox(height: components.panelRowMetaGap),
        Wrap(
          spacing: components.panelMetaGap,
          runSpacing: components.panelRowMetaGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Semantics(
              label: 'Código ${content.id}',
              excludeSemantics: true,
              child: ReferenceCode(content.id),
            ),
            separator(),
            Text(item.subtheme.name, style: metaStyle),
            separator(),
            Text(content.intellectualIndicator.creator, style: metaStyle),
            separator(),
            Text('inserido em ${content.originInfo.insertionDate.shortDate}', style: metaStyle),
          ],
        ),
      ],
    );

    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Padding(
        padding: components.panelBadgePadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.cardIcon, size: components.panelTypeBadgeIcon, color: colors.inkSecondary),
            SizedBox(width: components.panelTypeBadgeGap),
            Text(
              type.value,
              maxLines: 1,
              style: styles.panelBadge.copyWith(color: colors.inkSecondary),
            ),
          ],
        ),
      ),
    );

    final canOpen = UrlUtils.isOpenable(location);
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: Icons.open_in_new,
          color: colors.inkSecondary,
          size: components.panelActionIcon,
          label: 'Abrir o recurso de “$title”',
          tooltip: canOpen
              ? 'Abrir o recurso numa aba nova'
              : 'Este objeto não tem endereço válido',
          isDisabled: !canOpen,
          onPressed: () => UrlUtils.openUrl(location.trim()),
        ),
        SizedBox(width: components.panelRowActionsGap),
        AppIconButton(
          icon: Icons.edit_outlined,
          color: colors.inkSecondary,
          size: components.panelActionIcon,
          label: 'Editar “$title”',
          tooltip: 'Editar a ficha deste objeto',
          onPressed: widget.onEdit,
        ),
        SizedBox(width: components.panelRowActionsGap),
        AppIconButton(
          icon: Icons.delete_outline,
          color: colors.error,
          size: components.panelActionIcon,
          label: 'Excluir “$title”',
          tooltip: 'Excluir: pede confirmação antes de apagar',
          focusNode: widget.deleteFocusNode,
          onPressed: widget.onDelete,
        ),
      ],
    );

    final Widget body;
    if (isMobile) {
      body = Padding(
        padding: EdgeInsets.all(components.panelRowPaddingMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                medallion,
                SizedBox(width: components.panelRowGapMobileH),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      texts,
                      SizedBox(height: components.panelRowGapMobileV),
                      badge,
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: components.panelRowGapMobileV),
            CustomPaint(
              painter: _DashedTopLine(color: colors.line),
              child: Padding(
                padding: EdgeInsets.only(top: components.panelRowActionsTop),
                child: Align(alignment: AlignmentDirectional.centerEnd, child: actions),
              ),
            ),
          ],
        ),
      );
    } else {
      body = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.panelRowPaddingH,
          vertical: components.panelRowPaddingV,
        ),
        child: Row(
          children: [
            medallion,
            SizedBox(width: components.panelRowGap),
            Expanded(child: texts),
            SizedBox(width: components.panelRowGap),
            badge,
            SizedBox(width: components.panelRowGap),
            actions,
          ],
        ),
      );
    }

    // O título vira o nome do grupo, para o leitor de tela dizer de qual objeto são as ações.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: title,
      child: FocusTraversalGroup(
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: ColoredBox(color: _hovered ? colors.rowHover : Colors.transparent, child: body),
        ),
      ),
    );
  }
}

class _TitleLink extends StatefulWidget {
  const _TitleLink({required this.title, required this.onPressed, this.focusNode});

  final String title;
  final VoidCallback onPressed;
  final FocusNode? focusNode;

  @override
  State<_TitleLink> createState() => _TitleLinkState();
}

class _TitleLinkState extends State<_TitleLink> {
  bool _hovered = false;
  FocusNode? _ownFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    final color = _hovered ? colors.accent : colors.ink;

    return Semantics(
      link: true,
      label: widget.title,
      onTap: widget.onPressed,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: true,
      focused: _focusNode.hasFocus,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          focusNode: _focusNode,
          onTap: widget.onPressed,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (_) => setState(() {}),
          borderRadius: radius,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Text(
            widget.title,
            maxLines: components.panelRowTitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: styles.panelRowTitle.copyWith(
              color: color,
              decoration: _hovered ? TextDecoration.underline : null,
              decorationColor: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedTopLine extends CustomPainter {
  _DashedTopLine({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final components = AppTheme.dimensions.components;
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppTheme.dimensions.stroke.small;
    final y = paint.strokeWidth / 2;
    for (var x = 0.0; x < size.width; x += components.panelRowDash + components.panelRowDashGap) {
      final end = (x + components.panelRowDash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedTopLine oldDelegate) => oldDelegate.color != color;
}
