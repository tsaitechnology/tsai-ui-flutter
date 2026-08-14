import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('maps half and full Penpot geometry', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: Column(
          children: const [
            TsaiBottomSheet(title: 'Half', height: 424, child: SizedBox()),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiBottomSheet)), const Size(800, 424));
    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-bottom-sheet-grabber'))),
      const Size(36, 4),
    );
    final surface = tester.widget<Material>(
      find.byKey(const ValueKey('tsai-bottom-sheet-surface')),
    );
    expect(
      surface.borderRadius,
      const BorderRadius.vertical(top: Radius.circular(32)),
    );
    expect(find.byType(TsaiGlow), findsOneWidget);

    final sheetRect = tester.getRect(find.byType(TsaiBottomSheet));
    final appBarTitleRect = tester.getRect(find.text('Half'));
    expect(appBarTitleRect.center.dx, sheetRect.center.dx);
    expect(
      tester.getRect(find.byType(TsaiGlow)).center.dx,
      sheetRect.center.dx,
    );
  });

  testWidgets('sizes to content by default', (tester) async {
    await tester.pumpWidget(const _ContentLauncher());

    await tester.tap(find.text('Open content sheet'));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(TsaiBottomSheet)).height, 190);
    expect(
      tester.getSize(find.byKey(const ValueKey('sheet-content'))).height,
      80,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('limits content sizing to the available viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const _ContentLauncher(contentHeight: 500));

    await tester.tap(find.text('Open content sheet'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(TsaiBottomSheet)).height,
      lessThanOrEqualTo(300),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a modal route, actions, and closes', (tester) async {
    await tester.pumpWidget(const _Launcher());

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(TsaiBottomSheet), findsOneWidget);
    expect(find.text('Sheet title'), findsOneWidget);
    expect(find.text('Sheet content'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('tsai-bottom-sheet-actions')),
      findsOneWidget,
    );
    final sheetRect = tester.getRect(find.byType(TsaiBottomSheet));
    final actionsRect = tester.getRect(
      find.byKey(const ValueKey('tsai-bottom-sheet-actions')),
    );
    expect(actionsRect.bottom, closeTo(sheetRect.bottom - 42, 0.01));

    final closeIconRect = tester.getRect(
      find.descendant(
        of: find.byTooltip('Close'),
        matching: find.byType(TsaiIcon),
      ),
    );
    expect(closeIconRect.size, const Size.square(24));
    expect(closeIconRect.top, closeTo(sheetRect.top + 28, 0.01));
    expect(closeIconRect.right, closeTo(sheetRect.right - 20, 0.01));

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(TsaiBottomSheet), findsNothing);
  });

  testWidgets('clamps a full sheet to the available viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const _Launcher());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(TsaiBottomSheet)).height,
      lessThanOrEqualTo(640),
    );
    expect(tester.takeException(), isNull);
  });
}

class _Launcher extends StatelessWidget {
  const _Launcher();

  @override
  Widget build(BuildContext context) => _TestApp(
    child: Builder(
      builder: (context) => TextButton(
        onPressed: () => showTsaiBottomSheet<void>(
          context: context,
          title: 'Sheet title',
          size: TsaiBottomSheetSize.full,
          child: const ColoredBox(
            color: Colors.black12,
            child: Center(child: Text('Sheet content')),
          ),
          secondaryAction: const TsaiButton(label: 'Cancel', onPressed: null),
          primaryAction: const TsaiButton(label: 'Confirm', onPressed: null),
        ),
        child: const Text('Open'),
      ),
    ),
  );
}

class _ContentLauncher extends StatelessWidget {
  const _ContentLauncher({this.contentHeight = 80});

  final double contentHeight;

  @override
  Widget build(BuildContext context) => _TestApp(
    child: Builder(
      builder: (context) => TextButton(
        onPressed: () => showTsaiBottomSheet<void>(
          context: context,
          title: 'Content sheet',
          child: SizedBox(
            key: const ValueKey<String>('sheet-content'),
            height: contentHeight,
          ),
        ),
        child: const Text('Open content sheet'),
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
    home: Scaffold(body: child),
  );
}
