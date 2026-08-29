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
    surfaceSkeleton: Color(0xFFE6E7EE),
    surfaceGlass: Color(0xCCEFEFF1),
    textPrimary: Color(0xFF1D1D1E),
    textAccent: Color(0xFF4F46E5),
    textSecondary: Color(0xFF6A6A6B),
    textTertiary: Color(0xFF9A9A9A),
    borderHairline: Color(0xFFE1E2EB),
    borderStrong: Color(0xFFD4D4D4),
    borderGuide: Color(0xFFB4B5C0),
    accentLight: Color(0xFF818CF8),
    accent: Color(0xFF6366F1),
    accentDeep: Color(0xFF4F46E5),
    accentMuted: Color(0xFFD8D9FB),
    accentHalo: Color(0x336366F1),
    surfaceInverted: Color(0xFF26262B),
    textInvertedPrimary: Color(0xFFF4F4F5),
    textInvertedSecondary: Color(0xFFA6A6AD),
    semanticAccentInfo: Color(0xFF3B82F6),
    semanticAccentSuccess: Color(0xFF10B981),
    semanticAccentError: Color(0xFFEF4444),
    semanticSolidError: Color(0xFFEF4444),
    semanticSolidErrorDeep: Color(0xFFDC2626),
    semanticTextError: Color(0xFFDC2626),
    semanticAccentWarning: Color(0xFFF59E0B),
    semanticSurfaceInfo: Color(0xFFEBF0FA),
    semanticSurfaceSuccess: Color(0xFFE8F5F1),
    semanticSurfaceError: Color(0xFFF9ECEC),
    semanticSurfaceWarning: Color(0xFFFAF3E7),
    semanticBorderInfo: Color(0xFFC8DAF9),
    semanticBorderSuccess: Color(0xFFBDE9DB),
    semanticBorderError: Color(0xFFF7CACA),
    semanticBorderWarning: Color(0xFFF9E2BB),
    textOnAccentPrimary: Color(0xFFFFFFFF),
    textOnAccentSecondary: Color(0xFFC8C9FA),
    iconPrimary: Color(0xFF0A0A0B),
    iconSecondary: Color(0xFF838099),
    iconTertiary: Color(0xFFA6A6A6),
    iconOnAccent: Color(0xFFFFFFFF),
    iconBright: Color(0xFF6366F1),
    surfaceIndigo: Color(0xFFF2F3FE),
    surfaceIndigoDeep: Color(0xFFE9EAFD),
    surfaceIndigoGlass: Color(0xCCCACFEE),
    surfaceIndigoGlassDim: Color(0x4DE4E7FA),
    backgroundOverlay: Color(0x66000000),
    accentGlow: Color(0x33C7D2FE),
  );

  static const darkColors = TsaiReferenceColors(
    background: Color(0xFF0A0A0B),
    backgroundGlass: Color(0xCC0A0A0B),
    surface1: Color(0xFF15161F),
    surface2: Color(0xFF1C1C20),
    surfaceSkeleton: Color(0xFF1C1C20),
    surfaceGlass: Color(0xCC141416),
    textPrimary: Color(0xFFECECEC),
    textAccent: Color(0xFFA5B4FC),
    textSecondary: Color(0xFF9D9D9D),
    textTertiary: Color(0xFF6C6C6D),
    borderHairline: Color(0xFF24252E),
    borderStrong: Color(0xFF3F3F42),
    borderGuide: Color(0xFF4A4B52),
    accentLight: Color(0xFF818CF8),
    accent: Color(0xFF6366F1),
    accentDeep: Color(0xFF4F46E5),
    accentMuted: Color(0xFF323365),
    accentHalo: Color(0x336366F1),
    surfaceInverted: Color(0xFFECECEC),
    textInvertedPrimary: Color(0xFF17171A),
    textInvertedSecondary: Color(0xFF5D5D66),
    semanticAccentInfo: Color(0xFF60A5FA),
    semanticAccentSuccess: Color(0xFF34D399),
    semanticAccentError: Color(0xFFF87171),
    semanticSolidError: Color(0xFFEF4444),
    semanticSolidErrorDeep: Color(0xFFDC2626),
    semanticTextError: Color(0xFFFCA5A5),
    semanticAccentWarning: Color(0xFFFBBF24),
    semanticSurfaceInfo: Color(0xFF141D28),
    semanticSurfaceSuccess: Color(0xFF0F221C),
    semanticSurfaceError: Color(0xFF271717),
    semanticSurfaceWarning: Color(0xFF27200E),
    semanticBorderInfo: Color(0xFF263E5A),
    semanticBorderSuccess: Color(0xFF184C3A),
    semanticBorderError: Color(0xFF592D2D),
    semanticBorderWarning: Color(0xFF5A4613),
    textOnAccentPrimary: Color(0xFFFFFFFF),
    textOnAccentSecondary: Color(0xFFC8C9FA),
    iconPrimary: Color(0xFFFFFFFF),
    iconSecondary: Color(0xFF7F7D8B),
    iconTertiary: Color(0xFF636364),
    iconOnAccent: Color(0xFFFFFFFF),
    iconBright: Color(0xFFA5B4FC),
    surfaceIndigo: Color(0xFF1E1F33),
    surfaceIndigoDeep: Color(0xFF26284A),
    surfaceIndigoGlass: Color(0xCC31345E),
    surfaceIndigoGlassDim: Color(0x4D31345E),
    backgroundOverlay: Color(0x99000000),
    accentGlow: Color(0x1A6366F1),
  );
}

