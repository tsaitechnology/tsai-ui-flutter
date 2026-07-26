import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/features/top_bars/top_bar_demo.dart';

void main() {
  testWidgets('PageTopBar playground starts with external edge actions', (
    tester,
  ) async {
    await _pump(tester, child: const PageTopBarDemo());

    final preview = find.byKey(
      const ValueKey<String>('component-playground-preview'),
    );
    expect(
      find.descendant(of: preview, matching: find.byType(PageTopBarAction)),
      findsNWidgets(3),
    );
    expect(
      find.descendant(of: preview, matching: find.text('Card details')),
      findsOneWidget,
    );
    expect(find.text('Two actions'), findsOneWidget);
  });

  testWidgets('PageWithTopBar playground provides a long scrolling list', (
    tester,
  ) async {
    await _pump(tester, child: const PageWithTopBarDemo());

    final preview = find.byKey(
      const ValueKey<String>('component-playground-preview'),
    );
    await tester.ensureVisible(preview);
    await tester.pumpAndSettle();

    final scrollable = find.descendant(
      of: preview,
      matching: find.byKey(
        const ValueKey<String>('page-with-top-bar-scrollable'),
      ),
    );

    expect(scrollable, findsOneWidget);
    expect(
      find.descendant(of: preview, matching: find.text('AAPL')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: preview, matching: find.text('INTC')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: preview, matching: find.byType(PageTopBarAction)),
      findsNWidgets(3),
    );

    await tester.drag(scrollable, const Offset(0, -240));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: preview, matching: find.text('Main account')),
      findsNothing,
    );
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.light(),
        home: Scaffold(body: SizedBox(width: 900, height: 900, child: child)),
      ),
    );
