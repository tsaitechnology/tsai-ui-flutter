import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  final today = DateTime(2026, 8, 30);

  group('shared field plate hit targets', () {
    testWidgets('TsaiInput focuses from every plate inset', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiInput(focusNode: focusNode, placeholder: 'Email'),
        ),
      );
      await _tapPlateInsets(
        tester,
        find.byKey(const ValueKey('tsai-input-field')),
      );
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('TsaiSearchInput focuses from the icon gutter', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiSearchInput(focusNode: focusNode),
        ),
      );
      final frame = tester.getRect(
        find.byKey(const ValueKey('tsai-search-input-frame')),
      );
      await tester.tapAt(frame.topLeft + const Offset(8, 8));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('TsaiTextarea focuses from empty padding', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiTextarea(focusNode: focusNode, placeholder: 'Note'),
        ),
      );
      final field = tester.getRect(
        find.byKey(const ValueKey('tsai-textarea-field')),
      );
      await tester.tapAt(Offset(field.right - 8, field.top + 8));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('TsaiSelect opens from the trailing chevron', (tester) async {
      await _pump(
        tester,
        child: SizedBox(
          width: 320,
          child: TsaiSelect<String>(
            placeholder: 'Country',
            value: null,
            options: const [TsaiSelectOption(value: 'uy', label: 'Uruguay')],
            onChanged: (_) {},
          ),
        ),
      );
      final field = tester.getRect(
        find.byKey(const ValueKey('tsai-select-field')),
      );
      await tester.tapAt(Offset(field.right - 8, field.center.dy));
      await tester.pumpAndSettle();
      expect(find.text('Uruguay'), findsOneWidget);
    });
  });

  group('picker fields open from the full plate', () {
    testWidgets('TsaiDateField opens from leading padding and trailing icon', (
      tester,
    ) async {
      await _pumpPickerField(
        tester,
        child: TsaiDateField(now: today, lastDate: today),
      );
      await _expectSheetFromPlate(
        tester,
        find.byKey(const ValueKey('tsai-input-field')),
        'Select date',
      );
    });

    testWidgets('TsaiDateRangeField opens from the trailing edge', (
      tester,
    ) async {
      await _pumpPickerField(
        tester,
        child: TsaiDateRangeField(now: today, lastDate: today),
      );
      await _expectSheetFromPlate(
        tester,
        find.byKey(const ValueKey('tsai-input-field')),
        'Select period',
      );
    });

    testWidgets('TsaiTimeField opens from the trailing edge', (tester) async {
      await _pumpPickerField(tester, child: const TsaiTimeField());
      await _expectSheetFromPlate(
        tester,
        find.byKey(const ValueKey('tsai-input-field')),
        'Select time',
      );
    });

    testWidgets('TsaiMonthField opens from the trailing edge', (tester) async {
      await _pumpPickerField(tester, child: TsaiMonthField(now: today));
      await _expectSheetFromPlate(
        tester,
        find.byKey(const ValueKey('tsai-input-field')),
        'Select month',
      );
    });

    testWidgets('TsaiYearField opens from the trailing edge', (tester) async {
      await _pumpPickerField(
        tester,
        child: TsaiYearField(now: today, firstDate: DateTime(2015)),
      );
      await _expectSheetFromPlate(
        tester,
        find.byKey(const ValueKey('tsai-input-field')),
        'Select year',
      );
    });
  });
}

Future<void> _tapPlateInsets(WidgetTester tester, Finder field) async {
  final rect = tester.getRect(field);
  for (final point in [
    rect.topLeft + const Offset(8, 8),
    Offset(rect.right - 8, rect.top + 8),
    Offset(rect.left + 8, rect.bottom - 8),
    Offset(rect.right - 8, rect.bottom - 8),
  ]) {
    await tester.tapAt(point);
    await tester.pump();
  }
}

Future<void> _expectSheetFromPlate(
  WidgetTester tester,
  Finder field,
  String title,
) async {
  final rect = tester.getRect(field);
  await tester.tapAt(rect.topLeft + const Offset(8, 8));
  await tester.pumpAndSettle();
  expect(find.text(title), findsOneWidget);
  await tester.tap(find.text('Cancel'));
  await tester.pumpAndSettle();

  await tester.tapAt(Offset(rect.right - 10, rect.center.dy));
  await tester.pumpAndSettle();
  expect(find.text(title), findsOneWidget);
}

Future<void> _pumpPickerField(WidgetTester tester, {required Widget child}) =>
    _pump(tester, child: SizedBox(width: 320, child: child));

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
