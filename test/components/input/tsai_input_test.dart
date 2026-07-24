import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  group('TsaiInput', () {
    testWidgets('matches Penpot hierarchy and emits editing events', (
      tester,
    ) async {
      final changes = <String>[];
      final focus = <bool>[];
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiInput(
            placeholder: 'Label',
            description: 'Description',
            autofocus: true,
            onChanged: changes.add,
            onFocusChange: focus.add,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const ValueKey('tsai-input-layout')), findsOneWidget);
      expect(find.byKey(const ValueKey('tsai-input-field')), findsOneWidget);
      expect(find.byKey(const ValueKey('tsai-input-content')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('tsai-input-description')),
        findsOneWidget,
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('tsai-input-field'))),
        const Size(320, 56),
      );
      expect(focus, contains(true));

      await tester.enterText(
        find.byKey(const ValueKey('tsai-input-editable')),
        'Portfolio',
      );
      await tester.pump();
      expect(changes, contains('Portfolio'));
      expect(find.byKey(const ValueKey('tsai-input-clear')), findsOneWidget);
    });

    testWidgets('password visibility is opt-in and reports changes', (
      tester,
    ) async {
      final obscureChanges = <bool>[];
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiInput(initialValue: 'secret'),
        ),
      );
      expect(find.byKey(const ValueKey('tsai-input-visibility')), findsNothing);

      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiInput(
            initialValue: 'secret',
            obscureText: true,
            onObscureChanged: obscureChanges.add,
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('tsai-input-visibility')),
        findsOneWidget,
      );
      expect(_editable(tester).obscureText, isTrue);

      await tester.tap(find.byTooltip('Show value'));
      await tester.pump();
      expect(_editable(tester).obscureText, isFalse);
      expect(obscureChanges, [false]);

      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiInput(
            initialValue: 'secret',
            showVisibilityButton: true,
            onObscureChanged: obscureChanges.add,
          ),
        ),
      );
      expect(_editable(tester).obscureText, isFalse);
      await tester.tap(find.byTooltip('Hide value'));
      await tester.pump();
      expect(_editable(tester).obscureText, isTrue);
      expect(obscureChanges, [false, true]);
    });

    testWidgets('clear action emits empty value and callback', (tester) async {
      final changes = <String>[];
      var clears = 0;
      final controller = TextEditingController(text: 'Value');
      addTearDown(controller.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiInput(
            controller: controller,
            onChanged: changes.add,
            onCleared: () => clears++,
          ),
        ),
      );

      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(changes, ['']);
      expect(clears, 1);
    });

    testWidgets('error state replaces description and uses error border', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiInput(
            placeholder: 'Email',
            description: 'Description',
            errorText: 'Invalid email',
          ),
        ),
      );

      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Description'), findsNothing);
      final decoration =
          tester
                  .widget<AnimatedContainer>(
                    find.byKey(const ValueKey('tsai-input-field')),
                  )
                  .decoration
              as BoxDecoration;
      expect(
        (decoration.border! as Border).top.color,
        TsaiThemeTokens.dark.colors.negative,
      );
    });

    testWidgets('exposes custom input semantics without hiding edit actions', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiInput(semanticLabel: 'Account password'),
        ),
      );

      expect(find.bySemanticsLabel('Account password'), findsOneWidget);
      expect(find.byType(EditableText), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('animates placeholder between centered and labeled positions', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiInput(focusNode: focusNode, placeholder: 'Email'),
        ),
      );

      expect(
        _alignment(tester, 'tsai-input-placeholder-position'),
        AlignmentDirectional.centerStart,
      );
      expect(
        _alignment(tester, 'tsai-input-value-position'),
        AlignmentDirectional.centerStart,
      );
      expect(
        tester
            .widget<AnimatedAlign>(
              find.byKey(const ValueKey('tsai-input-placeholder-position')),
            )
            .duration,
        const Duration(milliseconds: 210),
      );
      expect(_inputBorder(tester).top.width, 1);

      final field = find.byKey(const ValueKey('tsai-input-field'));
      await tester.tapAt(tester.getTopLeft(field) + const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      expect(
        _alignment(tester, 'tsai-input-placeholder-position'),
        const AlignmentDirectional(-1, -0.45),
      );
      expect(
        _alignment(tester, 'tsai-input-value-position'),
        const AlignmentDirectional(-1, 0.45),
      );
      expect(_inputBorder(tester).top.width, 1);
    });

    testWidgets('keeps value centered when labeledPlaceholder is false', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiInput(placeholder: 'Search', labeledPlaceholder: false),
        ),
      );

      await tester.enterText(
        find.byKey(const ValueKey('tsai-input-editable')),
        'Query',
      );
      await tester.pumpAndSettle();

      expect(
        _alignment(tester, 'tsai-input-value-position'),
        AlignmentDirectional.centerStart,
      );
      final opacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.byKey(const ValueKey('tsai-input-placeholder')),
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(opacity.opacity, 0);
    });

    testWidgets('has no placeholder layer when placeholder is omitted', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const SizedBox(width: 320, child: TsaiInput()),
      );

      expect(
        find.byKey(const ValueKey('tsai-input-placeholder')),
        findsNothing,
      );
    });
  });

  group('TsaiPhoneInputFormatter', () {
    test('formats typing, paste, and enforces the mask length', () {
      final formatter = TsaiPhoneInputFormatter();

      expect(formatter.format('5'), '5');
      expect(formatter.format('5551'), '555 1');
      expect(formatter.format('+1 (555) 123-4567'), '155 512 34 56');
      expect(
        formatter
            .formatEditUpdate(
              TextEditingValue.empty,
              const TextEditingValue(
                text: '555123456789',
                selection: TextSelection.collapsed(offset: 12),
              ),
            )
            .text,
        '555 123 45 67',
      );
    });

    test('backspace over a separator removes the preceding digit', () {
      final formatter = TsaiPhoneInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '555 1',
          selection: TextSelection.collapsed(offset: 4),
        ),
        const TextEditingValue(
          text: '5551',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );

      expect(result.text, '551');
      expect(result.selection.extentOffset, 3);
    });

    test('delete over a separator removes the following digit', () {
      final formatter = TsaiPhoneInputFormatter();
      final result = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '555 1',
          selection: TextSelection.collapsed(offset: 3),
        ),
        const TextEditingValue(
          text: '5551',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );

      expect(result.text, '555');
      expect(result.selection.extentOffset, 3);
    });

    test('preserves a digit-based selection through formatting', () {
      final formatter = TsaiPhoneInputFormatter();
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(
          text: '555123',
          selection: TextSelection(baseOffset: 1, extentOffset: 5),
        ),
      );

      expect(result.text, '555 123');
      expect(
        result.selection,
        const TextSelection(baseOffset: 1, extentOffset: 6),
      );
    });
  });

  group('TsaiPhoneInput', () {
    testWidgets('keeps Penpot country, divider, and value structure', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiPhoneInput(description: 'Description'),
        ),
      );

      expect(find.byKey(const ValueKey('tsai-phone-row')), findsOneWidget);
      expect(find.byKey(const ValueKey('tsai-phone-country')), findsOneWidget);
      expect(find.byKey(const ValueKey('tsai-phone-divider')), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('000 000 00 00'), findsOneWidget);
    });

    testWidgets('formats edits and reports completion once per full value', (
      tester,
    ) async {
      final changes = <String>[];
      final completed = <String>[];
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiPhoneInput(
            onChanged: changes.add,
            onCompleted: completed.add,
          ),
        ),
      );

      final field = find.byKey(const ValueKey('tsai-phone-value-editable'));
      await tester.enterText(field, '5551234567');
      await tester.pump();
      expect(changes.last, '555 123 45 67');
      expect(completed, ['555 123 45 67']);

      await tester.enterText(field, '555123456');
      await tester.enterText(field, '5551234567');
      await tester.pump();
      expect(completed, ['555 123 45 67', '555 123 45 67']);
    });

    testWidgets('reports country edits and clears only national number', (
      tester,
    ) async {
      final countryChanges = <String>[];
      final country = TextEditingController(text: '598');
      final phone = TextEditingController(text: '99123456');
      addTearDown(country.dispose);
      addTearDown(phone.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiPhoneInput(
            controller: phone,
            countryCodeController: country,
            onCountryCodeChanged: countryChanges.add,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const ValueKey('tsai-phone-country-editable')),
        '54',
      );
      await tester.pump();
      expect(countryChanges, ['54']);

      await tester.tap(find.byTooltip('Clear phone number'));
      await tester.pump();
      expect(phone.text, isEmpty);
      expect(country.text, '54');
    });

    testWidgets(
      'updates country-code width without an intermediate animation',
      (tester) async {
        await _pump(
          tester,
          child: const SizedBox(width: 320, child: TsaiPhoneInput()),
        );
        const widthKey = ValueKey<String>('tsai-phone-country-width');
        final initialWidth = tester.getSize(find.byKey(widthKey)).width;

        await tester.enterText(
          find.byKey(const ValueKey('tsai-phone-country-editable')),
          '598',
        );
        await tester.pump();
        final updatedWidth = tester.getSize(find.byKey(widthKey)).width;

        expect(updatedWidth, greaterThan(initialWidth));
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.getSize(find.byKey(widthKey)).width, updatedWidth);
      },
    );

    testWidgets('uses the national number as its only tab stop', (
      tester,
    ) async {
      final before = FocusNode(debugLabel: 'before phone');
      final national = FocusNode(debugLabel: 'phone national number');
      final after = FocusNode(debugLabel: 'after phone');
      addTearDown(before.dispose);
      addTearDown(national.dispose);
      addTearDown(after.dispose);
      await _pump(
        tester,
        child: Column(
          children: [
            TextField(focusNode: before),
            SizedBox(width: 320, child: TsaiPhoneInput(focusNode: national)),
            TextField(focusNode: after),
          ],
        ),
      );

      before.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(national.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(after.hasFocus, isTrue);
    });

    testWidgets('moves to the country code on backspace from an empty number', (
      tester,
    ) async {
      final national = FocusNode(debugLabel: 'phone national number');
      addTearDown(national.dispose);
      await _pump(
        tester,
        child: SizedBox(width: 320, child: TsaiPhoneInput(focusNode: national)),
      );

      final nationalField = find.byKey(
        const ValueKey('tsai-phone-value-editable'),
      );
      await tester.tap(nationalField);
      await tester.enterText(nationalField, '');
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();

      final countryField = tester.widget<TextField>(
        find.byKey(const ValueKey('tsai-phone-country-editable')),
      );
      expect(countryField.focusNode!.hasFocus, isTrue);
      expect(countryField.controller!.selection.isCollapsed, isTrue);
      expect(
        countryField.controller!.selection.extentOffset,
        countryField.controller!.text.length,
      );
    });

    testWidgets('keeps both native editables in the semantic tree', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pump(
        tester,
        child: const SizedBox(
          width: 320,
          child: TsaiPhoneInput(semanticLabel: 'Mobile phone'),
        ),
      );

      expect(find.bySemanticsLabel('Mobile phone'), findsOneWidget);
      expect(find.byType(EditableText), findsNWidgets(2));
      semantics.dispose();
    });

    final hitCases =
        <
          ({
            String name,
            bool country,
            Offset Function(Rect field, Rect divider) point,
          })
        >[
          (
            name: 'leftmost pixel',
            country: true,
            point: (field, divider) =>
                Offset(field.left + 0.5, field.top + 0.5),
          ),
          (
            name: 'left edge inset',
            country: true,
            point: (field, divider) =>
                Offset(field.left + 2.5, field.center.dy),
          ),
          (
            name: 'left area center',
            country: true,
            point: (field, divider) =>
                Offset((field.left + divider.left) / 2, field.center.dy),
          ),
          (
            name: 'before divider',
            country: true,
            point: (field, divider) =>
                Offset(divider.left - 0.5, field.center.dy),
          ),
          (
            name: 'after divider',
            country: false,
            point: (field, divider) =>
                Offset(divider.right + 0.5, field.center.dy),
          ),
          (
            name: 'right area center',
            country: false,
            point: (field, divider) =>
                Offset((divider.right + field.right) / 2, field.top + 2.5),
          ),
          (
            name: 'right edge inset',
            country: false,
            point: (field, divider) =>
                Offset(field.right - 2.5, field.bottom - 2.5),
          ),
          (
            name: 'rightmost pixel',
            country: false,
            point: (field, divider) =>
                Offset(field.right - 0.5, field.center.dy),
          ),
        ];
    for (final hitCase in hitCases) {
      testWidgets('keeps phone focus after repeated taps at ${hitCase.name}', (
        tester,
      ) async {
        final national = FocusNode();
        addTearDown(national.dispose);
        await _pump(
          tester,
          child: SizedBox(
            width: 320,
            child: TsaiPhoneInput(focusNode: national),
          ),
        );

        final fieldRect = tester.getRect(
          find.byKey(const ValueKey('tsai-input-field')),
        );
        final dividerRect = tester.getRect(
          find.byKey(const ValueKey('tsai-phone-divider')),
        );
        final countryField = tester.widget<TextField>(
          find.byKey(const ValueKey('tsai-phone-country-editable')),
        );
        final point = hitCase.point(fieldRect, dividerRect);

        for (var tap = 1; tap <= 2; tap++) {
          await tester.tapAt(point);
          await tester.pump();

          expect(
            countryField.focusNode!.hasFocus,
            hitCase.country,
            reason: 'country focus after tap $tap at $point',
          );
          expect(
            national.hasFocus,
            !hitCase.country,
            reason: 'national focus after tap $tap at $point',
          );
        }
      });
    }
  });
}

TextField _editable(WidgetTester tester) =>
    tester.widget<TextField>(find.byKey(const ValueKey('tsai-input-editable')));

AlignmentGeometry _alignment(WidgetTester tester, String key) =>
    tester.widget<AnimatedAlign>(find.byKey(ValueKey<String>(key))).alignment;

Border _inputBorder(WidgetTester tester) {
  final decoration =
      tester
              .widget<AnimatedContainer>(
                find.byKey(const ValueKey('tsai-input-field')),
              )
              .decoration
          as BoxDecoration;
  return decoration.border! as Border;
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
