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
}
