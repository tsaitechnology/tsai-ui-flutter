import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/catalog_app.dart';
import 'package:tsai_ui_example/features/buttons/button_demo.dart';
import 'package:tsai_ui_example/features/inputs/input_demo.dart';
import 'package:tsai_ui_example/features/select/select_demo.dart';
import 'package:tsai_ui_example/features/selection_controls/selection_controls_demo.dart';
import 'package:tsai_ui_example/features/typography/typography_demo.dart';
import 'package:tsai_ui_example/features/typography/typography_widget_demo_screen.dart';

void main() {
  testWidgets('navigates full entity screens and switches theme', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogApp());

    expect(find.text('Typography'), findsOneWidget);
    expect(find.text('Inter / Heading'), findsOneWidget);
    expect(find.text('headingExtraLarge'), findsOneWidget);
    expect(find.text('Make every decision visible'), findsNWidgets(4));

    await tester.tap(find.byTooltip('Use light theme'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Use dark theme'), findsOneWidget);

    await tester.tap(find.text('Buttons'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);

    final buttonScroll = find.descendant(
      of: find.byKey(const ValueKey<String>('button-demo')),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Without icon'),
      400,
      scrollable: buttonScroll,
    );
    expect(find.text('Without icon'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Disabled'),
      400,
      scrollable: buttonScroll,
    );
    expect(find.text('Disabled'), findsOneWidget);
  });

  for (final role in TypographyWidgetRole.values) {
    testWidgets('opens ${role.label} from its documentation route', (
      tester,
    ) async {
      await tester.pumpWidget(CatalogApp(initialRoute: role.route));
      await tester.pumpAndSettle();

      expect(
        find.byKey(ValueKey<String>('${role.name}-widget-demo')),
        findsOneWidget,
      );
      expect(find.text(role.label), findsOneWidget);
    });
  }

  testWidgets('opens TsaiIcon from its documentation route', (tester) async {
    await tester.pumpWidget(const CatalogApp(initialRoute: '/icons'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('icon-demo')), findsOneWidget);
    expect(find.text('TsaiIcon'), findsOneWidget);
  });

  testWidgets('renders the typography demo without the catalog window', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpEmbedded(tester, child: TypographyDemo(controller: controller));

    expect(find.text('Inter / Heading'), findsOneWidget);
    expect(find.text('Typography'), findsNothing);
    expect(
      tester
          .widget<CustomScrollView>(
            find.byKey(const ValueKey<String>('typography-demo')),
          )
          .controller,
      same(controller),
    );
    await _scrollToPlayground(tester);
    expect(
      find.byKey(const ValueKey<String>('component-playground-preview')),
      findsOneWidget,
    );
  });

  testWidgets('renders the button demo without the catalog window', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpEmbedded(tester, child: ButtonDemo(controller: controller));

    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Typography'), findsNothing);
    expect(
      tester
          .widget<CustomScrollView>(
            find.byKey(const ValueKey<String>('button-demo')),
          )
          .controller,
      same(controller),
    );
    await _scrollToPlayground(tester);
    expect(
      find.byKey(const ValueKey<String>('component-playground-preview')),
      findsOneWidget,
    );
  });

  testWidgets('renders the checkbox demo with a playground', (tester) async {
    await _pumpEmbedded(tester, child: const CheckboxDemo());

    await tester.scrollUntilVisible(
      find.text('Checkbox Multiline (example)'),
      400,
      scrollable: find.byType(Scrollable),
    );
    final multilineLabel = find.text(
      'I agree to the Terms of Service\nand acknowledge the Privacy Policy',
    );
    expect(tester.getSize(multilineLabel).height, greaterThan(20));

    await _scrollToPlayground(tester);
    expect(
      find.byKey(const ValueKey<String>('component-playground-preview')),
      findsOneWidget,
    );
    expect(find.byType(TsaiCheckbox), findsWidgets);
    expect(find.byType(TsaiRadio<String>), findsNothing);

    await tester.enterText(find.byType(TextFormField).first, 'Runtime label');
    await tester.pump();
    expect(find.text('Runtime label'), findsWidgets);
  });

  testWidgets('renders the radio demo independently', (tester) async {
    await _pumpEmbedded(tester, child: const RadioDemo());

    expect(find.byType(TsaiRadio<String>), findsWidgets);
    expect(find.byType(TsaiCheckbox), findsNothing);
  });

  testWidgets('renders the switch demo independently', (tester) async {
    await _pumpEmbedded(tester, child: const SwitchDemo());

    expect(find.byType(TsaiSwitch), findsWidgets);
    expect(find.byType(TsaiCheckbox), findsNothing);
  });

  testWidgets('renders and opens the select demo', (tester) async {
    await _pumpEmbedded(tester, child: const SelectDemo());

    expect(find.byType(TsaiSelect<String>), findsWidgets);
    final field = find.byKey(const ValueKey<String>('tsai-select-field')).first;
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(find.text('Second option'), findsWidgets);

    await tester.tap(find.text('Second option').last);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: field, matching: find.text('Second option')),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: field, matching: find.byTooltip('Clear selection')),
    );
    await tester.pump();
    expect(
      find.descendant(of: field, matching: find.text('Option')),
      findsOneWidget,
    );
  });

  testWidgets('renders the input demo independently', (tester) async {
    await _pumpEmbedded(tester, child: const InputDemo());

    expect(find.byType(TsaiInput), findsWidgets);
    expect(find.byType(TsaiPhoneInput), findsNothing);
  });

  testWidgets('renders the phone input demo independently', (tester) async {
    await _pumpEmbedded(tester, child: const PhoneInputDemo());

    expect(find.byType(TsaiPhoneInput), findsWidgets);
    expect(find.byType(TsaiInput), findsNothing);
  });

  testWidgets('configures OTP length 4 and 6 in the playground', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const OtpInputDemo());

    await _scrollToPlayground(tester);
    final control = tester.widget<SegmentedButton<int>>(
      find.byType(SegmentedButton<int>),
    );
    expect(control.segments.map((segment) => segment.value), [4, 6]);
    expect(find.byType(TsaiOtpInput), findsWidgets);

    await tester.tap(find.text('6'));
    await tester.pump();
    expect(
      tester.widget<TsaiOtpInput>(find.byType(TsaiOtpInput).first).length,
      6,
    );
  });

  testWidgets('configures PIN length 4 and 6 in the playground', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const PinInputDemo());

    await _scrollToPlayground(tester);
    final control = tester.widget<SegmentedButton<int>>(
      find.byType(SegmentedButton<int>),
    );
    expect(control.segments.map((segment) => segment.value), [4, 6]);
    expect(find.byType(TsaiPinInput), findsWidgets);

    await tester.tap(find.text('6'));
    await tester.pump();
    expect(
      tester.widget<TsaiPinInput>(find.byType(TsaiPinInput).first).length,
      6,
    );
  });
}

Future<void> _scrollToPlayground(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Playground'),
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpEmbedded(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: child),
      ),
    );
