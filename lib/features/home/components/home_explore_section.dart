import 'package:expogeo/core/components/focus/app_focus_ring.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class HomeExploreSection extends StatelessWidget {
  const HomeExploreSection({super.key, this.store});

  /// Sem valor, usa o catálogo registrado no app.
  final CatalogStore? store;

  static const ThemeEnum exampleTheme = ThemeEnum.naturezaMeioAmbiente;
  static const SubthemeEnum exampleSubtheme = SubthemeEnum.biomas;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final padding = switch (breakpoint) {
      Breakpoint.mobile => components.sectionPaddingMobile,
      Breakpoint.tablet => components.sectionPaddingTablet,
      Breakpoint.desktop => components.sectionPaddingDesktop,
    };
    final store = this.store ?? GetIt.I<CatalogStore>();
    final themeTitle = ThemeDataModel.themes.firstWhere((t) => t.type == exampleTheme).title;

    final steps = [
      _Step(
        number: 1,
        title: 'Escolha um tema',
        text: 'Quatro grandes temas da Geografia escolar, do mapa à política.',
        example: _Example(
          children: [_ExampleLink(text: themeTitle, route: exampleTheme.route)],
        ),
      ),
      _Step(
        number: 2,
        title: 'Entre num subtema',
        text: 'Cada subtema reúne objetos sobre um assunto, com busca e filtro por tipo.',
        example: _SubthemeExample(store: store),
      ),
      _Step(
        number: 3,
        title: 'Acesse o recurso',
        text: 'Veja a ficha da curadoria e abra o site, vídeo ou aplicativo na fonte original.',
        example: _ObjectExample(store: store),
      ),
    ];

    return ColoredBox(
      color: colors.surface,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sobre a superfície, o laranja de link fica abaixo de 4,5:1.
              Text(
                'Como explorar'.toUpperCase(),
                style: styles.label.copyWith(color: colors.accentStrong),
              ),
              SizedBox(height: components.sectionLabelGap),
              Semantics(
                header: true,
                headingLevel: 2,
                child: Text(
                  'Do tema ao recurso, em três passos',
                  style: styles.h2.copyWith(color: colors.ink),
                ),
              ),
              SizedBox(height: components.sectionHeadGap),
              if (breakpoint == Breakpoint.desktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0) SizedBox(width: components.stepsGap),
                      Expanded(child: steps[i]),
                    ],
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0) SizedBox(height: components.stepsGap),
                      steps[i],
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.text,
    required this.example,
  });

  final int number;
  final String title;
  final String text;
  final Widget example;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.ink, width: components.stepRule),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: components.stepPaddingTop),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  alignment: Alignment.center,
                  width: components.stepNumber,
                  height: components.stepNumber,
                  decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
                  child: Text(
                    '$number',
                    style: styles.label.copyWith(
                      fontSize: components.stepNumberText,
                      letterSpacing: 0,
                      color: colors.accentStrong,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: components.stepGap),
            Semantics(
              header: true,
              headingLevel: 3,
              child: Text(
                title,
                style: styles.h3.copyWith(fontSize: components.stepTitle, color: colors.ink),
              ),
            ),
            SizedBox(height: components.stepGap),
            Text(text, style: styles.regular.copyWith(color: colors.inkSecondary)),
            example,
          ],
        ),
      ),
    );
  }
}

/// Caixa "Ex.:" com o exemplo de cada passo.
class _Example extends StatelessWidget {
  const _Example({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final style = AppTheme.typography
        .of(context)
        .small
        .copyWith(fontSize: components.stepExampleText, color: colors.ink);

    return Padding(
      padding: EdgeInsets.only(top: components.stepGap + components.stepExampleTop),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(dimensions.radii.r10),
          border: Border.all(color: colors.line, width: dimensions.stroke.small),
        ),
        child: Padding(
          padding: components.stepExamplePadding,
          child: DefaultTextStyle.merge(
            style: style,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [const Text('Ex.: '), ...children],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubthemeExample extends StatelessWidget {
  const _SubthemeExample({required this.store});

  final CatalogStore store;

  @override
  Widget build(BuildContext context) {
    const subtheme = HomeExploreSection.exampleSubtheme;

    return Observer(
      builder: (context) {
        final state = store.state;
        final loading = state.isInitial || state.isLoading;
        final count = switch (state) {
          CatalogStateSuccess(:final catalog) => catalog.countBySubtheme(subtheme),
          _ => null,
        };

        return _Example(
          children: [
            _ExampleLink(text: subtheme.name, route: subtheme.route),
            if (count != null) Text(' · $count ${count == 1 ? 'objeto' : 'objetos'}'),
            if (loading) ...[const Text(' · '), const _ExampleSkeleton(wide: false)],
          ],
        );
      },
    );
  }
}

class _ObjectExample extends StatelessWidget {
  const _ObjectExample({required this.store});

  final CatalogStore store;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final state = store.state;
        if (state.isInitial || state.isLoading) {
          return const _Example(children: [_ExampleSkeleton(wide: true)]);
        }

        final item = store.catalog?.firstOf(HomeExploreSection.exampleSubtheme);
        if (item == null) return const SizedBox.shrink();
        return _Example(
          children: [_ExampleLink(text: item.content.contentInfo.title, route: item.route)],
        );
      },
    );
  }
}

class _ExampleSkeleton extends StatelessWidget {
  const _ExampleSkeleton({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return AppSkeleton(
      width: wide ? components.stepExampleSkeletonTitle : components.stepExampleSkeletonCount,
      height: components.stepExampleText,
    );
  }
}

class _ExampleLink extends StatefulWidget {
  const _ExampleLink({required this.text, required this.route});

  final String text;
  final String route;

  @override
  State<_ExampleLink> createState() => _ExampleLinkState();
}

class _ExampleLinkState extends State<_ExampleLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return Semantics(
      link: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          onTap: () => GoRouter.of(context).go(widget.route),
          onHover: (value) => setState(() => _hovered = value),
          borderRadius: radius,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          child: Text(
            widget.text,
            style: TextStyle(
              color: _hovered ? colors.accentStrong : colors.accent,
              fontWeight: FontWeight.w600,
              decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
              decorationColor: colors.accentStrong,
            ),
          ),
        ),
      ),
    );
  }
}
