import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('hides the body until expanded in both themes', (tester) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: TsaiAccordion(
              title: 'Fees',
              body: 'No hidden fees.',
              expanded: false,
            ),
          ),
        ),
      );

      expect(find.text('Fees'), findsOneWidget);
      expect(find.text('No hidden fees.'), findsNothing);
      expect(find.byType(TsaiDivider), findsNothing);
    }
  });

  testWidgets('shows the body and divider when expanded', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(
          body: TsaiAccordion(
            title: 'Fees',
            body: 'No hidden fees.',
            expanded: true,
            showDivider: true,
          ),
        ),
      ),
    );

    expect(find.text('No hidden fees.'), findsOneWidget);
    expect(find.byType(TsaiDivider), findsOneWidget);
  });

  testWidgets('toggles through onChanged and ignores taps when uncontrolled', (
    tester,
  ) async {
    var next = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(
          body: TsaiAccordion(
            title: 'Fees',
            body: 'No hidden fees.',
            expanded: false,
            onChanged: (value) => next = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Fees'));
    await tester.pump();
    expect(next, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: const Scaffold(
          body: TsaiAccordion(
            title: 'Fees',
            body: 'No hidden fees.',
            expanded: false,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Fees'));
    await tester.pump();
    expect(find.text('No hidden fees.'), findsNothing);
  });
}
