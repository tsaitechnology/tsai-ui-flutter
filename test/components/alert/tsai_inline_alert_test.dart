import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../test_utils/load_test_fonts.dart';

void main() {
  setUpAll(loadTsaiTestFonts);

  for (final tone in TsaiInlineAlertTone.values) {
    testWidgets('matches the ${tone.name} Penpot variant', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          child: SizedBox(
            width: 342,
            child: TsaiInlineAlert(
              title: 'Alert title',
              message:
                  'Alert message that explains what happened and what to do next.',
              tone: tone,
              onDismiss: () {},
            ),
          ),
        ),
      );

      final alert = find.byType(TsaiInlineAlert);
      expect(tester.getSize(alert), const Size(342, 74));
      final surface = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey('tsai-inline-alert-surface')),
      );
      final decoration = surface.decoration as BoxDecoration;
      final colors = TsaiThemeTokens.dark.colors;
      expect(decoration.color, _surface(colors, tone));
      expect((decoration.border! as Border).top.color, _border(colors, tone));
      expect(decoration.borderRadius, BorderRadius.circular(12));

      final icon = tester.widget<TsaiIcon>(
        find.descendant(of: alert, matching: find.byType(TsaiIcon)).first,
      );
      expect(icon.size, 20);
      expect(icon.color, _accent(colors, tone));
    });
  }

  testWidgets('invokes dismiss and exposes status semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    var dismissals = 0;
    await tester.pumpWidget(
      _TestApp(
        child: SizedBox(
          width: 342,
          child: TsaiInlineAlert(
            title: 'Payment failed',
            message: 'Try another payment method.',
            tone: TsaiInlineAlertTone.error,
            onDismiss: () => dismissals++,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tsai-inline-alert-close')));
    expect(dismissals, 1);
    expect(find.bySemanticsLabel('Payment failed'), findsOneWidget);
    expect(find.bySemanticsLabel('Dismiss'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('grows without overflow at 200 percent text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        textScaler: const TextScaler.linear(2),
        child: const SizedBox(
          width: 320,
          child: TsaiInlineAlert(
            title: 'Long alert title',
            message: 'A longer localized message remains readable.',
            onDismiss: null,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(TsaiInlineAlert)).height,
      greaterThan(74),
    );
  });
}

Color _surface(TsaiColorTokens colors, TsaiInlineAlertTone tone) =>
    switch (tone) {
      TsaiInlineAlertTone.info => colors.statusSurfaceInfo,
      TsaiInlineAlertTone.success => colors.statusSurfaceSuccess,
      TsaiInlineAlertTone.error => colors.statusSurfaceError,
      TsaiInlineAlertTone.warning => colors.statusSurfaceWarning,
    };

Color _border(TsaiColorTokens colors, TsaiInlineAlertTone tone) =>
    switch (tone) {
      TsaiInlineAlertTone.info => colors.statusBorderInfo,
      TsaiInlineAlertTone.success => colors.statusBorderSuccess,
      TsaiInlineAlertTone.error => colors.statusBorderError,
      TsaiInlineAlertTone.warning => colors.statusBorderWarning,
    };

Color _accent(TsaiColorTokens colors, TsaiInlineAlertTone tone) =>
    switch (tone) {
      TsaiInlineAlertTone.info => colors.accentInfo,
      TsaiInlineAlertTone.success => colors.accentSuccess,
      TsaiInlineAlertTone.error => colors.accentError,
      TsaiInlineAlertTone.warning => colors.accentWarning,
    };

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, this.textScaler});

  final Widget child;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: TsaiTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(textScaler: textScaler ?? TextScaler.noScaling),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}
