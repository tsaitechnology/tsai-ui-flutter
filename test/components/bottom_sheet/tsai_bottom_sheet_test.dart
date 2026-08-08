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

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: TsaiTheme.dark(),
    home: Scaffold(body: child),
  );
}
