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
    expect(find.byType(BackdropFilter), findsNWidgets(2));
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
            widget.height == 76 &&
            widget.width == double.infinity,
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(HomeTopBar),
        matching: find.byType(BackdropFilter),
      ),
      findsNWidgets(3),
    );
    final homeDecoration = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(HomeTopBar),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).gradient != null,
            ),
          )
          .first,
    );
    final gradient = (homeDecoration.decoration as BoxDecoration).gradient!;
    expect(gradient.colors.first, TsaiThemeTokens.light.colors.canvasGlass);
    expect(gradient.colors.last.a, 0);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 40 && widget.height == 40,
      ),
      findsNWidgets(2),
    );
    final userPillRect = tester.getRect(find.byType(UserPill));
    final firstActionRect = tester.getRect(find.byType(HomeTopBarAction).first);
    expect(userPillRect.height, 40);
    expect(firstActionRect.height, 40);
    expect(userPillRect.top, firstActionRect.top);
    expect(userPillRect.top, tester.getRect(find.byType(HomeTopBar)).top + 12);
    expect(
      find.byKey(const ValueKey<String>('home-top-bar-action-indicator')),
      findsOneWidget,
    );
    final indicator = find.byKey(
      const ValueKey<String>('home-top-bar-action-indicator'),
    );
    expect(
      find.ancestor(of: indicator, matching: find.byType(InkWell)),
      findsNothing,
    );
    expect(
      find.ancestor(of: indicator, matching: find.byType(ClipRRect)),
      findsNothing,
    );
    expect(
      find.ancestor(of: indicator, matching: find.byType(HomeTopBarAction)),
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
        title: 'Card details',
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
    expect(
      find.descendant(
        of: find.byType(PageTopBar),
        matching: find.byType(BackdropFilter),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(PageTopBar),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox &&
              widget.color == TsaiThemeTokens.light.colors.canvasGlass,
        ),
      ),
      findsOneWidget,
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
        title: 'A long centered page title that must remain constrained',
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
    expect(_pageTopBarBackground(tester).color, Colors.transparent);
    expect(_pageTopBarFilter(tester).enabled, isFalse);

    controller.jumpTo(1);
    await tester.pump();

    final transitionStartRect = tester.getRect(heading);
    expect(transitionStartRect.left, closeTo(expandedHeadingRect.left, 0.01));
    expect(
      _pageTopBarBackground(tester).color,
      TsaiThemeTokens.light.colors.canvasGlass,
    );
    expect(_pageTopBarFilter(tester).enabled, isTrue);

    await tester.pump(const Duration(milliseconds: 110));

    final movingHeadingRect = tester.getRect(heading);
    expect(movingHeadingRect.top, lessThan(expandedHeadingRect.top));
    expect(movingHeadingRect.top, greaterThan(18));
    expect(movingHeadingRect.left, greaterThan(transitionStartRect.left));
    expect(movingHeadingRect.center.dx, lessThan(400));

    await tester.pumpAndSettle();

    final collapsedHeadingRect = tester.getRect(heading);
    expect(find.text('Main account'), findsNothing);
    expect(collapsedHeadingRect.top, closeTo(18, 0.01));
    expect(collapsedHeadingRect.center.dx, closeTo(400, 0.01));
    expect(find.text('Portfolio'), findsOneWidget);
    expect(tester.getCenter(trailingIcon), trailingCenter);

    controller.jumpTo(0);
    await tester.pump();
    expect(_pageTopBarBackground(tester).color, Colors.transparent);
    expect(_pageTopBarFilter(tester).enabled, isFalse);
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

  testWidgets('PageWithSearchTopBar pins 112-pixel glass search chrome', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      child: PageWithSearchTopBar(
        controller: controller,
        title: 'Card details',
        search: const TsaiSearchInput(),
        body: const SizedBox(height: 1000, child: Text('Scrollable content')),
      ),
    );

    final background = find.byKey(
      const ValueKey<String>('page-with-search-top-bar-background'),
    );
    expect(tester.getSize(background).height, 112);
    expect(find.byType(TsaiSearchInput), findsOneWidget);
    final pageRect = tester.getRect(find.byType(PageWithSearchTopBar));
    expect(
      tester.getRect(find.byType(TsaiSearchInput)),
      Rect.fromLTWH(pageRect.left + 16, 64, pageRect.width - 32, 40),
    );
    final initialHeaderRect = tester.getRect(background);
    final initialContentTop = tester
        .getTopLeft(find.text('Scrollable content'))
        .dy;

    controller.jumpTo(80);
    await tester.pump();
    expect(tester.getRect(background), initialHeaderRect);
    expect(
      tester.getTopLeft(find.text('Scrollable content')).dy,
      closeTo(initialContentTop - 80, 0.01),
    );
    expect(
      tester.widget<ColoredBox>(background).color,
      TsaiThemeTokens.light.colors.canvasGlass,
    );
  });

  testWidgets('PageWithTopBar scrolls its document behind the glass bar', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await _pump(
      tester,
      child: PageWithTopBar(
        controller: controller,
        heading: 'Portfolio',
        body: const SizedBox(key: ValueKey<String>('page-body'), height: 1000),
      ),
    );

    final pageRect = tester.getRect(find.byType(PageWithTopBar));
    final scrollRect = tester.getRect(
      find.byKey(const ValueKey<String>('page-with-top-bar-scrollable')),
    );
    final barRect = tester.getRect(find.byType(PageTopBar));
    expect(scrollRect.top, pageRect.top);
    expect(scrollRect.bottom, pageRect.bottom);
    expect(barRect.top, pageRect.top);

    controller.jumpTo(100);
    await tester.pumpAndSettle();

    final bodyRect = tester.getRect(
      find.byKey(const ValueKey<String>('page-body')),
    );
    expect(bodyRect.top, lessThan(barRect.bottom));
    expect(bodyRect.bottom, greaterThan(barRect.bottom));
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

ColoredBox _pageTopBarBackground(WidgetTester tester) =>
    tester.widget<ColoredBox>(
      find.byKey(const ValueKey<String>('page-top-bar-background')),
    );

BackdropFilter _pageTopBarFilter(WidgetTester tester) =>
    tester.widget<BackdropFilter>(
      find.descendant(
        of: find.byType(PageTopBar),
        matching: find.byType(BackdropFilter),
      ),
    );

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
