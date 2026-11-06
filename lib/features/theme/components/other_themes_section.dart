import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_illustration.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtherThemesSection extends StatelessWidget {
  const OtherThemesSection({super.key, required this.current});

  final ThemeModel current;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    const label = 'Outros temas';

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(
          top: components.otherThemesPaddingTop,
          bottom: components.otherThemesPaddingBottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // O rótulo em caixa alta seria soletrado; a leitura de tela recebe o texto normal.
            Semantics(
              header: true,
              headingLevel: 2,
              label: label,
              excludeSemantics: true,
              child: Text(label.toUpperCase(), style: styles.label.copyWith(color: colors.accent)),
            ),
            SizedBox(height: components.otherThemesLabelGap),
            Wrap(
              spacing: components.otherThemesGap,
              runSpacing: components.otherThemesGap,
              children: [
                for (final theme in ThemeDataModel.themes)
                  if (theme.type != current.type) _ThemeChip(theme: theme),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatefulWidget {
  const _ThemeChip({required this.theme});

  final ThemeModel theme;

  @override
  State<_ThemeChip> createState() => _ThemeChipState();
}

class _ThemeChipState extends State<_ThemeChip> {
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _open() => GoRouter.of(context).go(widget.theme.type.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final radius = BorderRadius.circular(dimensions.radii.pill);

    return Semantics(
      link: true,
      label: widget.theme.title,
      onTap: _open,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      container: true,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: colors.page,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: _hovered ? colors.ink : colors.line,
              width: dimensions.stroke.small,
            ),
          ),
          child: InkWell(
            focusNode: _focusNode,
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: components.minTapTarget),
              child: Padding(
                padding: components.themeChipPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppMedallion(
                      size: components.themeChipMedallion,
                      image: widget.theme.type.illustration,
                    ),
                    SizedBox(width: components.themeChipGap),
                    Flexible(
                      child: Text(
                        widget.theme.title,
                        style: AppTheme.typography
                            .of(context)
                            .small
                            .copyWith(
                              fontSize: components.themeChipText,
                              fontWeight: FontWeight.w600,
                              color: colors.ink,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
