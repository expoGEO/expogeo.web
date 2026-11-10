import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/accessibility/announce.dart';
import 'package:expogeo/features/admin/panel/presentation/editor/object_editor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// "Falta preencher para salvar:", com um link para cada campo pendente.
class ObjectEditorMissingAlert extends StatefulWidget {
  const ObjectEditorMissingAlert({
    required this.problems,
    required this.focusNode,
    required this.onSelect,
    super.key,
  });

  static const String title = 'Falta preencher para salvar:';

  final List<EditorProblem> problems;
  final FocusNode focusNode;
  final ValueChanged<EditorProblem> onSelect;

  @override
  State<ObjectEditorMissingAlert> createState() => _ObjectEditorMissingAlertState();
}

class _ObjectEditorMissingAlertState extends State<ObjectEditorMissingAlert> {
  String get _message =>
      '${ObjectEditorMissingAlert.title} ${widget.problems.map((p) => p.label).join(', ')}.';

  @override
  void initState() {
    super.initState();
    _announce();
  }

  @override
  void didUpdateWidget(covariant ObjectEditorMissingAlert oldWidget) {
    super.didUpdateWidget(oldWidget);
    _announce();
  }

  // O motor web não lê uma região viva que já tem papel; a lista atualizada precisa ser anunciada.
  void _announce() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announceToScreenReader(
        _message,
        Directionality.of(context),
        assertiveness: Assertiveness.assertive,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final style = styles.formError.copyWith(color: colors.error);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);

    return Semantics(
      container: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Focus(
          focusNode: widget.focusNode,
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.errorSurface, borderRadius: radius),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.formAlertPaddingH,
                vertical: components.formAlertPaddingV,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.error_outline,
                      size: components.formAlertIcon,
                      color: colors.error,
                    ),
                  ),
                  SizedBox(width: components.formAlertGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ObjectEditorMissingAlert.title,
                          style: style.copyWith(fontWeight: FontWeight.w700),
                        ),
                        for (final problem in widget.problems)
                          Semantics(
                            link: true,
                            label: problem.label,
                            excludeSemantics: true,
                            onTap: () => widget.onSelect(problem),
                            child: AppFocusRing(
                              borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r6),
                              child: InkWell(
                                onTap: () => widget.onSelect(problem),
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                child: Padding(
                                  padding: EdgeInsets.only(top: components.formFieldLabelGap),
                                  child: Text.rich(
                                    TextSpan(
                                      text: '•  ',
                                      children: [
                                        TextSpan(
                                          text: problem.label,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            decorationColor: colors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: style,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
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
