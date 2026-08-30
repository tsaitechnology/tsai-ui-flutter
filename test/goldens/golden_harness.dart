import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

Future<void> expectComponentGolden(
  WidgetTester tester, {
  required String name,
  required Brightness brightness,
  required Widget child,
  Size size = const Size(390, 280),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final tokens = brightness == Brightness.dark
      ? TsaiThemeTokens.dark
      : TsaiThemeTokens.light;
  final key = ValueKey<String>('golden-$name');

  await tester.pumpWidget(
    MaterialApp(
      theme: brightness == Brightness.dark
          ? TsaiTheme.dark()
          : TsaiTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          devicePixelRatio: 1,
          disableAnimations: true,
        ),
        child: Scaffold(
          backgroundColor: tokens.colors.canvas,
          body: Align(
            alignment: Alignment.topCenter,
            child: RepaintBoundary(key: key, child: child),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  await expectLater(
    find.byKey(key),
    matchesGoldenFile('${name}_${brightness.name}.png'),
  );
}
