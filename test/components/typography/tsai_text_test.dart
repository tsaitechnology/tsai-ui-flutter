import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('maps every typography widget to its Penpot text role', (
    tester,
  ) async {
    final type = TsaiThemeTokens.light.typography;
    final cases = <(TsaiText, TextStyle)>[
      (
        const TsaiHeading('Text', size: TsaiHeadingSize.extraLarge),
        type.headingExtraLarge,
      ),
      (
        const TsaiHeading('Text', size: TsaiHeadingSize.large),
        type.headingLarge,
      ),
      (
        const TsaiHeading('Text', size: TsaiHeadingSize.medium),
        type.headingMedium,
      ),
      (
        const TsaiHeading('Text', size: TsaiHeadingSize.small),
        type.headingSmall,
      ),
      (
        const TsaiBody(
          'Text',
          size: TsaiBodySize.large,
          weight: TsaiTextWeight.medium,
        ),
        type.bodyLargeMedium,
      ),
      (
        const TsaiBody(
          'Text',
          size: TsaiBodySize.large,
          weight: TsaiTextWeight.regular,
        ),
        type.bodyLarge,
      ),
      (
        const TsaiBody(
          'Text',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.medium,
        ),
        type.bodyMediumMedium,
      ),
      (
        const TsaiBody(
          'Text',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.regular,
        ),
        type.bodyMedium,
      ),
      (
        const TsaiButtonText('Text', size: TsaiButtonTextSize.large),
        type.buttonLarge,
      ),
      (
        const TsaiButtonText('Text', size: TsaiButtonTextSize.medium),
        type.buttonMedium,
      ),
      (
        const TsaiCaption(
          'Text',
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.medium,
        ),
        type.captionMedium,
      ),
      (
        const TsaiCaption(
          'Text',
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.regular,
        ),
        type.captionMediumRegular,
      ),
      (
        const TsaiCaption(
          'Text',
          size: TsaiCaptionSize.small,
          weight: TsaiTextWeight.medium,
        ),
        type.captionSmall,
      ),
      (
        const TsaiCaption(
          'Text',
          size: TsaiCaptionSize.small,
          weight: TsaiTextWeight.regular,
        ),
        type.captionSmallRegular,
      ),
      (
        const TsaiMonoHeading('Text', size: TsaiMonoHeadingSize.extraLarge),
        type.monoHeadingExtraLarge,
      ),
      (
        const TsaiMonoHeading('Text', size: TsaiMonoHeadingSize.large),
        type.monoHeadingLarge,
      ),
      (
        const TsaiMonoBody('Text', size: TsaiBodySize.large),
        type.monoBodyLarge,
      ),
      (
        const TsaiMonoBody('Text', size: TsaiBodySize.medium),
        type.monoBodyMedium,
      ),
      (
        const TsaiMonoCaption('Text', weight: TsaiTextWeight.medium),
        type.monoCaption,
      ),
      (
        const TsaiMonoCaption('Text', weight: TsaiTextWeight.regular),
        type.monoCaptionRegular,
      ),
    ];

    for (final (widget, expected) in cases) {
      await _pump(tester, child: widget);

      final actual = tester.widget<Text>(find.byType(Text)).style!;
      expect(actual.fontFamily, expected.fontFamily);
      expect(actual.fontSize, expected.fontSize);
      expect(actual.fontWeight, expected.fontWeight);
      expect(actual.height, expected.height);
    }
  });

  testWidgets('uses the active semantic content color', (tester) async {
    const text = TsaiHeading('Text', size: TsaiHeadingSize.large);

    await _pump(tester, child: text);
    expect(
      tester.widget<Text>(find.byType(Text)).style!.color,
      TsaiThemeTokens.light.colors.contentPrimary,
    );

    await _pump(tester, theme: TsaiTheme.dark(), child: text);
    expect(
      tester.widget<Text>(find.byType(Text)).style!.color,
      TsaiThemeTokens.dark.colors.contentPrimary,
    );
  });

  testWidgets('forwards controlled Text behavior and semantics', (
    tester,
  ) async {
    const color = Color(0xFF00A884);
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: const TsaiBody(
        'Visible text',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
        color: color,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: false,
        textScaler: TextScaler.noScaling,
        semanticsLabel: 'Accessible text',
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.style!.color, color);
    expect(text.textAlign, TextAlign.end);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 2);
    expect(text.softWrap, isFalse);
    expect(text.textScaler, TextScaler.noScaling);
    expect(find.bySemanticsLabel('Accessible text'), findsOneWidget);
    semantics.dispose();
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  ThemeData? theme,
}) => tester.pumpWidget(
  MaterialApp(
    theme: theme ?? TsaiTheme.light(),
    themeAnimationDuration: Duration.zero,
    home: Scaffold(body: child),
  ),
);