@immutable
final class TsaiReferenceColors {
  const TsaiReferenceColors({
    required this.background,
    required this.backgroundGlass,
    required this.surface1,
    required this.surface2,
    required this.surfaceSkeleton,
    required this.surfaceGlass,
    required this.textPrimary,
    required this.textAccent,
    required this.textSecondary,
    required this.textTertiary,
    required this.borderHairline,
    required this.borderStrong,
    required this.borderGuide,
    required this.accentLight,
    required this.accent,
    required this.accentDeep,
    required this.accentMuted,
    required this.accentHalo,
    required this.surfaceInverted,
    required this.textInvertedPrimary,
    required this.textInvertedSecondary,
    required this.semanticAccentInfo,
    required this.semanticAccentSuccess,
    required this.semanticAccentError,
    required this.semanticSolidError,
    required this.semanticSolidErrorDeep,
    required this.semanticTextError,
    required this.semanticAccentWarning,
    required this.semanticSurfaceInfo,
    required this.semanticSurfaceSuccess,
    required this.semanticSurfaceError,
    required this.semanticSurfaceWarning,
    required this.semanticBorderInfo,
    required this.semanticBorderSuccess,
    required this.semanticBorderError,
    required this.semanticBorderWarning,
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
    required this.surfaceIndigoGlassDim,
    required this.backgroundOverlay,
    required this.accentGlow,
  });

  final Color background;
  final Color backgroundGlass;
  final Color surface1;
  final Color surface2;
  final Color surfaceSkeleton;
  final Color surfaceGlass;
  final Color textPrimary;
  final Color textAccent;
  final Color textSecondary;
  final Color textTertiary;
  final Color borderHairline;
  final Color borderStrong;
  final Color borderGuide;
  final Color accentLight;
  final Color accent;
  final Color accentDeep;
  final Color accentMuted;
  final Color accentHalo;
  final Color surfaceInverted;
  final Color textInvertedPrimary;
  final Color textInvertedSecondary;
  final Color semanticAccentInfo;
  final Color semanticAccentSuccess;
  final Color semanticAccentError;
  final Color semanticSolidError;
  final Color semanticSolidErrorDeep;
  final Color semanticTextError;
  final Color semanticAccentWarning;
  final Color semanticSurfaceInfo;
  final Color semanticSurfaceSuccess;
  final Color semanticSurfaceError;
  final Color semanticSurfaceWarning;
  final Color semanticBorderInfo;
  final Color semanticBorderSuccess;
  final Color semanticBorderError;
  final Color semanticBorderWarning;
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
  final Color surfaceIndigoGlassDim;
  final Color backgroundOverlay;
  final Color accentGlow;
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
