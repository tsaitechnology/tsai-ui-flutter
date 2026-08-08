import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('matches row and stacked Penpot geometry', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: TsaiModalDialog(
          title: 'Title',
          message: 'Message that explains what happens.',
          icon: const Icon(Icons.notifications_none, size: 24),
          secondaryAction: _button('Cancel'),
          primaryAction: _button('Confirm'),
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiModalDialog)).width, 320);
    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-modal-dialog-icon'))),
      const Size(48, 48),
    );
    expect(
      find.byKey(const ValueKey('tsai-modal-dialog-actions-row')),
      findsOneWidget,
    );
    final surface = tester.widget<Material>(
      find.byKey(const ValueKey('tsai-modal-dialog-surface')),
    );
    expect(surface.borderRadius, BorderRadius.circular(24));

    await tester.pumpWidget(
      _TestApp(
        child: TsaiModalDialog(
          title: 'Title',
          message: 'Message',
          icon: const Icon(Icons.notifications_none),
          actionsLayout: TsaiModalDialogActionsLayout.stacked,
          secondaryAction: _button('Cancel'),
          primaryAction: _button('Confirm'),
        ),
      ),
    );
    expect(
      find.byKey(const ValueKey('tsai-modal-dialog-actions-stacked')),
      findsOneWidget,
    );
  });

  testWidgets('modal helper opens and Escape dismisses the route', (
    tester,
  ) async {
    await tester.pumpWidget(const _Launcher());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(TsaiModalDialog), findsOneWidget);
    expect(find.text('Dialog title'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(TsaiModalDialog), findsNothing);
  });

  testWidgets('remains within a 320-pixel viewport with stacked actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const _Launcher(stacked: true));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byType(TsaiModalDialog)).left,
      greaterThanOrEqualTo(0),
    );
    expect(tester.takeException(), isNull);
  });
}

Widget _button(String label) => TsaiButton(label: label, onPressed: () {});

class _Launcher extends StatelessWidget {
  const _Launcher({this.stacked = false});

  final bool stacked;

  @override
  Widget build(BuildContext context) => _TestApp(
    child: Builder(
      builder: (context) => TextButton(
        onPressed: () => showTsaiModalDialog<void>(
          context: context,
          title: 'Dialog title',
          message: 'Message',
          icon: const Icon(Icons.notifications_none),
          actionsLayout: stacked
              ? TsaiModalDialogActionsLayout.stacked
              : TsaiModalDialogActionsLayout.row,
          secondaryAction: _button('Cancel'),
          primaryAction: _button('Confirm'),
        ),
        child: const Text('Open'),
      ),
    ),
  );
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
