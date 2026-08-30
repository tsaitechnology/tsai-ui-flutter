import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('increments and decrements within bounds', (tester) async {
    var value = 1;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => TsaiStepper(
              value: value,
              min: 0,
              max: 2,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.byType(TsaiIcon).last);
    await tester.pump();
    expect(value, 2);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byType(TsaiIcon).last);
    await tester.pump();
    expect(value, 2);

    await tester.tap(find.byType(TsaiIcon).first);
    await tester.pump();
    expect(value, 1);

    semantics.dispose();
  });

  testWidgets('blocks both controls when onChanged is null', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(body: TsaiStepper(value: 5)),
      ),
    );

    expect(tester.getSemantics(find.byType(TsaiStepper)).label, contains('5'));
    expect(find.bySemanticsLabel('Increase'), findsNothing);
    expect(find.bySemanticsLabel('Decrease'), findsNothing);
    expect(find.text('5'), findsOneWidget);
    semantics.dispose();
  });
}
