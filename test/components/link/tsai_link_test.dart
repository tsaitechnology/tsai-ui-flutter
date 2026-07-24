import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('uses Penpot dimensions, typography, icons, and gaps', (
    tester,
  ) async {
    await _pump(
      tester,
      child: TsaiLink(
        label: 'Link',
        leadingIcon: const TsaiIcon(Icons.add, size: 16),
        trailingIcon: const TsaiIcon(Icons.chevron_right, size: 16),
        onPressed: () {},
      ),
    );

    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.style!.minimumSize!.resolve({}), const Size(0, 32));
    expect(button.style!.padding!.resolve({}), EdgeInsets.zero);
    expect(button.style!.textStyle!.resolve({})!.fontSize, 14);
    expect(button.style!.textStyle!.resolve({})!.fontWeight, FontWeight.w500);

    final icons = find.byType(TsaiIcon);
    expect(
      tester.getTopLeft(find.text('Link')).dx -
          tester.getTopRight(icons.first).dx,
      4,
    );
    expect(
      tester.getTopLeft(icons.last).dx -
          tester.getTopRight(find.text('Link')).dx,
      4,
    );
  });

  testWidgets('maps default, active, and disabled Penpot colors', (
    tester,
  ) async {
    await _pump(
      tester,
      child: TsaiLink(
        label: 'Link',
        leadingIcon: const TsaiIcon(Icons.add, size: 16),
        onPressed: () {},
      ),
    );

    final foreground = tester
        .widget<TextButton>(find.byType(TextButton))
        .style!
        .foregroundColor!;
    expect(
      foreground.resolve({}),
      TsaiThemeTokens.dark.colors.actionPrimarySoft,
    );
    expect(
      foreground.resolve({WidgetState.hovered}),
      TsaiThemeTokens.dark.colors.actionPrimary,
    );
    expect(
      foreground.resolve({WidgetState.pressed}),
      TsaiThemeTokens.dark.colors.actionPrimary,
    );

    await _pump(
      tester,
      child: const TsaiLink(
        label: 'Link',
        leadingIcon: TsaiIcon(Icons.add, size: 16),
        onPressed: null,
      ),
    );
    final disabledForeground = tester
        .widget<TextButton>(find.byType(TextButton))
        .style!
        .foregroundColor!;
    expect(
      disabledForeground.resolve({WidgetState.disabled}),
      TsaiThemeTokens.dark.colors.contentTertiary,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is IconTheme &&
            widget.data.color == TsaiThemeTokens.dark.colors.iconTertiary,
      ),
      findsOneWidget,
    );
  });

  testWidgets('supports pointer, keyboard, and custom semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var calls = 0;
    await _pump(
      tester,
      child: TsaiLink(
        label: 'Visible label',
        semanticLabel: 'Open account',
        autofocus: true,
        onPressed: () => calls++,
      ),
    );
    await tester.pump();

    expect(find.bySemanticsLabel('Open account'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(calls, 1);

    await tester.tap(find.byType(TsaiLink));
    await tester.pump();
    expect(calls, 2);
    semantics.dispose();
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
