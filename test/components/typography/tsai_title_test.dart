import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('uses title, subtitle, color, and spacing tokens', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const TsaiTitle('Portfolio', subtitle: 'Main account'),
    );

    final title = tester.widget<Text>(find.text('Portfolio'));
    final subtitle = tester.widget<Text>(find.text('Main account'));
    final titleFinder = find.byType(TsaiTitle);
    final gap = tester.widget<SizedBox>(
      find.descendant(
        of: titleFinder,
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 4,
        ),
      ),
    );
    final tokens = TsaiThemeTokens.light;

    expect(title.style!.fontSize, tokens.typography.headingExtraLarge.fontSize);
    expect(title.style!.fontWeight, FontWeight.w600);
    expect(title.style!.color, tokens.colors.contentPrimary);
    expect(subtitle.style!.fontSize, tokens.typography.bodyMedium.fontSize);
    expect(subtitle.style!.fontWeight, tokens.typography.bodyMedium.fontWeight);
    expect(subtitle.style!.color, tokens.colors.contentSecondary);
    expect(gap.height, tokens.spacing.space4);
  });

  testWidgets('omits subtitle and gap when supporting text is absent', (
    tester,
  ) async {
    await _pump(tester, child: const TsaiTitle('Portfolio'));

    expect(find.text('Portfolio'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(TsaiTitle),
        matching: find.byType(SizedBox),
      ),
      findsNothing,
    );
    expect(
      find.descendant(of: find.byType(TsaiTitle), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(body: child),
      ),
    );
