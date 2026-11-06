import 'dart:math';

import 'package:expogeo/core/components/reading/reference_code.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/date/date.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/theme/components/subject_tag.dart';
import 'package:flutter/material.dart';

class ObjectSheet extends StatelessWidget {
  const ObjectSheet({super.key, required this.item});

  static const String defaultRegistrationRules =
      'Tema geral / Tema específico / Número de referência da curadoria expoGEO';

  final CatalogItem item;

  /// Só o par com valor preenchido entra na ficha.
  static _Pair? _pair(String label, String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : _Pair(label, text);
  }

  List<_Group> _groups() {
    final content = item.content;
    final people = content.intellectualIndicator;
    final origin = content.originInfo;
    final registration = content.registrationInfo;
    final code = content.id.trim();
    final rules = registration.registrationRules?.trim() ?? '';
    final subjects = [
      for (final subject in content.contentInfo.subjects)
        if (subject.trim().isNotEmpty) subject.trim(),
    ];

    final groups = [
      _Group('Autoria', [
        ?_pair('Criador', people.creator),
        ?_pair('Colaborador', people.collaborator),
      ]),
      _Group('Conteúdo', const [], subjects: subjects),
      _Group('Origem', [
        ?_pair('Tipo', origin.type.value),
        ?_pair('Formato', origin.format.value),
        ?_pair('Idioma', origin.language),
        ?_pair('Requisitos', origin.requirements),
        ?_pair('Inserido em', origin.insertionDate.shortDate),
      ]),
      _Group('Registro', [
        if (code.isNotEmpty) _Pair('Código de referência', code, valueWidget: ReferenceCode(code)),
        ?_pair('Ano de emissão', registration.issueYear?.toString()),
        ?_pair('Regras de registro', rules.isEmpty ? defaultRegistrationRules : rules),
      ]),
      _Group('Direitos e preservação', [
        ?_pair('Direitos', content.rightsInfo.rights),
        ?_pair('Ação de preservação', item.preservation?.operation),
        ?_pair('Próxima revisão do link', item.preservation?.updateDate?.monthYear),
      ]),
    ];
    return groups.where((group) => group.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groups();

    return _SheetFrame(
      head: _SheetHead(code: item.content.id.trim()),
      groups: [for (final group in groups) _GroupView(group: group)],
    );
  }
}

class _Pair {
  const _Pair(this.label, this.value, {this.valueWidget});

  final String label;
  final String value;

  /// No lugar do texto de [value], que segue sendo o lido pelo leitor de tela.
  final Widget? valueWidget;
}

class _Group {
  const _Group(this.title, this.pairs, {this.subjects = const []});

  final String title;
  final List<_Pair> pairs;
  final List<String> subjects;

  bool get isNotEmpty => pairs.isNotEmpty || subjects.isNotEmpty;
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.head, required this.groups});

  final Widget head;
  final List<Widget> groups;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final radius = BorderRadius.circular(dimensions.radii.r18);
    final side = BorderSide(color: colors.line, width: dimensions.stroke.small);

    return Padding(
      padding: EdgeInsets.only(
        top: components.objectSheetTop,
        bottom: components.objectSheetBottom,
      ),
      // A borda fica por cima do fundo do cabeçalho, que o recorte acompanha pelo raio.
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(border: Border.fromBorderSide(side), borderRadius: radius),
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: colors.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border(bottom: side),
                  ),
                  child: Padding(padding: components.objectSheetHeadPadding, child: head),
                ),
                for (final (index, group) in groups.indexed)
                  DecoratedBox(
                    decoration: BoxDecoration(border: index == 0 ? null : Border(top: side)),
                    child: Padding(
                      padding: EdgeInsets.all(components.objectSheetGroupPadding),
                      child: group,
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

class _SheetHead extends StatelessWidget {
  const _SheetHead({required this.code});

  static const String _title = 'Ficha da curadoria';

  final String code;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final size = components.objectSheetHeadText;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: components.objectSheetHeadGap,
      runSpacing: components.objectSheetHeadGap,
      children: [
        Semantics(
          container: true,
          header: true,
          headingLevel: 2,
          label: _title,
          excludeSemantics: true,
          child: Text(
            _title.toUpperCase(),
            style: AppTheme.typography
                .of(context)
                .label
                .copyWith(
                  fontSize: size,
                  letterSpacing: size * components.objectSheetHeadLetterSpacing,
                  color: AppTheme.colors.inkSecondary,
                ),
          ),
        ),
        if (code.isNotEmpty) ReferenceCode(code),
      ],
    );
  }
}

