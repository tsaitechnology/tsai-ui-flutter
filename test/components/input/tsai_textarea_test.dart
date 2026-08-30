import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  group('TsaiTextarea', () {
    testWidgets('matches Penpot field size and meta row', (tester) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiTextarea(
            placeholder: 'Label',
            description: 'Description',
            showCharacterCounter: true,
            maxLength: 500,
            initialValue: 'Hello',
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('tsai-textarea-layout')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('tsai-textarea-field')), findsOneWidget);
      expect(find.byKey(const ValueKey('tsai-textarea-meta')), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('5/500'), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const ValueKey('tsai-textarea-field'))),
        const Size(320, 120),
      );
    });

    testWidgets('hides the counter by default', (tester) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiTextarea(placeholder: 'Label', maxLength: 500),
        ),
      );
      expect(find.byKey(const ValueKey('tsai-textarea-counter')), findsNothing);
    });

    testWidgets('emits edits, wraps, and paints the error border', (
      tester,
    ) async {
      final changes = <String>[];
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiTextarea(
            placeholder: 'Label',
            description: 'Description',
            errorText: 'Too long',
            showCharacterCounter: true,
            maxLength: 500,
            onChanged: changes.add,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const ValueKey('tsai-textarea-editable')),
        'Value text that is long enough to wrap onto the second line.',
      );
      await tester.pump();
      expect(changes.last, contains('wrap onto the second line'));
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Too long'), findsNothing);

      final decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(const ValueKey('tsai-textarea-field')),
                  )
                  .decoration
              as BoxDecoration;
      expect(
        (decoration.border! as Border).top.color,
        TsaiThemeTokens.dark.colors.accentError,
      );
    });

    testWidgets('focused empty field raises the 13-pixel label', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiTextarea(placeholder: 'Label', focusNode: focusNode),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      final style = tester
          .widget<AnimatedDefaultTextStyle>(
            find.byKey(const ValueKey('tsai-textarea-placeholder')),
          )
          .style;
      expect(style.fontSize, 13);
    });

    testWidgets('disabled field rejects typing', (tester) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiTextarea(
            enabled: false,
            initialValue: 'Locked',
            placeholder: 'Label',
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('tsai-textarea-editable')),
        'Nope',
      );
      expect(find.text('Locked'), findsOneWidget);
      expect(find.text('Nope'), findsNothing);
    });

    testWidgets('respects a stretched field height', (tester) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiTextarea(placeholder: 'Note', fieldHeight: 180),
        ),
      );
      expect(
        tester
            .getSize(find.byKey(const ValueKey('tsai-textarea-field')))
            .height,
        180,
      );
    });

    testWidgets('exposes semantics for the placeholder', (tester) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiTextarea(placeholder: 'Comment'),
        ),
      );
      expect(tester.getSemantics(find.byType(TsaiTextarea)), isNotNull);
    });
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
