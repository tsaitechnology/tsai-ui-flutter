import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('announces the active page and sizes the active pill', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(body: TsaiPageIndicator(count: 5, index: 2)),
      ),
    );

    expect(find.bySemanticsLabel('Page 3 of 5'), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsNWidgets(5));
    semantics.dispose();
  });

  testWidgets('widens only the active dot in both themes', (tester) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: TsaiPageIndicator(count: 3, index: 0)),
        ),
      );

      final dots = find.byType(AnimatedContainer);
      expect(tester.getSize(dots.at(0)).width, 24);
      expect(tester.getSize(dots.at(1)).width, 8);
      expect(tester.getSize(dots.at(2)).width, 8);
    }
  });
}
