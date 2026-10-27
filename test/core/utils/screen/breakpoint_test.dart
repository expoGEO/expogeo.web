import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final expected = <double, (Breakpoint, double)>{
    390: (Breakpoint.mobile, 20),
    599: (Breakpoint.mobile, 20),
    600: (Breakpoint.tablet, 32),
    768: (Breakpoint.tablet, 32),
    1023: (Breakpoint.tablet, 32),
    1024: (Breakpoint.desktop, 32),
    1280: (Breakpoint.desktop, 32),
  };

  group('Breakpoint.fromWidth', () {
    expected.forEach((width, value) {
      test('$width px é ${value.$1.name} com margem ${value.$2}', () {
        final breakpoint = Breakpoint.fromWidth(width);
        expect(breakpoint, value.$1);
        expect(ScreenUtils.contentMargin(breakpoint), value.$2);
      });
    });
  });

  group('funções antigas do ScreenUtils', () {
    for (final width in expected.keys) {
      testWidgets('$width px responde igual à faixa', (tester) async {
        late BuildContext captured;
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: Builder(
              builder: (context) {
                captured = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final breakpoint = expected[width]!.$1;
        expect(ScreenUtils.breakpointOf(captured), breakpoint);
        expect(ScreenUtils.isMobile(captured), breakpoint == Breakpoint.mobile);
        expect(ScreenUtils.isTablet(captured), breakpoint == Breakpoint.tablet);
        expect(ScreenUtils.isDesktop(captured), breakpoint == Breakpoint.desktop);
      });
    }
  });
}
