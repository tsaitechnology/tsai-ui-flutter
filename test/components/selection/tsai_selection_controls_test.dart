import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('checkbox cycles values and renders Penpot states', (
    tester,
  ) async {
    bool? value = false;
    await _pump(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) => TsaiCheckbox(
          value: value,
          tristate: true,
          label: 'Terms',
          onChanged: (next) => setState(() => value = next),
        ),
      ),
    );

    expect(_box(tester).decoration, isA<BoxDecoration>());
    expect(_boxDecoration(tester).borderRadius, BorderRadius.circular(6));
    expect(_boxDecoration(tester).color, TsaiThemeTokens.dark.colors.surface);
    expect(find.byKey(const ValueKey('tsai-checkbox-checked')), findsNothing);

    await tester.tap(find.byType(TsaiCheckbox));
    await tester.pumpAndSettle();
    expect(value, isTrue);
    expect(
      _boxDecoration(tester).color,
      TsaiThemeTokens.dark.colors.actionPrimary,
    );
    expect(find.byKey(const ValueKey('tsai-checkbox-checked')), findsOneWidget);

    await tester.tap(find.byType(TsaiCheckbox));
    await tester.pumpAndSettle();
    expect(value, isNull);
    expect(
      find.byKey(const ValueKey('tsai-checkbox-indeterminate')),
      findsOneWidget,
    );

    await tester.tap(find.byType(TsaiCheckbox));
    await tester.pumpAndSettle();
    expect(value, isFalse);
  });

  testWidgets('radio selects its value and exposes group semantics', (
    tester,
  ) async {
    String? selected;
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) => TsaiRadio<String>(
          value: 'usd',
          groupValue: selected,
          label: 'USD',
          onChanged: (value) => setState(() => selected = value),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-radio-box'))),
      const Size(20, 20),
    );
    expect(find.byKey(const ValueKey('tsai-radio-dot')), findsOneWidget);
    expect(
      tester
          .widget<AnimatedScale>(
            find.ancestor(
              of: find.byKey(const ValueKey('tsai-radio-dot')),
              matching: find.byType(AnimatedScale),
            ),
          )
          .scale,
      0,
    );

    await tester.tap(find.byType(TsaiRadio<String>));
    await tester.pumpAndSettle();
    expect(selected, 'usd');
    expect(
      tester
          .widget<AnimatedScale>(
            find.ancestor(
              of: find.byKey(const ValueKey('tsai-radio-dot')),
              matching: find.byType(AnimatedScale),
            ),
          )
          .scale,
      1,
    );
    expect(find.bySemanticsLabel('USD'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('switch toggles with pointer and keyboard', (tester) async {
    var value = false;
    await _pump(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) => TsaiSwitch(
          value: value,
          label: 'Alerts',
          autofocus: true,
          onChanged: (next) => setState(() => value = next),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-switch-track'))),
      const Size(36, 20),
    );
    expect(
      tester
          .widget<AnimatedAlign>(
            find.ancestor(
              of: find.byKey(const ValueKey('tsai-switch-thumb')),
              matching: find.byType(AnimatedAlign),
            ),
          )
          .alignment,
      AlignmentDirectional.centerStart,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(value, isTrue);

    await tester.tap(find.byType(TsaiSwitch));
    await tester.pumpAndSettle();
    expect(value, isFalse);
  });

  testWidgets('disabled controls reject activation and use disabled colors', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TsaiCheckbox(value: false, onChanged: null, label: 'Checkbox'),
          TsaiRadio<int>(
            value: 1,
            groupValue: null,
            onChanged: null,
            label: 'Radio',
          ),
          TsaiSwitch(value: true, onChanged: null, label: 'Switch'),
        ],
      ),
    );

    expect(
      _boxDecoration(tester).color,
      TsaiThemeTokens.dark.colors.surfaceRaised,
    );
    final switchDecoration =
        tester
                .widget<AnimatedContainer>(
                  find.byKey(const ValueKey('tsai-switch-track')),
                )
                .decoration
            as BoxDecoration;
    expect(switchDecoration.color, TsaiThemeTokens.dark.colors.surfaceRaised);

    await tester.tap(find.text('Checkbox'));
    await tester.tap(find.text('Radio'));
    await tester.tap(find.text('Switch'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports label position, descriptions, focus events, and RTL', (
    tester,
  ) async {
    final focusEvents = <bool>[];
    await _pump(
      tester,
      textDirection: TextDirection.rtl,
      child: TsaiCheckbox(
        value: false,
        label: 'Label',
        description: 'Description',
        labelPosition: TsaiControlLabelPosition.left,
        autofocus: true,
        onFocusChange: focusEvents.add,
        onChanged: (_) {},
      ),
    );
    await tester.pump();

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(focusEvents, contains(true));
    expect(
      tester.getTopLeft(find.text('Label')).dx,
      greaterThan(
        tester.getTopLeft(find.byKey(const ValueKey('tsai-checkbox-box'))).dx,
      ),
    );
  });

  testWidgets('uses a minimum accessible tap target', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: TsaiSwitch(value: false, label: 'Setting', onChanged: (_) {}),
    );

    expect(
      tester.getSize(find.byType(TsaiSwitch)).height,
      greaterThanOrEqualTo(48),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });
}

AnimatedContainer _box(WidgetTester tester) => tester.widget<AnimatedContainer>(
  find.byKey(const ValueKey('tsai-checkbox-box')),
);

BoxDecoration _boxDecoration(WidgetTester tester) =>
    _box(tester).decoration! as BoxDecoration;

Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  TextDirection textDirection = TextDirection.ltr,
}) => tester.pumpWidget(
  MaterialApp(
    theme: TsaiTheme.dark(),
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);
