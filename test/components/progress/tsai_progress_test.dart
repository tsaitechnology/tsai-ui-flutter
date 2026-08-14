import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../test_utils/load_test_fonts.dart';

void main() {
  setUpAll(loadTsaiTestFonts);

  testWidgets('matches all Penpot Progress Bar label arrangements', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 342,
              child: TsaiProgressBar(
                value: 0.6,
                labelPosition: TsaiProgressBarLabelPosition.left,
              ),
            ),
            SizedBox(
              width: 342,
              child: TsaiProgressBar(
                value: 0.6,
                labelPosition: TsaiProgressBarLabelPosition.right,
              ),
            ),
            SizedBox(
              width: 342,
              child: TsaiProgressBar(
                value: 0.6,
                labelPosition: TsaiProgressBarLabelPosition.top,
              ),
            ),
            SizedBox(
              width: 342,
              child: TsaiProgressBar(
                value: 0.6,
                labelPosition: TsaiProgressBarLabelPosition.both,
              ),
            ),
          ],
        ),
      ),
    );

    final bars = find.byType(TsaiProgressBar);
    expect(tester.getSize(bars.at(0)), const Size(342, 16));
    expect(tester.getSize(bars.at(1)), const Size(342, 16));
    expect(tester.getSize(bars.at(2)), const Size(342, 28));
    expect(tester.getSize(bars.at(3)), const Size(342, 16));
    for (final track
        in find.byKey(const ValueKey('tsai-progress-track')).evaluate()) {
      expect(track.size!.height, 4);
    }
    expect(find.text('60%'), findsNWidgets(4));
  });

  for (final state in TsaiProgressBarState.values) {
    testWidgets('uses the ${state.name} fill token', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          child: SizedBox(
            width: 342,
            child: TsaiProgressBar(value: 0.6, state: state),
          ),
        ),
      );

      final fill = find.byKey(const ValueKey('tsai-progress-fill'));
      final fillDecoration = find.descendant(
        of: fill,
        matching: find.byType(DecoratedBox),
      );
      expect(
        tester.getSize(fillDecoration).width,
        closeTo(tester.getSize(fill).width * 0.6, 0.1),
      );
      final decoration = tester.widget<DecoratedBox>(fillDecoration);
      final colors = TsaiThemeTokens.dark.colors;
      expect((decoration.decoration as BoxDecoration).color, switch (state) {
        TsaiProgressBarState.normal => colors.actionPrimary,
        TsaiProgressBarState.success => colors.accentSuccess,
        TsaiProgressBarState.error => colors.accentError,
      });
    });
  }

  testWidgets('reports determinate progress semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const _TestApp(
        child: SizedBox(
          width: 342,
          child: TsaiProgressBar(value: 0.42, semanticLabel: 'Upload progress'),
        ),
      ),
    );

    final progress = find.bySemanticsLabel('Upload progress');
    expect(progress, findsOneWidget);
    expect(tester.getSemantics(progress).value, '42%');
    semantics.dispose();
  });

  testWidgets('matches all Penpot Spinner sizes', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiSpinner(size: TsaiSpinnerSize.small),
            TsaiSpinner(),
            TsaiSpinner(size: TsaiSpinnerSize.large),
          ],
        ),
      ),
    );

    final spinners = find.byType(TsaiSpinner);
    expect(tester.getSize(spinners.at(0)), const Size.square(16));
    expect(tester.getSize(spinners.at(1)), const Size.square(24));
    expect(tester.getSize(spinners.at(2)), const Size.square(32));
    expect(find.byKey(const ValueKey('tsai-spinner-paint')), findsNWidgets(3));
    expect(find.bySemanticsLabel('Loading'), findsNWidgets(3));
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: TsaiTheme.dark(),
    home: MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}
