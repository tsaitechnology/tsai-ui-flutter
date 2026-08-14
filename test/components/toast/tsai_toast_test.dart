import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../test_utils/load_test_fonts.dart';

void main() {
  setUpAll(loadTsaiTestFonts);

  testWidgets('matches all Penpot Toast variants', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiToast(message: 'Toast message', variant: TsaiToastVariant.undo),
            TsaiToast(
              message: 'Toast message',
              variant: TsaiToastVariant.action,
            ),
            TsaiToast(message: 'Toast message'),
          ],
        ),
      ),
    );

    final toasts = find.byType(TsaiToast);
    final surfaces = find.byKey(const ValueKey('tsai-toast-surface'));
    expect(toasts, findsNWidgets(3));
    expect(tester.getSize(surfaces.at(0)), const Size(242, 48));
    expect(tester.getSize(surfaces.at(1)), const Size(238, 48));
    expect(tester.getSize(surfaces.at(2)), const Size(194, 48));
    expect(
      tester.getSize(
        find.byKey(const ValueKey<String>('tsai-toast-countdown')),
      ),
      const Size.square(28),
    );
    expect(find.byKey(const ValueKey('tsai-toast-filter')), findsNWidgets(3));

    final surface = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('tsai-toast-surface')).first,
    );
    final decoration = surface.decoration as BoxDecoration;
    expect(decoration.color, TsaiThemeTokens.dark.colors.surfaceAccentGlassDim);
    expect(decoration.borderRadius, BorderRadius.circular(999));
  });

  testWidgets('invokes action and dismiss callbacks', (tester) async {
    var actions = 0;
    var dismissals = 0;
    await tester.pumpWidget(
      _TestApp(
        child: TsaiToast(
          message: 'Toast message',
          variant: TsaiToastVariant.action,
          onAction: () => actions++,
          onDismiss: () => dismissals++,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tsai-toast-action')));
    await tester.tap(find.byKey(const ValueKey('tsai-toast-close')));

    expect(actions, 1);
    expect(dismissals, 1);
  });

  testWidgets('announces message and countdown semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const _TestApp(
        child: TsaiToast(
          message: 'Transfer reverted',
          variant: TsaiToastVariant.undo,
          secondsRemaining: 5,
        ),
      ),
    );

    expect(find.bySemanticsLabel('Transfer reverted'), findsOneWidget);
    expect(find.bySemanticsLabel('5 seconds remaining'), findsOneWidget);
    semantics.dispose();
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: TsaiTheme.dark(),
    home: Scaffold(body: Center(child: child)),
  );
}
