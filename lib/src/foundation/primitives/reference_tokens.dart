// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

abstract final class TsaiReferenceTokens {
  static const lightGradients = TsaiReferenceGradients(
    topScrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xCCFAFAFA), Color(0x00FAFAFA)],
    ),
    bottomScrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x00FAFAFA), Color(0xCCFAFAFA)],
    ),
  );

  static const darkGradients = TsaiReferenceGradients(
    topScrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xCC0A0A0B), Color(0x000A0A0B)],
    ),
    bottomScrim: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x000A0A0B), Color(0xCC0A0A0B)],
    ),
  );

  static const lightColors = TsaiReferenceColors(
    background: Color(0xFFFAFAFA),
    backgroundGlass: Color(0xCCFAFAFA),
    surface1: Color(0xFFFFFFFF),
    surface2: Color(0xFFF4F4F5),
    surfaceGlass: Color(0xCCEFEFF1),
    textPrimary: Color(0xFF1D1D1E),
    textAccent: Color(0xFF4F46E5),
    textSecondary: Color(0xFF6A6A6B),
    textTertiary: Color(0xFF9A9A9A),
    borderHairline: Color(0xFFE2E2E2),
    borderStrong: Color(0xFFD4D4D4),
    accentLight: Color(0xFF818CF8),
    accent: Color(0xFF6366F1),
    accentDeep: Color(0xFF4F46E5),
    gain: Color(0xFF10B981),
    loss: Color(0xFFEF4444),
    textOnAccentPrimary: Color(0xFFFFFFFF),
    textOnAccentSecondary: Color(0xFFC8C9FA),
    iconPrimary: Color(0xFF0A0A0B),
    iconSecondary: Color(0xFF767677),
    iconTertiary: Color(0xFFA6A6A6),
    iconOnAccent: Color(0xFFFFFFFF),
    iconBright: Color(0xFF97A4FA),
    surfaceIndigo: Color(0xFFF2F3FE),
    surfaceIndigoDeep: Color(0xFFE9EAFD),
    surfaceIndigoGlass: Color(0xCCCACFEE),
  );

  static const darkColors = TsaiReferenceColors(
    background: Color(0xFF0A0A0B),
    backgroundGlass: Color(0xCC0A0A0B),
    surface1: Color(0xFF141416),
    surface2: Color(0xFF1C1C20),
    surfaceGlass: Color(0xCC141416),
    textPrimary: Color(0xFFECECEC),
    textAccent: Color(0xFFA5B4FC),
    textSecondary: Color(0xFF9D9D9D),
    textTertiary: Color(0xFF6C6C6D),
    borderHairline: Color(0xFF232324),
    borderStrong: Color(0xFF3F3F42),
    accentLight: Color(0xFF818CF8),
    accent: Color(0xFF6366F1),
    accentDeep: Color(0xFF4F46E5),
    gain: Color(0xFF34D399),
    loss: Color(0xFFF87171),
    textOnAccentPrimary: Color(0xFFFFFFFF),
    textOnAccentSecondary: Color(0xFFC8C9FA),
    iconPrimary: Color(0xFFFFFFFF),
    iconSecondary: Color(0xFF919191),
    iconTertiary: Color(0xFF636364),
    iconOnAccent: Color(0xFFFFFFFF),
    iconBright: Color(0xFFA5B4FC),
    surfaceIndigo: Color(0xFF1E1F33),
    surfaceIndigoDeep: Color(0xFF26284A),
    surfaceIndigoGlass: Color(0xCC31345E),
  );
}

@immutable
final class TsaiReferenceColors {
  const TsaiReferenceColors({
    required this.background,
    required this.backgroundGlass,
    required this.surface1,
    required this.surface2,
    required this.surfaceGlass,
    required this.textPrimary,
    required this.textAccent,
    required this.textSecondary,
    required this.textTertiary,
    required this.borderHairline,
    required this.borderStrong,
    required this.accentLight,
    required this.accent,
    required this.accentDeep,
    required this.gain,
    required this.loss,
    required this.textOnAccentPrimary,
    required this.textOnAccentSecondary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconOnAccent,
    required this.iconBright,
    required this.surfaceIndigo,
    required this.surfaceIndigoDeep,
    required this.surfaceIndigoGlass,
  });

  final Color background;
  final Color backgroundGlass;
  final Color surface1;
  final Color surface2;
  final Color surfaceGlass;
  final Color textPrimary;
  final Color textAccent;
  final Color textSecondary;
  final Color textTertiary;
  final Color borderHairline;
  final Color borderStrong;
  final Color accentLight;
  final Color accent;
  final Color accentDeep;
  final Color gain;
  final Color loss;
  final Color textOnAccentPrimary;
  final Color textOnAccentSecondary;
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconOnAccent;
  final Color iconBright;
  final Color surfaceIndigo;
  final Color surfaceIndigoDeep;
  final Color surfaceIndigoGlass;
}

@immutable
final class TsaiReferenceGradients {
  const TsaiReferenceGradients({
    required this.topScrim,
    required this.bottomScrim,
  });

  final LinearGradient topScrim;
  final LinearGradient bottomScrim;
}
