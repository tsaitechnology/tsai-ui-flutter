import 'dart:ui' show PointerDeviceKind, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  const expectedPillWidths = {1: 88.0, 2: 168.0, 3: 248.0, 4: 328.0, 5: 358.0};
  const expectedItemWidths = {1: 80.0, 2: 80.0, 3: 80.0, 4: 80.0, 5: 70.0};

  for (var count = 1; count <= 5; count++) {
    testWidgets('$count items resolve Penpot geometry at 390 pixels', (
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
      expect(pill.width, expectedPillWidths[count]);
      expect(pill.height, 62);
      expect(bar.height, 94);
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
          expectedItemWidths[count],
        );
      }
    });
  }

  testWidgets('three-item layout places destinations in adjacent slots', (
    tester,
  ) async {
    await _pump(
      tester,
      child: BottomNavBar(
        items: _items.take(3).toList(),
        selectedIndex: 0,
        onSelected: (_) {},
      ),
    );

    final home = tester.getRect(_item('Home'));
    final stats = tester.getRect(_item('Stats'));
    final cards = tester.getRect(_item('Cards'));
    expect(stats.left, home.right);
    expect(cards.left, stats.right);
  });

  testWidgets('fit mode shares narrow parent width across real items', (
    tester,
  ) async {
    await _pump(
      tester,
      width: 240,
      child: BottomNavBar(
        items: _items.take(3).toList(),
        selectedIndex: 0,
        onSelected: (_) {},
      ),
    );

    final pill = tester.getRect(
      find.byKey(const ValueKey<String>('bottom-nav-bar-pill')),
    );
    final home = tester.getRect(_item('Home'));
    final stats = tester.getRect(_item('Stats'));
    final cards = tester.getRect(_item('Cards'));
    expect(pill.width, 208);
    expect(home.width, closeTo(200 / 3, 0.01));
    expect(stats.left, closeTo(home.right, 0.01));
    expect(cards.left, closeTo(stats.right, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('five items keep 80-pixel slots when they fit', (tester) async {
    await _pump(
      tester,
      width: 440,
      child: BottomNavBar(items: _items, selectedIndex: 0, onSelected: (_) {}),
    );

    expect(
      tester
          .getSize(find.byKey(const ValueKey<String>('bottom-nav-bar-pill')))
          .width,
      408,
    );
    for (final item in _items) {
      expect(tester.getSize(_item(item.label)).width, 80);
    }
  });

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

  test('requires one to five items and a valid selected index', () {
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
      () => BottomNavBar(items: _items, selectedIndex: 5, onSelected: (_) {}),
      throwsAssertionError,
    );
  });
}

const _items = [
  BottomNavBarItem(icon: TsaiIcon(Icons.home), label: 'Home'),
  BottomNavBarItem(icon: TsaiIcon(Icons.bar_chart), label: 'Stats'),
  BottomNavBarItem(icon: TsaiIcon(Icons.credit_card), label: 'Cards'),
  BottomNavBarItem(icon: TsaiIcon(Icons.person), label: 'Profile'),
  BottomNavBarItem(icon: TsaiIcon(Icons.settings), label: 'Settings'),
];

Finder _item(String label) =>
    find.byKey(ValueKey<String>('bottom-nav-bar-item-$label'));

Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  double width = 390,
}) => tester.pumpWidget(
  MaterialApp(
    theme: TsaiTheme.dark(),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);
