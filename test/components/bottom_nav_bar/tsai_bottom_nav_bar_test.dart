import 'dart:ui' show PointerDeviceKind, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  for (var count = 1; count <= 4; count++) {
    testWidgets('$count items keep 80-pixel buttons and center the pill', (
      tester,
    ) async {
      await _pump(
        tester,
        child: BottomNavBar(
          items: _items.take(count).toList(),
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      );

      final pill = tester.getRect(
        find.byKey(const ValueKey<String>('bottom-nav-bar-pill')),
      );
      final bar = tester.getRect(find.byType(BottomNavBar));
      expect(pill.width, 8 + 80 * count);
      expect(pill.height, 62);
      expect(pill.center.dx, bar.center.dx);

      for (final item in _items.take(count)) {
        expect(
          tester
              .getSize(
                find.byKey(
                  ValueKey<String>('bottom-nav-bar-item-${item.label}'),
                ),
              )
              .width,
          80,
        );
      }
    });
  }

  testWidgets('renders selected state and reports destination changes', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var selected = -1;
    await _pump(
      tester,
      child: BottomNavBar(
        items: _items,
        selectedIndex: 1,
        onSelected: (index) => selected = index,
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    final selectedNode = tester.getSemantics(find.bySemanticsLabel('Stats'));
    expect(selectedNode.flagsCollection.isSelected, Tristate.isTrue);

    await tester.tap(find.bySemanticsLabel('Cards'));
    await tester.pump();
    expect(selected, 2);
    semantics.dispose();
  });

  testWidgets('does not add a background on mouse hover', (tester) async {
    await _pump(
      tester,
      child: BottomNavBar(items: _items, selectedIndex: 0, onSelected: (_) {}),
    );

    final target = find.byKey(
      const ValueKey<String>('bottom-nav-bar-item-background-Stats'),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(target));
    await tester.pump();

    final hovered = tester.widget<AnimatedContainer>(target);
    expect(hovered.duration, TsaiThemeTokens.dark.motion.interaction);
    expect((hovered.decoration! as BoxDecoration).color, Colors.transparent);
  });

  testWidgets('uses bottom scrim and renders without overflow at 320 pixels', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(
      tester,
      child: BottomNavBar(items: _items, selectedIndex: 0, onSelected: (_) {}),
    );

    final decoration = tester.widget<DecoratedBox>(
      find
          .byWidgetPredicate(
            (widget) =>
                widget is DecoratedBox &&
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).gradient != null,
          )
          .first,
    );
    expect(
      (decoration.decoration as BoxDecoration).gradient,
      TsaiThemeTokens.dark.gradients.bottomScrim,
    );
    expect(tester.takeException(), isNull);
  });

  test('requires one to four items and a valid selected index', () {
    expect(
      () => BottomNavBar(items: const [], selectedIndex: 0, onSelected: (_) {}),
      throwsAssertionError,
    );
    expect(
      () => BottomNavBar(
        items: [..._items, _items.first],
        selectedIndex: 0,
        onSelected: (_) {},
      ),
      throwsAssertionError,
    );
    expect(
      () => BottomNavBar(items: _items, selectedIndex: 4, onSelected: (_) {}),
      throwsAssertionError,
    );
  });
}

const _items = [
  BottomNavBarItem(icon: TsaiIcon(Icons.home), label: 'Home'),
  BottomNavBarItem(icon: TsaiIcon(Icons.bar_chart), label: 'Stats'),
  BottomNavBarItem(icon: TsaiIcon(Icons.credit_card), label: 'Cards'),
  BottomNavBarItem(icon: TsaiIcon(Icons.person), label: 'Profile'),
];

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: 390, child: child),
          ),
        ),
      ),
    );
