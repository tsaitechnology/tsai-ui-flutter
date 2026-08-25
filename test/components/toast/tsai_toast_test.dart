import 'dart:async';

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

  testWidgets('truncates its message without overflowing narrow hosts', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: SizedBox(
          width: 280,
          child: TsaiToast(
            message: 'A deliberately long notification message',
            variant: TsaiToastVariant.undo,
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-toast-surface'))).width,
      280,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('overlay helper presents, dismisses, and times out', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    TsaiToastDismissReason? result;
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              result = null;
              unawaited(
                showTsaiToast(
                  context: context,
                  message: 'Changes saved',
                  duration: const Duration(milliseconds: 80),
                ).then((value) => result = value),
              );
            },
            child: const Text('Show'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.byType(TsaiToast), findsOneWidget);
    expect(find.text('Changes saved'), findsOneWidget);

    final toast = tester.getRect(
      find.byKey(const ValueKey<String>('tsai-toast-surface')),
    );
    expect(toast.height, 48);
    expect(844 - toast.bottom, 12);
    expect(toast.center.dx, 195);

    await tester.tap(find.byKey(const ValueKey<String>('tsai-toast-close')));
    await tester.pump();
    expect(find.byType(TsaiToast), findsNothing);
    expect(result, TsaiToastDismissReason.dismiss);

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    await tester.pump();
    expect(find.byType(TsaiToast), findsNothing);
    expect(result, TsaiToastDismissReason.timeout);
  });

  testWidgets('overlay sits 12 pixels above supplied bottom clearance', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => unawaited(
              showTsaiToast(
                context: context,
                message: 'Message deleted',
                variant: TsaiToastVariant.undo,
                bottomClearance: 94,
                duration: const Duration(seconds: 30),
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    final toast = tester.getRect(
      find.byKey(const ValueKey<String>('tsai-toast-surface')),
    );
    expect(844 - toast.bottom, 106);
  });

  testWidgets('overlay action completes and a new toast replaces the last', (
    tester,
  ) async {
    var actions = 0;
    late TsaiToastDismissReason first;
    late TsaiToastDismissReason second;
    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  unawaited(
                    showTsaiToast(
                      context: context,
                      message: 'First',
                      variant: TsaiToastVariant.action,
                      duration: const Duration(seconds: 30),
                    ).then((value) => first = value),
                  );
                },
                child: const Text('First'),
              ),
              TextButton(
                onPressed: () {
                  unawaited(
                    showTsaiToast(
                      context: context,
                      message: 'Second',
                      variant: TsaiToastVariant.action,
                      actionLabel: 'Retry',
                      duration: const Duration(seconds: 30),
                      onAction: () => actions++,
                    ).then((value) => second = value),
                  );
                },
                child: const Text('Second'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('First'));
    await tester.pump();
    expect(
      find.descendant(of: find.byType(TsaiToast), matching: find.text('First')),
      findsOneWidget,
    );
    await tester.tap(find.text('Second'));
    await tester.pump();
    expect(
      find.descendant(of: find.byType(TsaiToast), matching: find.text('First')),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(TsaiToast),
        matching: find.text('Second'),
      ),
      findsOneWidget,
    );
    expect(first, TsaiToastDismissReason.dismiss);

    await tester.tap(find.byKey(const ValueKey<String>('tsai-toast-action')));
    await tester.pump();
    expect(actions, 1);
    expect(second, TsaiToastDismissReason.action);
    expect(find.byType(TsaiToast), findsNothing);
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