class _GroupView extends StatelessWidget {
  const _GroupView({required this.group});

  final _Group group;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final size = components.objectSheetGroupTitleText;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final columns = switch (breakpoint) {
      Breakpoint.mobile => components.objectSheetColumnsMobile,
      Breakpoint.tablet => components.objectSheetColumnsTablet,
      Breakpoint.desktop => components.objectSheetColumnsDesktop,
    };

    final title = Semantics(
      container: true,
      header: true,
      headingLevel: 3,
      label: group.title,
      excludeSemantics: true,
      child: Padding(
        padding: EdgeInsets.only(top: components.objectSheetGroupTitleTop),
        child: Text(
          group.title.toUpperCase(),
          style: AppTheme.typography
              .of(context)
              .label
              .copyWith(
                fontSize: size,
                letterSpacing: size * components.objectSheetLabelLetterSpacing,
                color: AppTheme.colors.accent,
              ),
        ),
      ),
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (group.subjects.isNotEmpty) _SubjectsView(subjects: group.subjects),
        if (group.pairs.isNotEmpty) _PairRows(pairs: group.pairs, columns: columns),
      ],
    );

    if (breakpoint == Breakpoint.mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          title,
          SizedBox(height: components.objectSheetGroupGapV),
          body,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: components.objectSheetGroupTitle, child: title),
        SizedBox(width: components.objectSheetGroupGapH),
        Expanded(child: body),
      ],
    );
  }
}

/// Divide a largura entre os pares: com menos pares que colunas, cada um ocupa uma fatia maior.
class _PairRows extends StatelessWidget {
  const _PairRows({required this.pairs, required this.columns});

  final List<_Pair> pairs;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final perRow = min(columns, pairs.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var start = 0; start < pairs.length; start += perRow) ...[
          if (start > 0) SizedBox(height: components.objectSheetPairGapV),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = start; i < start + perRow; i++) ...[
                if (i > start) SizedBox(width: components.objectSheetPairGapH),
                Expanded(child: i < pairs.length ? _PairView(pair: pairs[i]) : const SizedBox()),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _PairLabel extends StatelessWidget {
  const _PairLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final size = components.objectSheetLabelText;

    return Text(
      text.toUpperCase(),
      style: AppTheme.typography
          .of(context)
          .label
          .copyWith(
            fontSize: size,
            letterSpacing: size * components.objectSheetLabelLetterSpacing,
            color: AppTheme.colors.inkSecondary,
          ),
    );
  }
}

class _PairView extends StatelessWidget {
  const _PairView({required this.pair});

  final _Pair pair;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final valueWidget = pair.valueWidget;

    // O rótulo em caixa alta seria soletrado; o par é lido junto, com o texto normal.
    return Semantics(
      container: true,
      label: '${pair.label}: ${pair.value}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _PairLabel(pair.label),
          SizedBox(height: components.objectSheetLabelGap),
          valueWidget ??
              Text(
                pair.value,
                style: AppTheme.typography
                    .of(context)
                    .regular
                    .copyWith(
                      fontSize: components.objectSheetValueText,
                      color: AppTheme.colors.ink,
                    ),
              ),
        ],
      ),
    );
  }
}

class _SubjectsView extends StatelessWidget {
  const _SubjectsView({required this.subjects});

  final List<String> subjects;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      label: 'Assuntos: ${subjects.join(', ')}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PairLabel('Assuntos'),
          SizedBox(height: components.objectSheetTagsTop),
          Wrap(
            spacing: components.objectRowTagGap,
            runSpacing: components.objectRowTagGap,
            children: [for (final subject in subjects) SubjectTag(subject)],
          ),
        ],
      ),
    );
  }
}

class ObjectSheetSkeleton extends StatelessWidget {
  const ObjectSheetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final line = components.objectSheetValueText * components.objectCardSkeletonBarFill;

    return ExcludeSemantics(
      child: _SheetFrame(
        head: AppSkeleton(
          width: components.objectCardSkeletonFooterWidth,
          height: components.objectSheetHeadText,
        ),
        groups: [
          for (var i = 0; i < components.objectSheetSkeletonGroups; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppSkeleton(
                    width: components.objectCardSkeletonTypeWidth,
                    height: components.objectSheetGroupTitleText,
                  ),
                ),
                SizedBox(height: components.objectSheetGroupGapV),
                AppSkeleton(height: line),
                SizedBox(height: components.objectSheetPairGapV),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: components.objectCardSkeletonShortLine,
                  child: AppSkeleton(height: line),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
