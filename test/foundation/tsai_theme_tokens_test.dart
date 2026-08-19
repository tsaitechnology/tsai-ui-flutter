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
      expect(
        TsaiThemeTokens.light.colors.surfaceGlass,
        const Color(0xCCEFEFF1),
      );
      expect(TsaiThemeTokens.dark.colors.surfaceGlass, const Color(0xCC141416));
      expect(TsaiThemeTokens.light.colors.surface, const Color(0xFFFFFFFF));
      expect(TsaiThemeTokens.dark.colors.surface, const Color(0xFF15161F));
      expect(
        TsaiThemeTokens.light.colors.borderSubtle,
        const Color(0xFFE1E2EB),
      );
      expect(TsaiThemeTokens.dark.colors.borderSubtle, const Color(0xFF24252E));
      expect(
        TsaiThemeTokens.light.colors.overlayScrim,
        const Color(0x66000000),
      );
      expect(TsaiThemeTokens.dark.colors.overlayScrim, const Color(0x99000000));
      expect(TsaiThemeTokens.light.colors.accentGlow, const Color(0x33C7D2FE));
      expect(TsaiThemeTokens.dark.colors.accentGlow, const Color(0x1A6366F1));
      expect(
        TsaiThemeTokens.light.colors.surfaceAccentGlassDim,
        const Color(0x4DE4E7FA),
      );
      expect(
        TsaiThemeTokens.dark.colors.surfaceAccentGlassDim,
        const Color(0x4D31345E),
      );
      expect(
        TsaiThemeTokens.light.colors.surfaceSkeleton,
        const Color(0xFFE6E7EE),
      );
      expect(
        TsaiThemeTokens.dark.colors.surfaceSkeleton,
        const Color(0xFF1C1C20),
      );
      expect(
        TsaiThemeTokens.light.colors.actionDanger,
        const Color(0xFFEF4444),
      );
      expect(
        TsaiThemeTokens.dark.colors.actionDangerPressed,
        const Color(0xFFDC2626),
      );
      expect(
        TsaiThemeTokens.light.colors.contentDanger,
        const Color(0xFFDC2626),
      );
      expect(
        TsaiThemeTokens.dark.colors.contentDanger,
        const Color(0xFFFCA5A5),
      );
      expect(TsaiThemeTokens.light.colors.accentInfo, const Color(0xFF3B82F6));
      expect(TsaiThemeTokens.dark.colors.accentInfo, const Color(0xFF60A5FA));
      expect(
        TsaiThemeTokens.light.colors.accentSuccess,
        const Color(0xFF10B981),
      );
      expect(TsaiThemeTokens.dark.colors.accentError, const Color(0xFFF87171));
      expect(
        TsaiThemeTokens.light.colors.accentWarning,
        const Color(0xFFF59E0B),
      );
      expect(
        TsaiThemeTokens.dark.colors.statusSurfaceInfo,
        const Color(0xFF141D28),
      );
      expect(
        TsaiThemeTokens.light.colors.statusSurfaceSuccess,
        const Color(0xFFE8F5F1),
      );
      expect(
        TsaiThemeTokens.dark.colors.statusSurfaceError,
        const Color(0xFF271717),
      );
      expect(
        TsaiThemeTokens.light.colors.statusSurfaceWarning,
        const Color(0xFFFAF3E7),
      );
      expect(
        TsaiThemeTokens.light.colors.statusBorderInfo,
        const Color(0xFFC8DAF9),
      );
      expect(
        TsaiThemeTokens.dark.colors.statusBorderSuccess,
        const Color(0xFF184C3A),
      );
      expect(
        TsaiThemeTokens.light.colors.statusBorderError,
        const Color(0xFFF7CACA),
      );
      expect(
        TsaiThemeTokens.dark.colors.statusBorderWarning,
        const Color(0xFF5A4613),
      );
      expect(
        TsaiThemeTokens.light.colors.contentAccent,
        const Color(0xFF4F46E5),
      );
      expect(
        TsaiThemeTokens.dark.colors.contentAccent,
        const Color(0xFFA5B4FC),
      );
      expect(TsaiThemeTokens.light.colors.iconBright, const Color(0xFF6366F1));
      expect(TsaiThemeTokens.dark.colors.iconBright, const Color(0xFFA5B4FC));
      expect(
        TsaiThemeTokens.light.colors.iconSecondary,
        const Color(0xFF838099),
      );
      expect(
        TsaiThemeTokens.dark.colors.iconSecondary,
        const Color(0xFF7F7D8B),
      );
      expect(TsaiThemeTokens.light.gradients.topScrim.colors, const [
        Color(0xCCFAFAFA),
        Color(0x00FAFAFA),
      ]);
      expect(TsaiThemeTokens.dark.gradients.bottomScrim.colors, const [
        Color(0x000A0A0B),
        Color(0xCC0A0A0B),
      ]);
    });

    test('uses the same complete schema for both themes', () {
      final light = TsaiThemeTokens.light;
      final dark = TsaiThemeTokens.dark;

      expect(light.runtimeType, dark.runtimeType);
      expect(light.spacing.space12, 12);
      expect(light.spacing.space6, 6);
      expect(light.spacing.space6, dark.spacing.space6);
      expect(light.spacing.space12, dark.spacing.space12);
      expect(light.spacing.space80, dark.spacing.space80);
      expect(light.radii.pill, dark.radii.pill);
      expect(light.radii.innerMedium, 10);
      expect(light.radii.innerMedium, dark.radii.innerMedium);
      expect(light.radii.extraExtraLarge, 32);
      expect(light.radii.extraExtraLarge, dark.radii.extraExtraLarge);
      expect(light.borders.hairline, dark.borders.hairline);
      expect(light.effects.glassBlur, 24);
      expect(light.effects.glassBlur, dark.effects.glassBlur);
      expect(light.motion.interaction, dark.motion.interaction);
      expect(light.motion.progressIndicator, dark.motion.progressIndicator);
      expect(light.motion.transitionCurve, Curves.easeInOut);
      expect(
        light.typography.buttonLarge.fontSize,
        dark.typography.buttonLarge.fontSize,
      );
      expect(light.typography.buttonMedium.fontSize, 12);
      expect(light.typography.bodyLarge.fontWeight, FontWeight.w400);
      expect(light.typography.bodyLarge.letterSpacing, 0);
    });

    test('copyWith only replaces requested groups', () {
      final source = TsaiThemeTokens.light;
      final result = source.copyWith(colors: TsaiThemeTokens.dark.colors);

      expect(result.colors, same(TsaiThemeTokens.dark.colors));
      expect(result.gradients, same(source.gradients));
      expect(result.typography, same(source.typography));
      expect(result.spacing, same(source.spacing));
      expect(result.radii, same(source.radii));
      expect(result.borders, same(source.borders));
      expect(result.shadows, same(source.shadows));
      expect(result.effects, same(source.effects));
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
      expect(
        light.lerp(dark, 0.5).motion.progressIndicator,
        const Duration(milliseconds: 850),
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
