import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  group('TsaiThemeTokens', () {
    test('contains the Penpot light and dark color values', () {
      expect(TsaiThemeTokens.light.colors.canvas, const Color(0xFFFAFAFA));
      expect(
        TsaiThemeTokens.light.colors.contentPrimary,
        const Color(0xFF1D1D1E),
      );
      expect(TsaiThemeTokens.dark.colors.canvas, const Color(0xFF0A0A0B));
      expect(
        TsaiThemeTokens.dark.colors.contentPrimary,
        const Color(0xFFECECEC),
      );
      expect(
        TsaiThemeTokens.light.colors.actionPrimary,
        const Color(0xFF6366F1),
      );
      expect(
        TsaiThemeTokens.dark.colors.actionPrimary,
        const Color(0xFF6366F1),
      );
    });

    test('uses the same complete schema for both themes', () {
      final light = TsaiThemeTokens.light;
      final dark = TsaiThemeTokens.dark;

      expect(light.runtimeType, dark.runtimeType);
      expect(light.spacing.space80, dark.spacing.space80);
      expect(light.radii.pill, dark.radii.pill);
      expect(light.borders.hairline, dark.borders.hairline);
      expect(light.motion.interaction, dark.motion.interaction);
      expect(
        light.typography.buttonLarge.fontSize,
        dark.typography.buttonLarge.fontSize,
      );
    });

    test('copyWith only replaces requested groups', () {
      final source = TsaiThemeTokens.light;
      final result = source.copyWith(colors: TsaiThemeTokens.dark.colors);

      expect(result.colors, same(TsaiThemeTokens.dark.colors));
      expect(result.typography, same(source.typography));
      expect(result.spacing, same(source.spacing));
      expect(result.radii, same(source.radii));
      expect(result.borders, same(source.borders));
      expect(result.shadows, same(source.shadows));
      expect(result.motion, same(source.motion));
    });

    test('lerp preserves endpoints and interpolates values', () {
      final light = TsaiThemeTokens.light;
      final dark = TsaiThemeTokens.dark;

      expect(light.lerp(dark, 0), same(light));
      expect(light.lerp(dark, 1), same(dark));
      expect(
        light.lerp(dark, 0.5).colors.canvas,
        Color.lerp(light.colors.canvas, dark.colors.canvas, 0.5),
      );
      expect(
        light.lerp(dark, 0.5).motion.interaction,
        const Duration(milliseconds: 140),
      );
    });
  });

  testWidgets('TsaiTheme installs tokens and preserves other extensions', (
    tester,
  ) async {
    const marker = _MarkerTheme('consumer-owned');
    final theme = TsaiTheme.light(base: ThemeData(extensions: const [marker]));
    late TsaiThemeTokens resolved;

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) {
            resolved = TsaiThemeTokens.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(resolved, same(TsaiThemeTokens.light));
    expect(theme.extension<_MarkerTheme>(), marker);
  });
}

final class _MarkerTheme extends ThemeExtension<_MarkerTheme> {
  const _MarkerTheme(this.value);

  final String value;

  @override
  _MarkerTheme copyWith({String? value}) => _MarkerTheme(value ?? this.value);

  @override
  _MarkerTheme lerp(covariant _MarkerTheme? other, double t) =>
      t < 0.5 || other == null ? this : other;
}
