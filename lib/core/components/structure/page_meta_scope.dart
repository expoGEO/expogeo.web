import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:expogeo/core/utils/environment/app_environment.dart';
import 'package:flutter/widgets.dart';

/// Aplica título, descrição e canonical da rota enquanto a página está na tela.
class PageMetaScope extends StatefulWidget {
  const PageMetaScope({super.key, required this.meta, required this.child});

  final PageMeta meta;
  final Widget child;

  @override
  State<PageMetaScope> createState() => _PageMetaScopeState();
}

class _PageMetaScopeState extends State<PageMetaScope> {
  @override
  void initState() {
    super.initState();
    _apply();
  }

  @override
  void didUpdateWidget(PageMetaScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meta.path != widget.meta.path ||
        oldWidget.meta.title != widget.meta.title ||
        oldWidget.meta.description != widget.meta.description) {
      _apply();
    }
  }

  void _apply() => applyPageMeta(widget.meta, isProd: AppEnvironment.current.isProd);

  @override
  Widget build(BuildContext context) => widget.child;
}
