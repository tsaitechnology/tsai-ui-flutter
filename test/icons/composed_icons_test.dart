import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('HitIcon keeps a 32 target and configurable inherited icon', (
    tester,
  ) async {
    var presses = 0;
    await _pump(
      tester,
      child: HitIcon(
        icon: const Icon(Icons.search, color: Colors.red),
        iconSize: 18,
        semanticLabel: 'Search',
        onPressed: () => presses++,
      ),
    );

    expect(tester.getSize(find.byType(HitIcon)), const Size.square(32));
    expect(IconTheme.of(tester.element(find.byIcon(Icons.search))).size, 18);
    expect(tester.widget<Icon>(find.byIcon(Icons.search)).color, Colors.red);
    expect(find.bySemanticsLabel('Search'), findsOneWidget);
    expect(find.byType(ColorFiltered), findsNothing);
    expect(
      find.descendant(
        of: find.byType(HitIcon),
        matching: find.byType(Material),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(HitIcon),
        matching: find.byType(InkResponse),
      ),
      findsNothing,
    );

    await tester.tap(find.byType(HitIcon));
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('CircleIcon keeps token-backed 40/20 geometry', (tester) async {
    await _pump(
      tester,
      child: const CircleIcon(
        icon: Icon(Icons.coffee, color: Colors.red),
        semanticLabel: 'Coffee',
      ),
    );

    expect(tester.getSize(find.byType(CircleIcon)), const Size.square(40));
    expect(IconTheme.of(tester.element(find.byIcon(Icons.coffee))).size, 20);
    expect(
      IconTheme.of(tester.element(find.byIcon(Icons.coffee))).color,
      TsaiThemeTokens.dark.colors.iconSecondary,
    );
    final decoration = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(CircleIcon),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect(
      (decoration.decoration as BoxDecoration).color,
      TsaiThemeTokens.dark.colors.surfaceRaised,
    );
    expect(find.bySemanticsLabel('Coffee'), findsOneWidget);
    final filter = tester.widget<ColorFiltered>(find.byType(ColorFiltered));
    expect(
      filter.colorFilter,
      ColorFilter.mode(
        TsaiThemeTokens.dark.colors.iconSecondary,
        BlendMode.srcIn,
      ),
    );
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
