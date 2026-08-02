import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import 'demo/component_demo_window.dart';
import 'features/app_examples/app_with_two_pages_example.dart';
import 'features/buttons/button_demo_screen.dart';
import 'features/bottom_nav_bar/bottom_nav_bar_demo_screen.dart';
import 'features/icons/icon_demo_screen.dart';
import 'features/inputs/input_demo_screen.dart';
import 'features/links/link_demo_screen.dart';
import 'features/select/select_demo_screen.dart';
import 'features/selection_controls/selection_controls_demo_screen.dart';
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
      '/tabs-document': (context) => TabsDocumentDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/tabs-viewport': (context) => TabsViewportDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/tabs-sticky': (context) => TabsStickyDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/bottom-nav-bar': (context) => BottomNavBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/app-examples/two-pages': (context) => AppWithTwoPagesExampleScreen(
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
      '/top-bars': (context) => HomeTopBarDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/icons': (context) => IconDemoScreen(
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
