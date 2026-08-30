import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('renders badge variants and counter clamping', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Row(
          children: [
            TsaiBadge(label: 'Ready', showDot: true),
            TsaiBadgeCounter(value: 120),
            TsaiBadgeDot(),
          ],
        ),
      ),
    );
    expect(find.text('Ready'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.byType(TsaiBadgeDot), findsOneWidget);
    expect(tester.getSize(find.byType(TsaiBadgeCounter)).width, lessThan(50));
  });

  testWidgets('counter keeps its compact height in a tall bounded parent', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(
          body: SizedBox.expand(
            child: Center(child: TsaiBadgeCounter(value: 3)),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiBadgeCounter)).height, 18);
  });
}
