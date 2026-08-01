import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  const primary = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Color(0xFF112233)),
  );
  const secondary = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Color(0xFF445566)),
  );

  test('copyWith replaces only requested variant overrides', () {
    const source = TsaiButtonTheme(primary: primary, outline: ButtonStyle());
    final result = source.copyWith(secondary: secondary);

    expect(result.primary, same(source.primary));
    expect(result.secondary, same(secondary));
    expect(result.outline, same(source.outline));
    expect(result.ghost, isNull);
  });

  test('lerp preserves endpoints and interpolates every variant', () {
    const start = TsaiButtonTheme(
      primary: primary,
      secondary: primary,
      outline: primary,
      ghost: primary,
    );
    const end = TsaiButtonTheme(
      primary: secondary,
      secondary: secondary,
      outline: secondary,
      ghost: secondary,
    );

    expect(start.lerp(null, 0.5), same(start));
    expect(start.lerp(end, 0), same(start));
    expect(start.lerp(end, 1), same(end));

    final expected = Color.lerp(
      const Color(0xFF112233),
      const Color(0xFF445566),
      0.5,
    );
    final result = start.lerp(end, 0.5);
    for (final style in [
      result.primary,
      result.secondary,
      result.outline,
      result.ghost,
    ]) {
      expect(style!.backgroundColor!.resolve({}), expected);
    }
  });

  testWidgets('of resolves an installed override or an empty fallback', (
    tester,
  ) async {
    TsaiButtonTheme? installed;
    TsaiButtonTheme? fallback;
    const override = TsaiButtonTheme(primary: primary);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [override]),
        home: Builder(
          builder: (context) {
            installed = TsaiButtonTheme.of(context);
            return Theme(
              data: ThemeData(),
              child: Builder(
                builder: (context) {
                  fallback = TsaiButtonTheme.of(context);
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );

    expect(installed, same(override));
    expect(fallback!.primary, isNull);
    expect(fallback!.secondary, isNull);
    expect(fallback!.outline, isNull);
    expect(fallback!.ghost, isNull);
  });
}
