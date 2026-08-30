import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('keeps the Penpot face size and optional overlays', (
    tester,
  ) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: TsaiBankCard()),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey<String>('tsai-bank-card'))),
        const Size(342, 214),
      );
      expect(find.text('tsaitech'), findsOneWidget);
      expect(find.text('•••• 4821'), findsOneWidget);
      expect(find.text('VISA'), findsOneWidget);
    }
  });

  testWidgets('hides optional layers when they are null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(
          body: TsaiBankCard(
            wordmark: null,
            showContactless: false,
            number: null,
            network: null,
          ),
        ),
      ),
    );

    expect(find.text('tsaitech'), findsNothing);
    expect(find.text('•••• 4821'), findsNothing);
    expect(find.text('VISA'), findsNothing);
  });
}
