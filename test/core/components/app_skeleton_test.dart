import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, {required bool reduceMotion}) {
    return tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: AppSkeleton(width: 120, height: 20)),
        ),
      ),
    );
  }

  Color? blockColor(WidgetTester tester) => tester
      .widget<Container>(
        find.descendant(of: find.byType(AppSkeleton), matching: find.byType(Container)),
      )
      .color;

  testWidgets('com "reduzir movimento", fica parado na cor base', (tester) async {
    await pump(tester, reduceMotion: true);

    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(blockColor(tester), AppTheme.colors.skeletonBase);
  });

  testWidgets('sem "reduzir movimento", o brilho repete a cada 1,4 s', (tester) async {
    await pump(tester, reduceMotion: false);

    expect(AppTheme.dimensions.components.skeletonShimmer, const Duration(milliseconds: 1400));
    expect(blockColor(tester), isNull);
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pump(const Duration(milliseconds: 1400));
    expect(tester.binding.hasScheduledFrame, isTrue);
  });
}
