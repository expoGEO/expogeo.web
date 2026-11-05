import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SubthemeSubjects extends StatelessWidget {
  const SubthemeSubjects({super.key, required this.store, required this.onSelected});

  final SubthemeObjectsStore store;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    const label = 'Assuntos frequentes';

    return Observer(
      builder: (context) {
        final subjects = store.frequentSubjects;
        if (subjects.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(
            top: components.subjectsPaddingTop,
            bottom: components.subjectsPaddingBottom,
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: components.subjectChipGap,
            runSpacing: components.subjectChipGap,
            children: [
              // O rótulo em caixa alta seria soletrado; a leitura de tela recebe o texto normal.
              Padding(
                padding: EdgeInsets.only(right: components.subjectsLabelGap),
                child: Semantics(
                  container: true,
                  label: label,
                  excludeSemantics: true,
                  child: Text(
                    label.toUpperCase(),
                    style: styles.label.copyWith(
                      fontSize: components.subjectsLabelText,
                      letterSpacing:
                          components.subjectsLabelText * components.objectCardTypeLetterSpacing,
                      color: colors.inkSecondary,
                    ),
                  ),
                ),
              ),
              for (final subject in subjects)
                _SubjectChip(text: subject, onPressed: () => onSelected(subject)),
            ],
          ),
        );
      },
    );
  }
}

class _SubjectChip extends StatefulWidget {
  const _SubjectChip({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  State<_SubjectChip> createState() => _SubjectChipState();
}

class _SubjectChipState extends State<_SubjectChip> {
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
    final radius = BorderRadius.circular(dimensions.radii.pill);

    return Semantics(
      button: true,
      label: widget.text,
      onTap: widget.onPressed,
      // Sem o nó do InkWell, o foco precisa estar neste; senão o leitor de tela perde o foco.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: _hovered ? colors.accentSoft : colors.surface,
          borderRadius: radius,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: components.subjectChipMinHeight),
              child: Padding(
                padding: components.subjectChipPadding,
                child: Text(
                  widget.text,
                  style: AppTheme.typography
                      .of(context)
                      .chip
                      .copyWith(
                        fontSize: components.subjectChipText,
                        fontWeight: FontWeight.w500,
                        color: _hovered ? colors.accentStrong : colors.ink,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
