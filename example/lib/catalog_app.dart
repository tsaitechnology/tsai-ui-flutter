import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import 'features/buttons/button_demo_screen.dart';
import 'features/icons/icon_demo_screen.dart';
import 'features/inputs/input_demo_screen.dart';
import 'features/select/select_demo_screen.dart';
import 'features/selection_controls/selection_controls_demo_screen.dart';
import 'features/typography/typography_demo_screen.dart';
import 'features/typography/typography_widget_demo_screen.dart';

class CatalogApp extends StatefulWidget {
  const CatalogApp({super.key, this.initialRoute});

  final String? initialRoute;

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
      '/': (context) => TypographyDemoScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
      '/buttons': (context) => ButtonDemoScreen(
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
    },
  );

  void _setThemeMode(ThemeMode value) => setState(() => _themeMode = value);
}
