import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('matches Penpot geometry and states', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _TestApp(child: TsaiSearchInput(focusNode: focusNode)),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-search-input-frame'))),
      const Size(800, 40),
    );
    var frame = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('tsai-search-input-frame')),
    );
    var decoration = frame.decoration! as BoxDecoration;
    expect(decoration.color, TsaiThemeTokens.dark.colors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(12));
    expect((decoration.border! as Border).top.color, const Color(0xFF24252E));

    focusNode.requestFocus();
    await tester.pumpAndSettle();
    frame = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('tsai-search-input-frame')),
    );
    decoration = frame.decoration! as BoxDecoration;
    expect((decoration.border! as Border).top.color, const Color(0xFF818CF8));
  });

  testWidgets('edits, submits, clears, and reports focus', (tester) async {
    final changes = <String>[];
    final submissions = <String>[];
    final focusChanges = <bool>[];
    var cleared = 0;

    await tester.pumpWidget(
      _TestApp(
        child: TsaiSearchInput(
          semanticLabel: 'Asset search',
          onChanged: changes.add,
          onSubmitted: submissions.add,
          onFocusChange: focusChanges.add,
          onCleared: () => cleared++,
        ),
      ),
    );

    final editable = find.byKey(
      const ValueKey<String>('tsai-search-input-editable'),
    );
    await tester.enterText(editable, 'btc');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(changes, ['btc']);
    expect(submissions, ['btc']);
    expect(focusChanges, contains(true));
    expect(find.byTooltip('Clear search'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(changes, ['btc', '']);
    expect(cleared, 1);
    expect(find.byTooltip('Clear search'), findsNothing);
  });

  testWidgets('disabled state is inert and uses the raised surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(child: TsaiSearchInput(enabled: false)),
    );

    final frame = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('tsai-search-input-frame')),
    );
    final decoration = frame.decoration! as BoxDecoration;
    expect(decoration.color, TsaiThemeTokens.dark.colors.surfaceRaised);
    expect(
      tester
          .widget<TextField>(
            find.byKey(const ValueKey('tsai-search-input-editable')),
          )
          .enabled,
      isFalse,
    );
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: TsaiTheme.dark(),
    home: Scaffold(body: Center(child: child)),
  );
}
