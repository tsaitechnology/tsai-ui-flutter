import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_icons.dart';

void main() {
  testWidgets('renders different Lucide glyphs through the same adapter', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Row(
          children: [
            TsaiIcon(LucideIcons.search),
            TsaiIcon(LucideIcons.settings, size: 16),
            TsaiIcon(LucideIcons.circle_question_mark, color: Colors.red),
          ],
        ),
      ),
    );

    expect(find.byType(TsaiIcon), findsNWidgets(3));
    expect(find.byType(Icon), findsNWidgets(3));
  });

  testWidgets('renders emoji and custom widgets in the same stable slot', (
    tester,
  ) async {
    const customKey = ValueKey<String>('custom-icon');
    await tester.pumpWidget(
      const MaterialApp(
        home: Row(
          children: [
            TsaiIcon.emoji('🇺🇾', size: 20, semanticLabel: 'Uruguay'),
            TsaiIcon.custom(
              ColoredBox(key: customKey, color: Colors.green),
              size: 20,
              semanticLabel: 'Custom asset',
            ),
          ],
        ),
      ),
    );

    expect(find.text('🇺🇾'), findsOneWidget);
    expect(find.byKey(customKey), findsOneWidget);
    expect(find.bySemanticsLabel('Uruguay'), findsOneWidget);
    expect(find.bySemanticsLabel('Custom asset'), findsOneWidget);
    for (final icon in find.byType(TsaiIcon).evaluate()) {
      expect(tester.getSize(find.byWidget(icon.widget)), const Size.square(20));
    }
  });
}
