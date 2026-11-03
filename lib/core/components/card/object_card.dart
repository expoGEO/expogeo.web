import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Cartão de um objeto digital. O subtema vem à parte porque, no catálogo, ele sai do caminho
/// do documento e não do campo gravado no objeto.
class ObjectCard extends StatefulWidget {
  const ObjectCard({
    super.key,
    required this.content,
    required this.subtheme,
    required this.onOpen,
  });

  final ContentModel content;
  final SubthemeEnum subtheme;
  final VoidCallback onOpen;

  @override
  State<ObjectCard> createState() => _ObjectCardState();
}

class _ObjectCardState extends State<ObjectCard> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : components.hoverAnimation;
    final radius = BorderRadius.circular(dimensions.radii.r16);
    final lift = _hovered && !reduceMotion ? -components.objectCardHoverLift : 0.0;

    return SelectionContainer.disabled(
      child: Semantics(
        link: true,
        label: widget.content.contentInfo.title,
        onTap: widget.onOpen,
        // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
        focusable: true,
        focused: _focused,
        onFocus: _focusNode.requestFocus,
        container: true,
        explicitChildNodes: true,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, lift, 0),
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: _hovered ? dimensions.shadows.elevated : const [],
          ),
          child: AppFocusRing(
            borderRadius: radius,
            fit: StackFit.passthrough,
            child: Material(
              color: colors.page,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: radius,
                side: BorderSide(
                  color: _hovered ? colors.accent : colors.line,
                  width: dimensions.stroke.small,
                ),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  _CardBody(content: widget.content, subtheme: widget.subtheme, hovered: _hovered),
                  // Por cima do conteúdo e fora da semântica: assim o cabeçalho e os textos
                  // continuam nós próprios dentro do link, sem um segundo ponto de foco.
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: InkWell(
                        focusNode: _focusNode,
                        onTap: widget.onOpen,
                        onHover: (value) => setState(() => _hovered = value),
                        onFocusChange: (value) => setState(() => _focused = value),
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        mouseCursor: SystemMouseCursors.click,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.content, required this.subtheme, required this.hovered});

  final ContentModel content;
  final SubthemeEnum subtheme;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final origin = content.originInfo;
    final description = content.contentInfo.description.trim();
    final typeStyle = styles.label.copyWith(
      fontSize: components.objectCardTypeText,
      letterSpacing: components.objectCardTypeText * components.objectCardTypeLetterSpacing,
      color: colors.accent,
    );

    return Padding(
      padding: EdgeInsets.all(components.objectCardPadding),
      // Distribui a sobra entre o topo e o rodapé: na grade, o rodapé fica no pé do cartão.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: components.objectCardIconBox,
                      height: components.objectCardIconBox,
                      decoration: BoxDecoration(
                        color: colors.accentSoft,
                        borderRadius: BorderRadius.circular(components.objectCardIconRadius),
                      ),
                      child: Icon(
                        origin.type.cardIcon,
                        size: components.objectCardIcon,
                        color: colors.accent,
                      ),
                    ),
                  ),
                  SizedBox(width: components.objectCardGap),
                  Expanded(
                    child: Semantics(
                      container: true,
                      child: Text(
                        typeLine(origin.type, origin.format).toUpperCase(),
                        style: typeStyle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: components.objectCardGap),
              Semantics(
                container: true,
                header: true,
                headingLevel: 3,
                child: Text(
                  content.contentInfo.title,
                  maxLines: components.objectCardTitleLines,
                  overflow: TextOverflow.ellipsis,
                  style: styles.h3.copyWith(
                    fontSize: components.objectCardTitle,
                    height: components.objectCardTitleHeight,
                    color: hovered ? colors.accent : colors.ink,
                  ),
                ),
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: components.objectCardGap),
                Semantics(
                  container: true,
                  child: Text(
                    description,
                    maxLines: components.objectCardDescriptionLines,
                    overflow: TextOverflow.ellipsis,
                    style: styles.regular.copyWith(
                      fontSize: components.objectCardDescription,
                      color: colors.inkSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: components.objectCardGap),
            child: _CardFooter(content: content, subtheme: subtheme),
          ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.content, required this.subtheme});

  final ContentModel content;
  final SubthemeEnum subtheme;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final creator = content.intellectualIndicator.creator.trim();
    final where = creator.isEmpty ? subtheme.name : '${subtheme.name} · $creator';

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.line, width: dimensions.stroke.small),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: components.objectCardFooterPaddingTop),
        child: Row(
          children: [
            AppMedallion(size: components.objectCardMedallion, image: subtheme.illustration),
            SizedBox(width: components.objectCardFooterGap),
            Expanded(
              child: Semantics(
                container: true,
                child: Text(
                  where,
                  style: AppTheme.typography
                      .of(context)
                      .small
                      .copyWith(
                        fontSize: components.objectCardFooterText,
                        color: colors.inkSecondary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ObjectCardSkeleton extends StatelessWidget {
  const ObjectCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);
    final titleLine = components.objectCardTitle * components.objectCardTitleHeight;
    final descriptionLine = components.objectCardDescription * styles.regular.height!;
    final gap = SizedBox(height: components.objectCardGap);

    Widget line(double height, {bool short = false}) => FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: short ? components.objectCardSkeletonShortLine : 1,
      child: AppSkeleton(height: height * components.objectCardSkeletonBarFill),
    );

    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(dimensions.radii.r16),
          border: Border.all(color: colors.line, width: dimensions.stroke.small),
        ),
        child: Padding(
          padding: EdgeInsets.all(components.objectCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      AppSkeleton(
                        width: components.objectCardIconBox,
                        height: components.objectCardIconBox,
                        radius: components.objectCardIconRadius,
                      ),
                      SizedBox(width: components.objectCardGap),
                      AppSkeleton(
                        width: components.objectCardSkeletonTypeWidth,
                        height: components.objectCardTypeText,
                      ),
                    ],
                  ),
                  gap,
                  line(titleLine),
                  SizedBox(height: titleLine * (1 - components.objectCardSkeletonBarFill)),
                  line(titleLine, short: true),
                  gap,
                  line(descriptionLine),
                  SizedBox(height: descriptionLine * (1 - components.objectCardSkeletonBarFill)),
                  line(descriptionLine, short: true),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: components.objectCardGap),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.line, width: dimensions.stroke.small),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: components.objectCardFooterPaddingTop),
                    child: Row(
                      children: [
                        AppSkeleton(
                          width: components.objectCardMedallion,
                          height: components.objectCardMedallion,
                          radius: components.objectCardMedallion / 2,
                        ),
                        SizedBox(width: components.objectCardFooterGap),
                        AppSkeleton(
                          width: components.objectCardSkeletonFooterWidth,
                          height: components.objectCardFooterText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
