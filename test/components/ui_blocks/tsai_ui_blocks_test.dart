import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('section header renders text and an optional icon slot', (
    tester,
  ) async {
    await _pump(
      tester,
      child: TsaiSectionHeader(
        title: 'Transactions',
        trailingIcon: const Icon(Icons.search),
        trailingIconSemanticLabel: 'Search transactions',
        onTrailingIconPressed: () {},
      ),
    );

    expect(find.text('Transactions'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(tester.getSize(find.byType(TsaiSectionHeader)).height, 32);
    final icon = tester.widget<Icon>(find.byIcon(Icons.search));
    expect(find.byType(HitIcon), findsOneWidget);
    expect(icon.size, isNull);
    expect(IconTheme.of(tester.element(find.byIcon(Icons.search))).size, 24);
    expect(
      IconTheme.of(tester.element(find.byIcon(Icons.search))).color,
      TsaiThemeTokens.dark.colors.iconSecondary,
    );
  });

  testWidgets('empty state composes its icon, copy, and button', (
    tester,
  ) async {
    await _pump(
      tester,
      child: TsaiEmptyState(
        icon: const Icon(Icons.coffee),
        title: 'No transactions yet',
        description: 'New transactions will show up here.',
        button: TsaiButton(
          label: 'Add money',
          size: TsaiButtonSize.medium,
          onPressed: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.coffee), findsOneWidget);
    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('New transactions will show up here.'), findsOneWidget);
    expect(find.widgetWithText(TsaiButton, 'Add money'), findsOneWidget);
    expect(tester.getSize(find.byType(TsaiEmptyState)).height, 256);
  });

  testWidgets('list item supports every optional slot and activation', (
    tester,
  ) async {
    var calls = 0;
    await _pump(
      tester,
      child: TsaiListItem(
        active: true,
        icon: const Icon(Icons.coffee),
        content: const Text('Blue Bottle'),
        trailing: const Text(r'-$4.50'),
        showChevron: true,
        semanticLabel: 'Blue Bottle transaction',
        onTap: () => calls++,
      ),
    );

    expect(find.text('Blue Bottle'), findsOneWidget);
    expect(find.text(r'-$4.50'), findsOneWidget);
    expect(find.byIcon(Icons.coffee), findsOneWidget);
    expect(find.byType(CircleIcon), findsOneWidget);
    expect(find.byIcon(LucideIcons.chevron_right), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('tsai-list-item-active-background')),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Blue Bottle transaction'), findsOneWidget);

    await tester.tap(find.byType(TsaiListItem));
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('list item can render content without optional slots', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const TsaiListItem(content: Text('Content only')),
    );

    expect(find.text('Content only'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('tsai-list-item-active-background')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('list composes its header, items, and optional button', (
    tester,
  ) async {
    await _pump(
      tester,
      child: TsaiList(
        title: 'Transactions',
        headerTrailingIcon: const Icon(Icons.search),
        items: const [
          TsaiListItem(content: Text('First')),
          TsaiListItem(content: Text('Second')),
        ],
        button: TsaiButton(
          label: 'Show all',
          size: TsaiButtonSize.medium,
          variant: TsaiButtonVariant.outline,
          isExpanded: true,
          onPressed: () {},
        ),
      ),
    );

    expect(find.byType(TsaiSectionHeader), findsOneWidget);
    expect(find.byType(TsaiListItem), findsNWidgets(2));
    expect(find.widgetWithText(TsaiButton, 'Show all'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: Center(child: SizedBox(width: 342, child: child)),
        ),
      ),
    );
