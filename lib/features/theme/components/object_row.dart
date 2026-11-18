import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/theme/components/subject_tag.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ObjectRow extends StatefulWidget {
  const ObjectRow({
    super.key,
    required this.item,
    required this.detailsRoute,
    this.primaryFocusNode,
  });

  static const int maxTags = 4;

  final CatalogItem item;

  final String detailsRoute;

  /// Vai para o título, o primeiro clicável da linha.
  final FocusNode? primaryFocusNode;

  @override
  State<ObjectRow> createState() => _ObjectRowState();
}

class _ObjectRowState extends State<ObjectRow> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final desktop = ScreenUtils.breakpointOf(context) == Breakpoint.desktop;
    final item = widget.item;
    final type = item.content.originInfo.type;
    final actions = _Actions(inRow: desktop, item: item, detailsRoute: widget.detailsRoute);

    final body = _RowBody(
      item: item,
      detailsRoute: widget.detailsRoute,
      primaryFocusNode: widget.primaryFocusNode,
      hovered: _hovered,
    );

    final content = desktop
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.topLeft, child: _TypeIcon(type.cardIcon)),
                SizedBox(width: components.objectRowColumnGap),
                Expanded(child: body),
                SizedBox(width: components.objectRowColumnGap),
                Center(child: actions),
              ],
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeIcon(type.cardIcon),
              SizedBox(width: components.objectRowColumnGapCompact),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    body,
                    SizedBox(height: components.objectRowActionsTop),
                    actions,
                  ],
                ),
              ),
            ],
          );

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: _RowFrame(hovered: _hovered, color: colors.surface, child: content),
    );
  }
}

/// Fundo mais largo que a coluna de conteúdo e linha divisória, atrás do conteúdo.
class _RowFrame extends StatelessWidget {
  const _RowFrame({required this.child, this.hovered = false, this.color});

  final Widget child;
  final bool hovered;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final bleed = components.objectRowBleed;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -bleed,
          right: -bleed,
          top: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: hovered ? color : null,
              borderRadius: BorderRadius.circular(dimensions.radii.r12),
            ),
          ),
        ),
        Positioned(
          left: -bleed,
          right: -bleed,
          bottom: 0,
          child: SizedBox(
            height: dimensions.stroke.small,
            child: ColoredBox(color: AppTheme.colors.line),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: components.objectRowPadding),
          child: child,
        ),
      ],
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final desktop = ScreenUtils.breakpointOf(context) == Breakpoint.desktop;
    final box = desktop ? components.objectRowIconBox : components.objectRowIconBoxCompact;

    return ExcludeSemantics(
      child: Container(
        width: box,
        height: box,
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: BorderRadius.circular(components.objectCardIconRadius),
        ),
        child: Icon(
          icon,
          size: desktop ? components.objectCardIcon : components.objectRowIconCompact,
          color: colors.accent,
        ),
      ),
    );
  }
}

class _RowBody extends StatelessWidget {
  const _RowBody({
    required this.item,
    required this.detailsRoute,
    required this.primaryFocusNode,
    required this.hovered,
  });

  final CatalogItem item;
  final String detailsRoute;
  final FocusNode? primaryFocusNode;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final content = item.content;
    final origin = content.originInfo;
    final label = typeLine(origin.type, origin.format);
    final description = content.contentInfo.description.trim();
    final meta = _metaOf(item);
    final tags = [
      for (final subject in content.contentInfo.subjects)
        if (subject.trim().isNotEmpty) subject.trim(),
    ].take(ObjectRow.maxTags).toList();
    final metaStyle = styles.small.copyWith(
      fontSize: components.objectRowMetaText,
      color: colors.inkSecondary,
    );
    final gap = SizedBox(height: components.objectRowTextGap);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // O rótulo em caixa alta seria soletrado; a leitura de tela recebe o texto normal.
        Semantics(
          container: true,
          label: label,
          excludeSemantics: true,
          child: Text(
            label.toUpperCase(),
            style: styles.label.copyWith(
              fontSize: components.objectCardTypeText,
              letterSpacing: components.objectCardTypeText * components.objectCardTypeLetterSpacing,
              // O laranja normal fica abaixo de 4,5:1 sobre o fundo do hover.
              color: hovered ? colors.accentStrong : colors.accent,
            ),
          ),
        ),
        gap,
        _RowTitle(
          title: content.contentInfo.title,
          route: detailsRoute,
          focusNode: primaryFocusNode,
          rowHovered: hovered,
        ),
        if (description.isNotEmpty) ...[
          gap,
          Semantics(
            container: true,
            child: Text(
              description,
              style: styles.regular.copyWith(
                fontSize: components.objectRowDescription,
                color: colors.inkSecondary,
              ),
            ),
          ),
        ],
        if (meta.isNotEmpty) ...[
          gap,
          Wrap(
            spacing: components.objectRowMetaGapH,
            runSpacing: components.objectRowMetaGapV,
            children: [
              for (final text in meta)
                Semantics(container: true, child: Text(text, style: metaStyle)),
            ],
          ),
        ],
        if (tags.isNotEmpty) ...[
          SizedBox(height: components.objectRowTagsTop),
          Wrap(
            spacing: components.objectRowTagGap,
            runSpacing: components.objectRowTagGap,
            children: [for (final tag in tags) SubjectTag(tag)],
          ),
        ],
      ],
    );
  }

  static List<String> _metaOf(CatalogItem item) {
    final creator = item.content.intellectualIndicator.creator.trim();
    final year = item.content.registrationInfo.issueYear;
    final domain = UrlUtils.displayDomain(item.content.registrationInfo.location);
    return [
      if (creator.isNotEmpty) creator,
      if (year != null) '$year',
      if (domain.isNotEmpty) domain,
    ];
  }
}

