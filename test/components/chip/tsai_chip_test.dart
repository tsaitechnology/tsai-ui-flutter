import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('calls tap and delete callbacks', (tester) async {
    var taps = 0;
    var deletes = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(
          body: TsaiChip(
            label: 'USD',
            onTap: () => taps++,
            onDeleted: () => deletes++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('USD'));
    await tester.tap(find.byIcon(Icons.close));
    expect(taps, 1);
    expect(deletes, 1);
  });

  testWidgets('exposes selected semantics and a check glyph', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(
          body: TsaiChip(label: 'EUR', selected: true, showCheck: true),
        ),
      ),
    );

    expect(find.byIcon(Icons.check), findsOneWidget);
    final chipSemantics = tester.getSemantics(find.byType(TsaiChip));
    expect(chipSemantics.label, contains('EUR'));
    expect(chipSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
    semantics.dispose();
  });
}
