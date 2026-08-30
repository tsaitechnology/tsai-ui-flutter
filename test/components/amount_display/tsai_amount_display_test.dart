import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('renders optional caption and subtitle in both themes', (
    tester,
  ) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: TsaiAmountDisplay(
              caption: 'Total balance',
              value: '\$24,562.80',
              subtitle: '+2.2% this month',
            ),
          ),
        ),
      );

      expect(find.text('Total balance'), findsOneWidget);
      expect(find.text('\$24,562.80'), findsOneWidget);
      expect(find.text('+2.2% this month'), findsOneWidget);
    }
  });

  testWidgets('hides optional layers and centers the transfer variant', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(
          body: SizedBox(
            width: 300,
            child: TsaiAmountDisplay(
              value: '\$80.00',
              alignment: TsaiAmountAlignment.center,
            ),
          ),
        ),
      ),
    );

    expect(find.text('\$80.00'), findsOneWidget);
    final column = tester.widget<Column>(
      find.byKey(const ValueKey<String>('tsai-amount-display')),
    );
    expect(column.crossAxisAlignment, CrossAxisAlignment.center);
  });
}
