import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/catalog_app.dart';
import 'package:tsai_ui_example/demo/component_demo_window.dart';
import 'package:tsai_ui_example/demo/component_playground.dart';
import 'package:tsai_ui_example/features/app_examples/multi_screen_app_example.dart';
import 'package:tsai_ui_example/features/buttons/button_demo.dart';
import 'package:tsai_ui_example/features/bottom_nav_bar/bottom_nav_bar_demo.dart';
import 'package:tsai_ui_example/features/inputs/input_demo.dart';
import 'package:tsai_ui_example/features/links/link_demo.dart';
import 'package:tsai_ui_example/features/select/select_demo.dart';
import 'package:tsai_ui_example/features/selection_controls/selection_controls_demo.dart';
import 'package:tsai_ui_example/features/top_bars/top_bar_demo.dart';
import 'package:tsai_ui_example/features/typography/typography_demo.dart';
import 'package:tsai_ui_example/features/typography/typography_widget_demo_screen.dart';
import 'package:tsai_ui_example/features/ui_blocks/ui_blocks_demo.dart';
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
    expect(find.text('Playground'), findsOneWidget);

    await tester.tap(find.byTooltip('Open component menu').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Common'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -400));
    await tester.pump();
    expect(find.text('Typography'), findsOneWidget);

    await tester.ensureVisible(find.text('TsaiTextHeading'));
    await tester.pump(const Duration(milliseconds: 400));
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
    expect(find.text('Playground'), findsOneWidget);
    expect(find.byType(HomeTopBar), findsOneWidget);

    await tester.tap(find.byTooltip('Use light theme'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byTooltip('Use dark theme'), findsOneWidget);

    await tester.tap(find.byTooltip('Open component menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Common'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -400));
    await tester.pump();
    expect(find.text('Typography'), findsOneWidget);

    await tester.ensureVisible(find.text('TsaiTextHeading'));
    await tester.pump(const Duration(milliseconds: 400));
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

  testWidgets('fills the desktop viewport below the catalog header', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CatalogApp(initialRoute: '/buttons'));
    await tester.pump();

    final header = tester.getRect(find.byType(HomeTopBar));
    final playground = tester.getRect(
      find.byKey(const ValueKey<String>('component-playground')),
    );
    expect(playground.top, header.bottom + 24);
    expect(playground.bottom, 900 - 24);
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

  testWidgets(
    'aligns the catalog title and theme action in the shared header',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const CatalogApp(initialRoute: '/input-phone'));
      await tester.pump();

      final header = tester.getRect(find.byType(HomeTopBar));
      final title = tester.getRect(
        find.descendant(
          of: find.byType(HomeTopBar),
          matching: find.text('Phone Input'),
        ),
      );
      expect(title.left, greaterThanOrEqualTo(header.left));
      expect(title.right, lessThanOrEqualTo(header.right));
      expect(title.top, greaterThanOrEqualTo(header.top));
      expect(title.bottom, lessThanOrEqualTo(header.bottom));
      expect(find.byTooltip('Use light theme'), findsOneWidget);
      expect(find.byType(TsaiSwitch), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byTooltip('Use light theme'));
      await tester.pump();
      expect(find.byTooltip('Use dark theme'), findsOneWidget);
    },
  );

  testWidgets('every component route has one desktop playground', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _verifyComponentRoutes(
      tester,
      sizeLabel: 'desktop',
      controlsVisible: true,
    );
  });

  testWidgets('every component route has one mobile playground', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _verifyComponentRoutes(
      tester,
      sizeLabel: 'mobile',
      controlsVisible: false,
    );
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

  for (final section in [
    ComponentDemoSection.tsaiIcon,
    ComponentDemoSection.hitIcon,
    ComponentDemoSection.circleIcon,
    ComponentDemoSection.cryptoIcon,
    ComponentDemoSection.avatar,
    ComponentDemoSection.userPill,
  ]) {
    testWidgets('opens ${section.label} from its documentation route', (
      tester,
    ) async {
      await tester.pumpWidget(CatalogApp(initialRoute: section.route));
      await tester.pumpAndSettle();

      expect(
        find.byKey(ValueKey<String>('${section.name}-demo')),
        findsOneWidget,
      );
      expect(find.text(section.label), findsWidgets);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey<String>('component-playground')),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('component-playground')),
        findsOneWidget,
      );
    });
  }

  for (final section in [
    ComponentDemoSection.sectionHeader,
    ComponentDemoSection.emptyState,
    ComponentDemoSection.listItem,
    ComponentDemoSection.list,
  ]) {
    testWidgets('opens ${section.label} from its UI Blocks route', (
      tester,
    ) async {
      await tester.pumpWidget(CatalogApp(initialRoute: section.route));
      await tester.pumpAndSettle();

      expect(find.byType(UIBlocksDemo), findsOneWidget);
      expect(find.text(section.label), findsWidgets);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey<String>('component-playground')),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('component-playground')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final section in [
    ComponentDemoSection.toast,
    ComponentDemoSection.inlineAlert,
    ComponentDemoSection.progress,
    ComponentDemoSection.skeleton,
    ComponentDemoSection.card,
    ComponentDemoSection.pageIndicator,
    ComponentDemoSection.numericKeypad,
    ComponentDemoSection.actionTile,
    ComponentDemoSection.slider,
    ComponentDemoSection.stepper,
    ComponentDemoSection.bankCard,
    ComponentDemoSection.amountDisplay,
    ComponentDemoSection.divider,
    ComponentDemoSection.accordion,
  ]) {
    testWidgets('opens ${section.label} in its playground', (tester) async {
      await tester.pumpWidget(CatalogApp(initialRoute: section.route));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        find.byKey(ValueKey<String>('${section.name}-demo')),
        findsOneWidget,
      );
      expect(find.text(section.label), findsWidgets);
      expect(
        find.byKey(const ValueKey<String>('component-playground')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

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

  testWidgets('opens the configurable bottom-nav-bar playground', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogApp(initialRoute: '/bottom-nav-bar'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavBarDemo), findsOneWidget);
    expect(find.byType(ComponentPlayground), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
    final countControl = tester.widget<PlaygroundSelectControl<int>>(
      find.byType(PlaygroundSelectControl<int>),
    );
    expect(countControl.values, const [1, 2, 3, 4, 5]);
  });

  testWidgets('multi-screen app covers complete business flows', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Future<void> pumpUi() async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    await tester.pumpWidget(
      const CatalogApp(initialRoute: '/app-examples/multi-screen'),
    );
    await pumpUi();

    expect(find.byType(MultiScreenAppExample), findsOneWidget);
    expect(find.byType(HomeScreenExample), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(find.byType(TsaiList), findsOneWidget);
    expect(find.byType(TsaiListItem), findsNWidgets(7));
    expect(find.byType(IndexedStack), findsOneWidget);

    final scroll = tester.getRect(
      find.byKey(const ValueKey<String>('home-screen-scroll')),
    );
    final homeBar = tester.getRect(find.byType(HomeTopBar));
    final navigation = tester.getRect(find.byType(BottomNavBar));
    expect(scroll.top, homeBar.top);
    expect(scroll.bottom, greaterThan(navigation.top));

    final homeSelect = tester.widget<TsaiSelect<String>>(
      find.byKey(const ValueKey<String>('home-country-select')),
    );
    expect(homeSelect.presentation, TsaiSelectPresentation.adaptive);

    expect(find.byType(TsaiAmountDisplay), findsWidgets);
    expect(find.byType(TsaiActionTile), findsWidgets);
    expect(find.byType(TsaiBankCard), findsWidgets);
    expect(find.byType(TsaiPageIndicator), findsWidgets);

    await tester.tap(find.byKey(const ValueKey<String>('quick-transfer')));
    await pumpUi();
    expect(find.text('Transfer money'), findsOneWidget);
    expect(find.byType(TsaiNumericKeypad), findsWidgets);
    await tester.tap(find.text('Cancel'));
    await pumpUi();

    await tester.tap(find.byKey(const ValueKey<String>('quick-pay')));
    await pumpUi();
    expect(find.byType(PurchaseScreenExample), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Home'));
    await pumpUi();

    await tester.drag(
      find.byKey(const ValueKey<String>('home-screen-scroll')),
      const Offset(0, -360),
    );
    await tester.pump();
    final balance = tester.getRect(
      find.byKey(const ValueKey<String>('home-balance-summary')),
    );
    expect(balance.top, lessThan(homeBar.bottom));
    expect(balance.bottom, greaterThan(homeBar.top));
    await tester.tap(find.byKey(const ValueKey<String>('home-country-select')));
    await pumpUi();
    expect(
      find.byKey(const ValueKey<String>('tsai-select-bottom-sheet')),
      findsOneWidget,
    );
    expect(find.byType(BottomNavBar), findsOneWidget);
    await tester.tapAt(const Offset(8, 8));
    await pumpUi();

    await tester.tap(find.bySemanticsLabel('Account'));
    await tester.pump();
    expect(find.byType(FormScreenExample), findsOneWidget);
    expect(find.byType(PageWithTopBar), findsOneWidget);
    expect(find.byType(TsaiAccordion), findsWidgets);
    expect(find.byType(TsaiSlider), findsWidgets);
    expect(
      find.byKey(const ValueKey<String>('first-name-input')),
      findsOneWidget,
    );
    final formSelect = tester.widget<TsaiSelect<String>>(
      find.byKey(const ValueKey<String>('form-country-select')),
    );
    expect(formSelect.presentation, TsaiSelectPresentation.adaptive);
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.bySemanticsLabel('Verify'));
    await tester.pump();
    expect(find.byType(KycScreenExample), findsOneWidget);
    expect(find.byType(TsaiCard), findsOneWidget);
    expect(find.byType(TsaiInlineAlert), findsWidgets);
    expect(find.byType(TsaiProgressBar), findsOneWidget);
    expect(find.byType(TsaiPhoneInput), findsOneWidget);
    expect(find.byType(TsaiStepper), findsWidgets);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.bySemanticsLabel('Pay'));
    await tester.pump();
    expect(find.byType(PurchaseScreenExample), findsOneWidget);
    expect(find.text('Send money'), findsOneWidget);
    expect(find.byType(TsaiSearchInput), findsOneWidget);
    expect(find.byType(TsaiNumericKeypad), findsWidgets);
    expect(find.byType(TsaiLink), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lists the composed app example in the catalog drawer', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogApp());
    await tester.tap(find.byTooltip('Open component menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.scrollUntilVisible(
      find.text('Multi-screen app example'),
      300,
      scrollable: find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('App examples'), findsOneWidget);
    expect(find.text('Multi-screen app example'), findsOneWidget);
  });

  testWidgets('renders the typography demo without the catalog window', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpEmbedded(tester, child: TypographyDemo(controller: controller));

    expect(find.byType(ComponentPlayground), findsOneWidget);
    expect(find.text('Typography'), findsNothing);
    expect(
      tester
          .widget<ListView>(
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

    expect(find.byType(ComponentPlayground), findsOneWidget);
    expect(find.text('Typography'), findsNothing);
    expect(
      tester
          .widget<ListView>(find.byKey(const ValueKey<String>('button-demo')))
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

    expect(find.byType(ComponentPlayground), findsOneWidget);
    expect(find.byType(TsaiLink), findsOneWidget);
  });

  testWidgets('renders the checkbox demo with a playground', (tester) async {
    await _pumpEmbedded(tester, child: const CheckboxDemo());
    expect(
      find.byKey(const ValueKey<String>('component-playground')),
      findsOneWidget,
    );
    expect(find.textContaining('(example)'), findsNothing);

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
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('component-playground-preview')),
        matching: find.byType(TsaiInput),
      ),
      findsNothing,
    );
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

  for (final demo in <(String, String)>[
    ('/input-search', 'input-search-demo'),
    ('/effects/glow', 'glow-demo'),
    ('/bottom-sheet', 'bottom-sheet-demo'),
    ('/modal-dialog', 'modal-dialog-demo'),
    ('/top-bars/page-search-layout', 'page-with-search-top-bar-demo'),
  ]) {
    testWidgets('opens ${demo.$1} from its documentation route', (
      tester,
    ) async {
      await tester.pumpWidget(CatalogApp(initialRoute: demo.$1));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey<String>(demo.$2)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _verifyComponentRoutes(
  WidgetTester tester, {
  required String sizeLabel,
  required bool controlsVisible,
}) async {
  final sections = ComponentDemoSection.values.where(
    (section) => section.category != ComponentDemoCategory.appExamples,
  );
  for (final section in sections) {
    await tester.pumpWidget(
      CatalogApp(
        key: ValueKey<String>('$sizeLabel-${section.name}'),
        initialRoute: section.route,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      find.byType(ComponentPlayground),
      findsOneWidget,
      reason: '${section.label} must contain exactly one playground',
    );
    expect(
      find.byKey(const ValueKey<String>('component-playground-controls')),
      controlsVisible ? findsOneWidget : findsNothing,
      reason: '${section.label} has the wrong default controls state',
    );
    expect(
      tester.takeException(),
      isNull,
      reason: '${section.label} must render at the $sizeLabel size',
    );
  }
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
