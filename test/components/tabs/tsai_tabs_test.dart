import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('maps Penpot geometry, typography, and color tokens', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const TsaiTabs(
        sections: [
          TsaiTabSection(tab: Text('First'), content: SizedBox(height: 40)),
          TsaiTabSection(tab: Text('Second'), content: SizedBox(height: 40)),
        ],
      ),
    );

    final tokens = TsaiThemeTokens.dark;
    expect(tester.getSize(find.byType(TsaiTabBar)).height, 36);

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.controller!.animationDuration, tokens.motion.interaction);
    final indicator = tabBar.indicator! as BoxDecoration;
    expect(indicator.color, tokens.colors.surfaceAccent);
    expect(indicator.borderRadius, BorderRadius.circular(10));
    expect(tabBar.labelColor, tokens.colors.contentPrimary);
    expect(tabBar.unselectedLabelColor, tokens.colors.contentSecondary);
    expect(tabBar.labelStyle, tokens.typography.captionMedium);
    expect(tabBar.labelPadding, EdgeInsets.zero);

    final decoration = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(TsaiTabBar),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((value) => value.border != null);
    expect(decoration.color, tokens.colors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(12));
    expect(
      (decoration.border! as Border).top,
      BorderSide(color: tokens.colors.borderSubtle),
    );
  });

  testWidgets('coordinates external selection and reports changes', (
    tester,
  ) async {
    final changes = <int>[];
    await _pump(
      tester,
      child: _ControlledTabs(
        child: (controller) => TsaiTabs(
          controller: controller,
          onChanged: changes.add,
          sections: const [
            TsaiTabSection(tab: Text('First'), content: Text('First content')),
            TsaiTabSection(
              tab: Text('Second'),
              content: Text('Second content'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('First content'), findsOneWidget);
    expect(find.text('Second content'), findsNothing);

    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();

    expect(find.text('First content'), findsNothing);
    expect(find.text('Second content'), findsOneWidget);
    expect(changes, [1]);
  });

  testWidgets('intrinsic content follows the selected section height', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const Align(
        alignment: Alignment.topCenter,
        child: TsaiTabs(
          sections: [
            TsaiTabSection(tab: Text('Short'), content: SizedBox(height: 40)),
            TsaiTabSection(tab: Text('Long'), content: SizedBox(height: 140)),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiTabContent)).height, 40);

    await tester.tap(find.text('Long'));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(TsaiTabContent)).height, 140);
  });

  testWidgets('viewport content keeps tabs fixed while its list scrolls', (
    tester,
  ) async {
    await _pump(
      tester,
      child: SizedBox(
        height: 320,
        child: TsaiTabs(
          contentLayout: TsaiTabContentLayout.viewport,
          sections: [
            TsaiTabSection(
              tab: const Text('Feed'),
              content: ListView.builder(
                itemExtent: 48,
                itemCount: 30,
                itemBuilder: (context, index) => Text('Row $index'),
              ),
            ),
            const TsaiTabSection(
              tab: Text('Details'),
              content: Text('Details content'),
            ),
          ],
        ),
      ),
    );

    final initialBarTop = tester.getTopLeft(find.byType(TsaiTabBar)).dy;
    final initialRowTop = tester.getTopLeft(find.text('Row 0')).dy;

    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(TsaiTabBar)).dy, initialBarTop);
    expect(find.text('Row 0'), findsNothing);
    expect(
      tester.getTopLeft(find.text('Row 4')).dy,
      lessThan(initialRowTop + 48),
    );
  });

  testWidgets('sliver tab bar remains pinned after its header scrolls away', (
    tester,
  ) async {
    await _pump(
      tester,
      child: _ControlledTabs(
        child: (controller) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 180)),
            TsaiSliverTabBar(
              controller: controller,
              tabs: const [Text('First'), Text('Second')],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 1000)),
          ],
        ),
      ),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -260));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(TsaiTabBar)).dy, 0);
  });

  testWidgets('can replace a caller-owned controller with internal state', (
    tester,
  ) async {
    final key = GlobalKey<_ControllerSwapHostState>();
    await _pump(tester, child: _ControllerSwapHost(key: key));

    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();
    expect(find.text('Second content'), findsOneWidget);

    key.currentState!.useExternalController = false;
    await tester.pump();

    expect(find.text('Second content'), findsOneWidget);
    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    expect(find.text('First content'), findsOneWidget);
  });
}

class _ControlledTabs extends StatefulWidget {
  const _ControlledTabs({required this.child});

  final Widget Function(TabController controller) child;

  @override
  State<_ControlledTabs> createState() => _ControlledTabsState();
}

class _ControlledTabsState extends State<_ControlledTabs>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child(controller);
}

class _ControllerSwapHost extends StatefulWidget {
  const _ControllerSwapHost({super.key});

  @override
  State<_ControllerSwapHost> createState() => _ControllerSwapHostState();
}

class _ControllerSwapHostState extends State<_ControllerSwapHost>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  var _useExternalController = true;

  set useExternalController(bool value) =>
      setState(() => _useExternalController = value);

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TsaiTabs(
    controller: _useExternalController ? controller : null,
    sections: const [
      TsaiTabSection(tab: Text('First'), content: Text('First content')),
      TsaiTabSection(tab: Text('Second'), content: Text('Second content')),
    ],
  );
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: child),
      ),
    );
