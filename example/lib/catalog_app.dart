import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import 'demo/component_demo_window.dart';
import 'features/accordion/accordion_demo_screen.dart';
import 'features/action_tile/action_tile_demo_screen.dart';
import 'features/amount_display/amount_display_demo_screen.dart';
import 'features/app_examples/multi_screen_app_example.dart';
import 'features/avatars/avatar_demo_screen.dart';
import 'features/badges/badge_demo_screen.dart';
import 'features/bank_card/bank_card_demo_screen.dart';
import 'features/buttons/button_demo_screen.dart';
import 'features/charts/bar_chart_demo_screen.dart';
import 'features/charts/line_chart_demo_screen.dart';
import 'features/charts/mini_tabs_demo_screen.dart';
import 'features/effects/glow_demo_screen.dart';
import 'features/feedback/feedback_demo_screen.dart';
import 'features/bottom_nav_bar/bottom_nav_bar_demo_screen.dart';
import 'features/bottom_sheet/bottom_sheet_demo_screen.dart';
import 'features/divider/divider_demo_screen.dart';
import 'features/icons/icon_demo_screen.dart';
import 'features/inputs/input_demo_screen.dart';
import 'features/keypad/numeric_keypad_demo_screen.dart';
import 'features/links/link_demo_screen.dart';
import 'features/modal_dialog/modal_dialog_demo_screen.dart';
import 'features/page_indicator/page_indicator_demo_screen.dart';
import 'features/select/select_demo_screen.dart';
import 'features/selection_controls/selection_controls_demo_screen.dart';
import 'features/slider/slider_demo_screen.dart';
import 'features/stepper/stepper_demo_screen.dart';
import 'features/tabs/tabs_demo_screen.dart';
import 'features/top_bars/top_bar_demo_screen.dart';
import 'features/typography/typography_widget_demo_screen.dart';
import 'features/ui_blocks/ui_blocks_demo_screen.dart';

class CatalogApp extends StatefulWidget {
  const CatalogApp({super.key, this.initialRoute, this.home});

  final String? initialRoute;
  final Widget? home;

  @override
  State<CatalogApp> createState() => _CatalogAppState();
}

class _CatalogAppState extends State<CatalogApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Tsai UI',
    debugShowCheckedModeBanner: false,
    theme: TsaiTheme.light(),
    darkTheme: TsaiTheme.dark(),
    themeMode: _themeMode,
    initialRoute: widget.initialRoute,
    routes: {
      for (final section in [
        ComponentDemoSection.badge,
        ComponentDemoSection.badgeCounter,
        ComponentDemoSection.badgeDot,
        ComponentDemoSection.chip,
        ComponentDemoSection.iconButton,
      ])
        section.route: (context) => BadgeDemoScreen(
          section: section,
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      '/': (context) =>
          widget.home ??
          ButtonDemoScreen(
            themeMode: _themeMode,
            onThemeModeChanged: _setThemeMode,
          ),
      '/buttons': (context) => ButtonDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/links': (context) => LinkDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/tabs': (context) => TabsDocumentDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/bottom-nav-bar': (context) => BottomNavBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/bottom-sheet': (context) => BottomSheetDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/modal-dialog': (context) => ModalDialogDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/app-examples/multi-screen': (context) => MultiScreenAppExampleScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/top-bars/home': (context) => HomeTopBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/top-bars/page': (context) => PageTopBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/top-bars/page-layout': (context) => PageWithTopBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/top-bars/page-search-layout': (context) =>
          PageWithSearchTopBarDemoScreen(
            themeMode: _themeMode,
            onThemeModeChanged: _setThemeMode,
          ),
      '/top-bars': (context) => HomeTopBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/icons': (context) => IconDemoScreen(
        section: ComponentDemoSection.tsaiIcon,
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      for (final section in [
        ComponentDemoSection.tsaiIcon,
        ComponentDemoSection.hitIcon,
        ComponentDemoSection.circleIcon,
        ComponentDemoSection.cryptoIcon,
      ])
        section.route: (context) => IconDemoScreen(
          section: section,
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      for (final section in [
        ComponentDemoSection.avatar,
        ComponentDemoSection.userPill,
      ])
        section.route: (context) => AvatarDemoScreen(
          section: section,
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      for (final role in TypographyWidgetRole.values)
        role.route: (context) => TypographyWidgetDemoScreen(
          role: role,
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      '/checkbox': (context) => CheckboxDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/radio': (context) => RadioDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/switch': (context) => SwitchDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/select': (context) => SelectDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/input': (context) => InputDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/input-search': (context) => SearchInputDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/effects/glow': (context) => GlowDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      for (final section in [
        ComponentDemoSection.toast,
        ComponentDemoSection.inlineAlert,
        ComponentDemoSection.progress,
        ComponentDemoSection.skeleton,
        ComponentDemoSection.card,
      ])
        section.route: (context) => FeedbackDemoScreen(
          section: section,
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
      '/input-phone': (context) => PhoneInputDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/input-otp': (context) => OtpInputDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/input-pin': (context) => PinInputDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/page-indicator': (context) => PageIndicatorDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/keypad': (context) => NumericKeypadDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/action-tile': (context) => ActionTileDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/slider': (context) => SliderDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/stepper': (context) => StepperDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/bank-card': (context) => BankCardDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/amount-display': (context) => AmountDisplayDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/divider': (context) => DividerDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/accordion': (context) => AccordionDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/charts/mini-tabs': (context) => MiniTabsDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/charts/line-chart': (context) => LineChartDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/charts/bar-chart': (context) => BarChartDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      for (final section in [
        ComponentDemoSection.sectionHeader,
        ComponentDemoSection.emptyState,
        ComponentDemoSection.listItem,
        ComponentDemoSection.list,
      ])
        section.route: (context) => UIBlocksDemoScreen(
          section: section,
          themeMode: _themeMode,
          onThemeModeChanged: _setThemeMode,
        ),
    },
  );

  void _setThemeMode(ThemeMode value) => setState(() => _themeMode = value);
}
