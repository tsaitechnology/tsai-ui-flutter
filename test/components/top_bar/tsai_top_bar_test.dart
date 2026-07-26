import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('UserPill shows initials and supports a network avatar', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const Column(
        children: [
          UserPill(name: 'Ilona T.', initials: 'IT'),
          UserPill(
            name: 'Alex R.',
            initials: 'AR',
            avatarUrl: 'https://example.com/avatar.png',
          ),
        ],
      ),
    );

    expect(find.text('Ilona T.'), findsOneWidget);
    expect(find.text('IT'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(UserPill), findsNWidgets(2));
  });

  testWidgets('UserPill invokes its optional action', (tester) async {
    final semantics = tester.ensureSemantics();
    var presses = 0;
    await _pump(
      tester,
      child: UserPill(
        name: 'Ilona T.',
        initials: 'IT',
        semanticLabel: 'Open profile',
        onPressed: () => presses++,
      ),
    );

    await tester.tap(find.byType(UserPill));
    await tester.pump();

    expect(presses, 1);
    expect(find.bySemanticsLabel('Open profile'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('HomeTopBar composes actions and generic indicators', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var scans = 0;
    var notifications = 0;
    await _pump(
      tester,
      child: HomeTopBar(
        leading: const [UserPill(name: 'Ilona T.', initials: 'IT')],
        trailing: [
          HomeTopBarAction(
            icon: const TsaiIcon(Icons.qr_code_scanner),
            semanticLabel: 'Scan',
            onPressed: () => scans++,
          ),
          HomeTopBarAction(
            icon: const TsaiIcon(Icons.notifications_none),
            semanticLabel: 'Notifications',
            showIndicator: true,
            onPressed: () => notifications++,
          ),
        ],
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.height == 64 &&
            widget.width == double.infinity,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 40 && widget.height == 40,
      ),
      findsNWidgets(2),
    );
    expect(
      find.byKey(const ValueKey<String>('home-top-bar-action-indicator')),
      findsOneWidget,
    );

    await tester.tap(find.bySemanticsLabel('Scan'));
    await tester.tap(find.bySemanticsLabel('Notifications'));
    expect(scans, 1);
    expect(notifications, 1);
    semantics.dispose();
  });

  testWidgets('PageTopBar keeps its title centered with unequal slots', (
    tester,
  ) async {
    await _pump(
      tester,
      child: PageTopBar(
        leading: [
          PageTopBarAction(
            icon: const TsaiIcon(Icons.arrow_back),
            semanticLabel: 'Back',
            onPressed: () {},
          ),
        ],
        title: const Text('Card details'),
        trailing: [
          PageTopBarAction(
            icon: const TsaiIcon(Icons.add),
            semanticLabel: 'Add',
            onPressed: () {},
          ),
          PageTopBarAction(
            icon: const TsaiIcon(Icons.more_horiz),
            semanticLabel: 'More',
            onPressed: () {},
          ),
        ],
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.height == 56 &&
            widget.width == double.infinity,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 32 && widget.height == 32,
      ),
      findsNWidgets(3),
    );
    expect(tester.getCenter(find.text('Card details')).dx, closeTo(400, 0.01));
  });

  testWidgets('PageTopBar constrains its title between external text slots', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const PageTopBar(
        leading: [Text('Cancel changes')],
        title: Text(
          'A long centered page title that must remain constrained',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: [Text('Save changes')],
      ),
    );

    final leadingRect = tester.getRect(find.text('Cancel changes'));
    final titleRect = tester.getRect(
      find.text('A long centered page title that must remain constrained'),
    );
    final trailingRect = tester.getRect(find.text('Save changes'));

    expect(titleRect.left, greaterThanOrEqualTo(leadingRect.right));
    expect(titleRect.right, lessThanOrEqualTo(trailingRect.left));
    expect(tester.takeException(), isNull);
  });

  testWidgets('PageWithTopBar promotes its heading after any scroll', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      child: PageWithTopBar(
        controller: controller,
        heading: 'Portfolio',
        subtitle: 'Main account',
        trailing: [
          PageTopBarAction(
            icon: const TsaiIcon(
              Icons.more_horiz,
              key: ValueKey<String>('page-with-top-bar-trailing-icon'),
            ),
            semanticLabel: 'More',
            onPressed: () {},
          ),
        ],
        body: const SizedBox(height: 1000),
      ),
    );

    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Main account'), findsOneWidget);
    final heading = find.byKey(
      const ValueKey<String>('page-with-top-bar-heading'),
    );
    final trailingIcon = find.byKey(
      const ValueKey<String>('page-with-top-bar-trailing-icon'),
    );
    final expandedHeadingRect = tester.getRect(heading);
    final trailingCenter = tester.getCenter(trailingIcon);

    controller.jumpTo(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 110));

    final movingHeadingRect = tester.getRect(heading);
    expect(movingHeadingRect.top, lessThan(expandedHeadingRect.top));
    expect(movingHeadingRect.top, greaterThan(18));

    await tester.pumpAndSettle();

    final collapsedHeadingRect = tester.getRect(heading);
    expect(find.text('Main account'), findsNothing);
    expect(collapsedHeadingRect.top, closeTo(18, 0.01));
    expect(collapsedHeadingRect.center.dx, closeTo(400, 0.01));
    expect(find.text('Portfolio'), findsOneWidget);
    expect(tester.getCenter(trailingIcon), trailingCenter);

    controller.jumpTo(0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 110));

    final returningHeadingRect = tester.getRect(heading);
    expect(returningHeadingRect.top, greaterThan(collapsedHeadingRect.top));
    expect(returningHeadingRect.top, lessThan(expandedHeadingRect.top));
    expect(find.text('Main account'), findsNothing);

    await tester.pumpAndSettle();

    expect(tester.getRect(heading), expandedHeadingRect);
    expect(find.text('Main account'), findsOneWidget);
    expect(tester.getCenter(trailingIcon), trailingCenter);
  });

  testWidgets('PageWithTopBar owns one scrollable for heading and body', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const PageWithTopBar(
        heading: 'Portfolio',
        body: SizedBox(height: 1000, child: Text('End of portfolio')),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('page-with-top-bar-scrollable')),
      findsOneWidget,
    );

    await tester.drag(
      find.byKey(const ValueKey<String>('page-with-top-bar-scrollable')),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .getRect(
            find.byKey(const ValueKey<String>('page-with-top-bar-heading')),
          )
          .top,
      closeTo(18, 0.01),
    );
    expect(
      find.byKey(const ValueKey<String>('page-with-top-bar-heading')),
      findsOneWidget,
    );
  });

  testWidgets('PageWithTopBar respects an external initial scroll offset', (
    tester,
  ) async {
    final controller = ScrollController(initialScrollOffset: 24);
    addTearDown(controller.dispose);

    await _pump(
      tester,
      child: PageWithTopBar(
        controller: controller,
        heading: 'Portfolio',
        body: const SizedBox(height: 1000),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .getRect(
            find.byKey(const ValueKey<String>('page-with-top-bar-heading')),
          )
          .top,
      closeTo(18, 0.01),
    );
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: 390, height: 640, child: child),
          ),
        ),
      ),
    );
