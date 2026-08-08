import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
    testWidgets('uses the theme glow token and Penpot geometry', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Center(child: TsaiGlow()),
        ),
      );

      expect(tester.getSize(find.byType(TsaiGlow)), const Size.square(480));
      final source = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey('tsai-glow-source')),
      );
      final decoration = source.decoration as BoxDecoration;
      final expected = theme.extension<TsaiThemeTokens>()!.colors.accentGlow;
      expect(decoration.color, expected);
      expect(decoration.shape, BoxShape.circle);
      expect(find.byKey(const ValueKey('tsai-glow-filter')), findsOneWidget);
    });
  }

  testWidgets('is decorative and ignores interaction', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Center(child: TsaiGlow(diameter: 200, blurRadius: 40)),
      ),
    );

    expect(tester.getSize(find.byType(TsaiGlow)), const Size.square(200));
    final glow = find.byType(TsaiGlow);
    final ignorePointer = find.descendant(
      of: glow,
      matching: find.byType(IgnorePointer),
    );
    expect(tester.widget<IgnorePointer>(ignorePointer).ignoring, isTrue);
    expect(
      find.descendant(of: glow, matching: find.byType(ExcludeSemantics)),
      findsOneWidget,
    );
  });
}
