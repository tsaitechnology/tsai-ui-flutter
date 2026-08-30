import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('emits digits, decimal, and backspace in decimal mode', (
    tester,
  ) async {
    final digits = <String>[];
    var decimals = 0;
    var deletes = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(
          body: TsaiNumericKeypad(
            onDigit: digits.add,
            onDecimal: () => decimals++,
            onBackspace: () => deletes++,
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey<String>('tsai-numeric-keypad'))),
      const Size(358, 240),
    );
    await tester.tap(find.text('5'));
    await tester.tap(find.text('.'));
    await tester.tap(find.bySemanticsLabel('Delete'));
    await tester.pump();
    expect(digits, ['5']);
    expect(decimals, 1);
    expect(deletes, 1);
    semantics.dispose();
  });

  testWidgets('hides the decimal key in integer mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: TsaiNumericKeypad(
            mode: TsaiKeypadMode.integer,
            onDigit: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('.'), findsNothing);
  });

  testWidgets('routes the biometric key in pin mode', (tester) async {
    var biometrics = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: TsaiNumericKeypad(
            mode: TsaiKeypadMode.pin,
            onDigit: (_) {},
            onBiometric: () => biometrics++,
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Biometric unlock'));
    await tester.pump();
    expect(biometrics, 1);
    expect(find.text('.'), findsNothing);
    semantics.dispose();
  });
}
