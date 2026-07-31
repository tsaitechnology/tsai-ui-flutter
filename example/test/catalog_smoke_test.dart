import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/catalog_app.dart';
import 'package:tsai_ui_example/features/buttons/button_demo.dart';
import 'package:tsai_ui_example/features/bottom_nav_bar/bottom_nav_bar_demo.dart';
import 'package:tsai_ui_example/features/inputs/input_demo.dart';
import 'package:tsai_ui_example/features/links/link_demo.dart';
import 'package:tsai_ui_example/features/select/select_demo.dart';
import 'package:tsai_ui_example/features/selection_controls/selection_controls_demo.dart';
import 'package:tsai_ui_example/features/tabs/tabs_demo.dart';
import 'package:tsai_ui_example/features/top_bars/top_bar_demo.dart';
import 'package:tsai_ui_example/features/typography/typography_demo.dart';
import 'package:tsai_ui_example/features/typography/typography_widget_demo_screen.dart';
import 'package:tsai_ui_example/main.dart';

void main() {
  testWidgets('renders the pub.dev quick start and opens the catalog', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogApp(home: QuickStartExample()));

    expect(find.text('Create your workspace'), findsOneWidget);
    expect(find.byType(TsaiInput), findsOneWidget);
    expect(find.byType(TsaiCheckbox), findsOneWidget);

    final createButton = tester.widget<TsaiButton>(
      find.widgetWithText(TsaiButton, 'Create workspace'),
    );
    expect(createButton.onPressed, isNull);

    await tester.tap(find.byType(TsaiCheckbox));
    await tester.pump();
    expect(
      tester
          .widget<TsaiButton>(
            find.widgetWithText(TsaiButton, 'Create workspace'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Browse the component catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);

    await tester.tap(find.byTooltip('Open component menu').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Common'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);

    await tester.tap(find.text('TsaiTextHeading'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.byKey(const ValueKey<String>('heading-widget-demo')),
      findsOneWidget,
    );
  });

  testWidgets('switches theme from the header and opens the drawer', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogApp());

    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.byType(HomeTopBar), findsOneWidget);

    await tester.tap(find.byTooltip('Use light theme'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byTooltip('Use dark theme'), findsOneWidget);

    await tester.tap(find.byTooltip('Open component menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Common'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);

    await tester.tap(find.text('TsaiTextHeading'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.byKey(const ValueKey<String>('heading-widget-demo')),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Open component menu').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Buttons'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('keeps the catalog header usable at 320 pixels', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const CatalogApp(initialRoute: '/typography/mono-heading'),
    );
    await tester.pump();

    expect(find.text('TsaiTextMonoHeading'), findsOneWidget);
    expect(find.byTooltip('Use light theme'), findsOneWidget);
    expect(find.byTooltip('Open component menu'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Open component menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Drawer), findsOneWidget);
    expect(tester.takeException(), isNull);
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
      expect(find.text(role.label), findsWidgets);
    });
  }

  testWidgets('opens TsaiIcon from its documentation route', (tester) async {
    await tester.pumpWidget(const CatalogApp(initialRoute: '/icons'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('icon-demo')), findsOneWidget);
    expect(find.text('Icons'), findsOneWidget);
  });

  testWidgets('opens separate top-bar documentation routes', (tester) async {
    await tester.pumpWidget(const CatalogApp(initialRoute: '/top-bars/home'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeTopBarDemo), findsOneWidget);
    expect(find.byType(HomeTopBar), findsWidgets);

    await tester.pumpWidget(
      const CatalogApp(
        key: ValueKey<String>('page-with-top-bar-app'),
        initialRoute: '/top-bars/page-layout',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PageWithTopBarDemo), findsOneWidget);
    expect(find.byType(PageWithTopBar), findsWidgets);
  });

  testWidgets('opens four bottom-nav-bar backdrop examples', (tester) async {
    await tester.pumpWidget(const CatalogApp(initialRoute: '/bottom-nav-bar'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavBarDemo), findsOneWidget);
    expect(find.text('1 destination'), findsOneWidget);
    expect(find.byType(BottomNavBar), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('4 destinations'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('4 destinations'), findsOneWidget);
    expect(find.byType(BottomNavBar), findsWidgets);
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

  testWidgets('renders the link demo without the catalog window', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const LinkDemo());

    expect(find.byType(TsaiLink), findsWidgets);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
  });

  testWidgets('renders document-owned tab content independently', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const TabsDocumentDemo());

    expect(
      find.byKey(const ValueKey<String>('tabs-document-demo')),
      findsOneWidget,
    );
    expect(find.byType(TsaiTabs), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('renders internally scrolling tab content independently', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const TabsViewportDemo());

    expect(
      find.byKey(const ValueKey<String>('tabs-viewport-demo')),
      findsOneWidget,
    );
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('renders the sticky tabs composition independently', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const TabsStickyDemo());

    expect(
      find.byKey(const ValueKey<String>('tabs-sticky-demo')),
      findsOneWidget,
    );
    expect(find.byType(TsaiSliverTabBar), findsOneWidget);
    expect(find.byType(CustomScrollView), findsOneWidget);
  });

  testWidgets('renders the checkbox demo with a playground', (tester) async {
    await _pumpEmbedded(tester, child: const CheckboxDemo());

    await tester.scrollUntilVisible(
      find.text('Checkbox Multiline (example)'),
      400,
      scrollable: find.byType(Scrollable),
    );
    final multilineLabel = find.text(
      'I agree to the Terms of Service and acknowledge the Privacy Policy',
    );
    expect(tester.getSize(multilineLabel).height, greaterThan(20));
    expect(tester.getSize(multilineLabel).height, lessThan(40));

    await _scrollToPlayground(tester);
    expect(
      find.byKey(const ValueKey<String>('component-playground-preview')),
      findsOneWidget,
    );
    expect(find.byType(TsaiCheckbox), findsWidgets);
    expect(find.byType(TsaiRadio<String>), findsNWidgets(3));
    expect(find.byType(SegmentedButton<String>), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey<String>('tsai-input-editable')).first,
      'Runtime label',
    );
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
      find.descendant(of: field, matching: find.text('Label')),
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
    final controls = tester
        .widgetList<TsaiRadio<int>>(find.byType(TsaiRadio<int>))
        .toList();
    expect(controls.map((control) => control.value), [4, 6]);
    expect(find.byType(SegmentedButton<int>), findsNothing);
    expect(find.byType(TsaiOtpInput), findsWidgets);

    final six = find.byWidgetPredicate(
      (widget) => widget is TsaiRadio<int> && widget.value == 6,
    );
    await tester.ensureVisible(six);
    await tester.pumpAndSettle();
    await tester.tap(six);
    await tester.pump();
    expect(
      tester
          .widget<TsaiOtpInput>(
            find.descendant(
              of: find.byKey(
                const ValueKey<String>('component-playground-preview'),
              ),
              matching: find.byType(TsaiOtpInput),
            ),
          )
          .length,
      6,
    );
  });

  testWidgets('configures PIN length 4 and 6 in the playground', (
    tester,
  ) async {
    await _pumpEmbedded(tester, child: const PinInputDemo());

    await _scrollToPlayground(tester);
    final controls = tester
        .widgetList<TsaiRadio<int>>(find.byType(TsaiRadio<int>))
        .toList();
    expect(controls.map((control) => control.value), [4, 6]);
    expect(find.byType(SegmentedButton<int>), findsNothing);
    expect(find.byType(TsaiPinInput), findsWidgets);

    final six = find.byWidgetPredicate(
      (widget) => widget is TsaiRadio<int> && widget.value == 6,
    );
    await tester.ensureVisible(six);
    await tester.pumpAndSettle();
    await tester.tap(six);
    await tester.pump();
    expect(
      tester
          .widget<TsaiPinInput>(
            find.descendant(
              of: find.byKey(
                const ValueKey<String>('component-playground-preview'),
              ),
              matching: find.byType(TsaiPinInput),
            ),
          )
          .length,
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
        theme: TsaiTheme.dark(
          base: ThemeData(splashFactory: NoSplash.splashFactory),
        ),
        home: Scaffold(body: child),
      ),
    );