class _RowTitle extends StatefulWidget {
  const _RowTitle({
    required this.title,
    required this.route,
    required this.focusNode,
    required this.rowHovered,
  });

  final String title;
  final String route;
  final FocusNode? focusNode;
  final bool rowHovered;

  @override
  State<_RowTitle> createState() => _RowTitleState();
}

class _RowTitleState extends State<_RowTitle> {
  FocusNode? _ownFocusNode;
  bool _hovered = false;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _open() => context.go(widget.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final base = AppTheme.typography
        .of(context)
        .h3
        .copyWith(fontSize: components.objectRowTitle, height: components.objectRowTitleHeight);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return SelectionContainer.disabled(
      child: Semantics(
        link: true,
        label: widget.title,
        onTap: _open,
        // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
        focusable: true,
        focused: _focused,
        onFocus: _focusNode.requestFocus,
        container: true,
        explicitChildNodes: true,
        child: AppFocusRing(
          borderRadius: radius,
          fit: StackFit.passthrough,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Semantics(
                  container: true,
                  header: true,
                  headingLevel: 3,
                  child: Text(
                    widget.title,
                    style: base.copyWith(
                      color: widget.rowHovered ? colors.accentStrong : colors.ink,
                      decoration: _hovered ? TextDecoration.underline : null,
                      decorationColor: colors.accentStrong,
                    ),
                  ),
                ),
                // Por cima do texto e fora da semântica: assim o título segue um nó próprio
                // dentro do link, sem um segundo ponto de foco.
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: InkWell(
                      focusNode: _focusNode,
                      onTap: _open,
                      onHover: (value) => setState(() => _hovered = value),
                      onFocusChange: (value) => setState(() => _focused = value),
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                      mouseCursor: SystemMouseCursors.click,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.inRow, required this.item, required this.detailsRoute});

  /// Dentro do `IntrinsicHeight`, um `Wrap` mede sem o espaçamento e a altura sai errada.
  final bool inRow;
  final CatalogItem item;
  final String detailsRoute;

  String get _location => item.content.registrationInfo.location.trim();

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.dimensions.components.objectRowActionsGap;

    final details = AppButton.ghost(
      text: 'Ver ficha',
      size: AppButtonSize.small,
      onPressed: () => context.go(detailsRoute),
    );
    final open = !UrlUtils.isOpenable(_location)
        ? null
        : AppButton.secondary(text: 'Acessar', size: AppButtonSize.small, externalUrl: _location);

    if (!inRow) {
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [details, ?open],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        details,
        if (open != null) SizedBox(width: gap),
        ?open,
      ],
    );
  }
}

class ObjectRowSkeleton extends StatelessWidget {
  const ObjectRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final desktop = ScreenUtils.breakpointOf(context) == Breakpoint.desktop;
    final box = desktop ? components.objectRowIconBox : components.objectRowIconBoxCompact;
    final styles = AppTheme.typography.of(context);
    final titleLine = components.objectRowTitle * components.objectRowTitleHeight;
    final descriptionLine = components.objectRowDescription * styles.regular.height!;
    final gap = SizedBox(height: components.objectCardGap);

    Widget line(double height, {bool short = false}) => FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: short ? components.objectCardSkeletonShortLine : 1,
      child: AppSkeleton(height: height * components.objectCardSkeletonBarFill),
    );

    return ExcludeSemantics(
      child: _RowFrame(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton(width: box, height: box, radius: components.objectCardIconRadius),
            SizedBox(
              width: desktop ? components.objectRowColumnGap : components.objectRowColumnGapCompact,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppSkeleton(
                      width: components.objectCardSkeletonTypeWidth,
                      height: components.objectCardTypeText,
                    ),
                  ),
                  gap,
                  line(titleLine, short: true),
                  gap,
                  line(descriptionLine),
                  gap,
                  line(descriptionLine, short: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
