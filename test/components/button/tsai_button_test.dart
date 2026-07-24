import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('renders all variants in both sizes and themes', (tester) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      for (final variant in TsaiButtonVariant.values) {
        for (final size in TsaiButtonSize.values) {
          await _pump(
            tester,
            theme: theme,
            child: TsaiButton(
              label: 'Action',
              variant: variant,
              size: size,
              onPressed: () {},
            ),
          );

          expect(find.text('Action'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      }
    }
  });

  testWidgets('uses Penpot dimensions and typography', (tester) async {
    await _pump(
      tester,
      child: TsaiButton(
        label: 'Button',
        onPressed: () {},
        leadingIcon: const TsaiIcon.custom(SizedBox.shrink(), size: 16),
      ),
    );

    var button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.style!.minimumSize!.resolve({}), const Size(0, 56));
    expect(
      button.style!.padding!.resolve({}),
      const EdgeInsetsDirectional.only(start: 20, end: 24),
    );
    expect(button.style!.textStyle!.resolve({})!.fontSize, 16);

    await _pump(
      tester,
      child: TsaiButton(
        label: 'Button',
        size: TsaiButtonSize.medium,
        onPressed: () {},
      ),
    );

    button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.style!.minimumSize!.resolve({}), const Size(0, 40));
    expect(
      button.style!.padding!.resolve({}),
      const EdgeInsetsDirectional.only(start: 16, end: 20),
    );
    expect(button.style!.textStyle!.resolve({})!.fontSize, 14);
  });

  testWidgets('uses the Penpot icon gaps for both sizes', (tester) async {
    const gapKey = ValueKey<String>('tsai-button-layout-gap');
    const marginKey = ValueKey<String>('tsai-button-text-margin');
    const leadingKey = ValueKey<String>('test-leading-icon');
    const spinnerKey = ValueKey<String>('tsai-button-spinner');
    Future<(double?, double, double)> gapsFor(
      TsaiButtonSize size, {
      bool loading = false,
    }) async {
      await _pump(
        tester,
        child: TsaiButton(
          label: 'Button',
          size: size,
          isLoading: loading,
          leadingIcon: const TsaiIcon.custom(
            SizedBox.shrink(),
            key: leadingKey,
            size: 16,
          ),
          onPressed: () {},
        ),
      );
      final layoutGap = tester.widget<SizedBox>(find.byKey(gapKey)).width;
      final textMargin = tester
          .widget<Padding>(find.byKey(marginKey))
          .padding
          .resolve(TextDirection.ltr)
          .left;
      final iconToText =
          tester.getTopLeft(find.text('Button')).dx -
          tester.getTopRight(find.byKey(loading ? spinnerKey : leadingKey)).dx;
      return (layoutGap, textMargin, iconToText);
    }

    expect(await gapsFor(TsaiButtonSize.large), (4, 4, 8));
    expect(await gapsFor(TsaiButtonSize.large, loading: true), (4, 4, 8));
    expect(await gapsFor(TsaiButtonSize.medium), (0, 4, 4));
    expect(await gapsFor(TsaiButtonSize.medium, loading: true), (0, 4, 4));
  });

  testWidgets('text margin centers a label-only button', (tester) async {
    for (final size in TsaiButtonSize.values) {
      await _pump(
        tester,
        child: TsaiButton(label: 'Button', size: size, onPressed: () {}),
      );

      expect(
        find.byKey(const ValueKey<String>('tsai-button-layout-gap')),
        findsNothing,
      );
      expect(
        tester.getCenter(find.text('Button')).dx,
        closeTo(tester.getCenter(find.byType(TextButton)).dx, 0.01),
      );
    }
  });

  testWidgets('smoothly transitions the background color on hover', (
    tester,
  ) async {
    const backgroundKey = ValueKey<String>('tsai-button-animated-background');
    await _pump(
      tester,
      child: TsaiButton(label: 'Button', onPressed: () {}),
    );
    final buttonFinder = find.byType(TextButton);
    final initialSize = tester.getSize(buttonFinder);
    final initialColor = _animatedBackgroundColor(tester, backgroundKey);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(buttonFinder));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));

    final midColor = _animatedBackgroundColor(tester, backgroundKey);
    final hoveredColor = TsaiThemeTokens.dark.colors.actionPrimaryPressed;
    expect(midColor, isNot(initialColor));
    expect(midColor, isNot(hoveredColor));
    expect(tester.getSize(buttonFinder), initialSize);

    await tester.pump(const Duration(milliseconds: 70));
    expect(_animatedBackgroundColor(tester, backgroundKey), hoveredColor);
  });

  testWidgets('outline and ghost hover animate only surface opacity', (
    tester,
  ) async {
    const backgroundKey = ValueKey<String>('tsai-button-animated-background');
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      final surface = theme.extension<TsaiThemeTokens>()!.colors.surface;
      for (final variant in [
        TsaiButtonVariant.outline,
        TsaiButtonVariant.ghost,
      ]) {
        await _pump(
          tester,
          theme: theme,
          child: TsaiButton(
            key: UniqueKey(),
            label: 'Button',
            variant: variant,
            onPressed: () {},
          ),
        );
        await tester.pumpAndSettle();

        expect(
          _animatedBackgroundColor(tester, backgroundKey),
          surface.withValues(alpha: 0),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer();
        await mouse.moveTo(tester.getCenter(find.byType(TextButton)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 70));

        final midColor = _animatedBackgroundColor(tester, backgroundKey)!;
        expect(midColor.a, greaterThan(0));
        expect(midColor.a, lessThan(surface.a));
        expect(midColor.r, closeTo(surface.r, 0.001));
        expect(midColor.g, closeTo(surface.g, 0.001));
        expect(midColor.b, closeTo(surface.b, 0.001));
        await mouse.removePointer();
      }
    }
  });

  testWidgets('disables interaction transitions when animations are disabled', (
    tester,
  ) async {
    final theme = TsaiTheme.dark(
      base: ThemeData(
        extensions: const [
          TsaiButtonTheme(
            primary: ButtonStyle(animationDuration: Duration(seconds: 1)),
          ),
        ],
      ),
    );
    await _pump(
      tester,
      theme: theme,
      disableAnimations: true,
      child: TsaiButton(label: 'Button', onPressed: () {}),
    );

    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.style!.animationDuration, Duration.zero);
  });

  testWidgets('animates component-theme background overrides', (tester) async {
    const overrideColor = Color(0xFF00A884);
    final theme = TsaiTheme.dark(
      base: ThemeData(
        extensions: const [
          TsaiButtonTheme(
            primary: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(overrideColor),
            ),
          ),
        ],
      ),
    );
    const backgroundKey = ValueKey<String>('tsai-button-animated-background');

    await _pump(
      tester,
      theme: theme,
      child: TsaiButton(label: 'Button', onPressed: () {}),
    );

    expect(_animatedBackgroundColor(tester, backgroundKey), overrideColor);
  });

  testWidgets('spinner animates without changing button width', (tester) async {
    const spinnerKey = ValueKey<String>('tsai-button-spinner');
    const buttonKey = ValueKey<String>('button');
    await _pump(
      tester,
      child: TsaiButton(
        key: buttonKey,
        label: 'Button',
        leadingIcon: const TsaiIcon.custom(SizedBox.shrink(), size: 16),
        onPressed: () {},
      ),
    );
    final defaultWidth = tester.getSize(find.byKey(buttonKey)).width;

    await _pump(
      tester,
      child: TsaiButton(
        key: buttonKey,
        label: 'Button',
        isLoading: true,
        leadingIcon: const TsaiIcon.custom(SizedBox.shrink(), size: 16),
        onPressed: () {},
      ),
    );
    final loadingWidth = tester.getSize(find.byKey(buttonKey)).width;
    final spinner = tester.widget<RotationTransition>(find.byKey(spinnerKey));
    final initialTurn = spinner.turns.value;

    await tester.pump(const Duration(milliseconds: 212));

    expect(loadingWidth, defaultWidth);
    expect(spinner.turns.value, isNot(initialTurn));
  });

  testWidgets('invokes callback exactly once', (tester) async {
    var calls = 0;
    await _pump(
      tester,
      child: TsaiButton(label: 'Action', onPressed: () => calls++),
    );

    await tester.tap(find.byType(TsaiButton));
    await tester.pump();

    expect(calls, 1);
  });

  testWidgets('disabled and loading buttons reject activation', (tester) async {
    var calls = 0;
    await _pump(
      tester,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TsaiButton(label: 'Disabled', onPressed: null),
          TsaiButton(
            label: 'Loading',
            isLoading: true,
            onPressed: () => calls++,
          ),
        ],
      ),
    );

    await tester.tap(find.text('Disabled'));
    await tester.tap(find.text('Loading'));
    await tester.pump();

    expect(calls, 0);
    expect(
      find.byKey(const ValueKey<String>('tsai-button-spinner')),
      findsOneWidget,
    );
  });

  testWidgets('supports keyboard activation', (tester) async {
    var calls = 0;
    await _pump(
      tester,
      child: TsaiButton(
        label: 'Keyboard action',
        autofocus: true,
        onPressed: () => calls++,
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(calls, 1);
  });

  testWidgets('medium button keeps an accessible tap target', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(
      tester,
      child: TsaiButton(
        label: 'Action',
        size: TsaiButtonSize.medium,
        onPressed: () {},
      ),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('custom semantic label replaces descendant label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _pump(
      tester,
      child: TsaiButton(
        label: 'Visible',
        semanticLabel: 'Accessible action',
        onPressed: () {},
      ),
    );

    expect(find.bySemanticsLabel('Accessible action'), findsOneWidget);
    handle.dispose();
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  ThemeData? theme,
  bool disableAnimations = false,
}) => tester.pumpWidget(
  MaterialApp(
    theme: theme ?? TsaiTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);

Color? _animatedBackgroundColor(
  WidgetTester tester,
  ValueKey<String> backgroundKey,
) {
  final decoration =
      tester
              .widget<DecoratedBox>(
                find.descendant(
                  of: find.byKey(backgroundKey),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .decoration
          as ShapeDecoration;
  return decoration.color;
}
