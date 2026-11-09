import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Um grupo de esqueletos lido uma vez como "Carregando…", sem os blocos.
class LoadingRegion extends StatelessWidget {
  const LoadingRegion({super.key, required this.child});

  static const String label = 'Carregando…';

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      role: SemanticsRole.status,
      label: label,
      excludeSemantics: true,
      child: child,
    );
  }
}
