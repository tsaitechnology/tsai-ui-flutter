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
        leadingIcon: const SizedBox.square(dimension: 16),
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
          leadingIcon: const SizedBox.square(key: leadingKey, dimension: 16),
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

  testWidgets('spinner animates without changing button width', (tester) async {
    const spinnerKey = ValueKey<String>('tsai-button-spinner');
    const buttonKey = ValueKey<String>('button');
    await _pump(
      tester,
      child: TsaiButton(
        key: buttonKey,
        label: 'Button',
        leadingIcon: const SizedBox.square(dimension: 16),
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
        leadingIcon: const SizedBox.square(dimension: 16),
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
}) => tester.pumpWidget(
  MaterialApp(
    theme: theme ?? TsaiTheme.dark(),
    home: Scaffold(body: Center(child: child)),
  ),
);
