import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('paints a hairline that respects directional insets', (
    tester,
  ) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: SizedBox(
              width: 342,
              child: TsaiDivider(indent: 16, endIndent: 8),
            ),
          ),
        ),
      );

      final line = find.byKey(const ValueKey<String>('tsai-divider'));
      expect(tester.getSize(line).height, 1);
      expect(tester.getSize(line).width, 342 - 16 - 8);
    }
  });

  testWidgets('mirrors insets in RTL', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        builder: (context, child) =>
            Directionality(textDirection: TextDirection.rtl, child: child!),
        home: const Scaffold(
          body: SizedBox(
            width: 342,
            child: TsaiDivider(indent: 16, endIndent: 8),
          ),
        ),
      ),
    );

    final line = tester.getRect(
      find.byKey(const ValueKey<String>('tsai-divider')),
    );
    expect(line.left, 8);
    expect(line.right, 342 - 16);
  });
}
