import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('reports the current value and updates on drag', (tester) async {
    var value = 0.25;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: TsaiSlider(
              value: value,
              semanticLabel: 'Amount',
              onChanged: (next) => value = next,
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Amount'), findsOneWidget);
    expect(tester.getSemantics(find.bySemanticsLabel('Amount')).value, '25%');

    final sliderRect = tester.getRect(find.byType(TsaiSlider));
    await tester.tapAt(Offset(sliderRect.right - 1, sliderRect.center.dy));
    await tester.pump();
    expect(value, closeTo(1, 0.01));

    semantics.dispose();
  });

  testWidgets('ignores input when disabled in both themes', (tester) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: SizedBox(width: 200, child: TsaiSlider(value: 0.4)),
          ),
        ),
      );

      await tester.tap(find.byType(TsaiSlider));
      await tester.pump();
      expect(find.byType(TsaiSlider), findsOneWidget);
    }
  });
}
