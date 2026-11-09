import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/components/skeleton/loading_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lê "Carregando…" uma vez e nada dos blocos', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingRegion(
            child: Column(
              children: [
                AppSkeleton(width: 100, height: 20),
                Text('Bloco'),
                AppSkeleton(width: 100, height: 20),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Carregando…'), findsOneWidget);
    expect(find.bySemanticsLabel('Bloco'), findsNothing);
    final node = tester.getSemantics(find.byType(LoadingRegion));
    expect(node.getSemanticsData().role, SemanticsRole.status);
    handle.dispose();
  });
}
