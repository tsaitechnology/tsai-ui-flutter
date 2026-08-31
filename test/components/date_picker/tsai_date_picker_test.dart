import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  final today = DateTime(2026, 8, 30);

  group('TsaiCalendarPicker', () {
    testWidgets('builds a 6-week August 2026 grid without granularity tabs', (
      tester,
    ) async {
      await _pump(
        tester,
        child: TsaiCalendarPicker(
          now: today,
          initialRange: DateTimeRange(
            start: DateTime(2026, 8, 5),
            end: DateTime(2026, 8, 13),
          ),
          kind: TsaiCalendarKind.dateRange,
        ),
      );
      expect(find.text('Weekly'), findsNothing);
      expect(find.text('August'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Mo'), findsOneWidget);
      expect(find.byType(TsaiCalendarDayCell), findsNWidgets(42));
      expect(
        tester
            .getSize(find.byKey(const ValueKey('tsai-calendar-picker')))
            .width,
        342,
      );
    });

    testWidgets('packs weekdays and days with 44-pixel space-between cells', (
      tester,
    ) async {
      await _pump(tester, child: TsaiCalendarPicker(now: today));
      expect(
        tester.getSize(find.byKey(const ValueKey('tsai-calendar-weekdays'))),
        const Size(342, 20),
      );
      final first = tester.getTopLeft(find.byType(TsaiCalendarDayCell).first);
      final seventhRight = tester.getTopRight(
        find.byType(TsaiCalendarDayCell).at(6),
      );
      expect(seventhRight.dx - first.dx, 342);
    });

    testWidgets('single-day kind keeps one selected date', (tester) async {
      DateTime? date;
      await _pump(
        tester,
        child: TsaiCalendarPicker(
          now: today,
          onDateChanged: (value) => date = value,
        ),
      );
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(date, DateTime(2026, 8, 10));
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(date, DateTime(2026, 8, 15));
    });

    testWidgets(
      'range kind uses an array of two days, then resets on a third',
      (tester) async {
        DateTimeRange? range;
        await _pump(
          tester,
          child: TsaiCalendarPicker(
            now: today,
            kind: TsaiCalendarKind.dateRange,
            onRangeChanged: (value) => range = value,
          ),
        );
        await tester.tap(find.text('15'));
        await tester.pump();
        expect(range, isNull);
        await tester.tap(find.text('10'));
        await tester.pump();
        expect(range?.start, DateTime(2026, 8, 10));
        expect(range?.end, DateTime(2026, 8, 15));
        await tester.tap(find.text('20'));
        await tester.pump();
        expect(range, isNull);
      },
    );

    testWidgets('firstDate and lastDate disable days outside the window', (
      tester,
    ) async {
      DateTime? date;
      await _pump(
        tester,
        child: TsaiCalendarPicker(
          now: today,
          firstDate: DateTime(2026, 8, 10),
          lastDate: DateTime(2026, 8, 20),
          onDateChanged: (value) => date = value,
        ),
      );
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(date, isNull);
      await tester.tap(find.text('31'));
      await tester.pump();
      expect(date, isNull);
      await tester.tap(find.text('12'));
      await tester.pump();
      expect(date, DateTime(2026, 8, 12));
    });

    testWidgets('month button opens months, then a month returns to days', (
      tester,
    ) async {
      await _pump(tester, child: TsaiCalendarPicker(now: today));
      await tester.tap(
        find.byKey(const ValueKey('tsai-calendar-month-button')),
      );
      await tester.pump();
      expect(find.text('Mo'), findsNothing);
      expect(find.byType(TsaiPickerTile), findsNWidgets(12));
      await tester.tap(find.text('Jan'));
      await tester.pump();
      expect(find.text('January'), findsOneWidget);
      expect(find.text('Mo'), findsOneWidget);
    });

    testWidgets('year then month then day follows 4.3', (tester) async {
      DateTime? date;
      await _pump(
        tester,
        child: TsaiCalendarPicker(
          now: today,
          firstDate: DateTime(2020, 1, 1),
          lastDate: DateTime(2026, 8, 30),
          onDateChanged: (value) => date = value,
        ),
      );
      await tester.tap(find.byKey(const ValueKey('tsai-calendar-year-button')));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('tsai-calendar-year-button')),
        findsNothing,
      );
      await tester.tap(find.text('2024'));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('tsai-calendar-year-button')),
        findsOneWidget,
      );
      await tester.tap(find.text('Mar'));
      await tester.pump();
      expect(find.text('March'), findsOneWidget);
      await tester.tap(find.text('12'));
      await tester.pump();
      expect(date, DateTime(2024, 3, 12));
    });

    testWidgets('month kind stays on the month grid after a tap', (
      tester,
    ) async {
      DateTime? month;
      await _pump(
        tester,
        child: TsaiCalendarPicker(
          now: today,
          kind: TsaiCalendarKind.month,
          onMonthChanged: (value) => month = value,
        ),
      );
      expect(find.byType(TsaiPickerTile), findsNWidgets(12));
      await tester.tap(find.text('Sep'));
      await tester.pump();
      expect(month, DateTime(2026, 9));
      expect(find.text('Mo'), findsNothing);
    });

    testWidgets('year kind stays on the year grid after a tap', (tester) async {
      int? year;
      await _pump(
        tester,
        child: TsaiCalendarPicker(
          now: today,
          kind: TsaiCalendarKind.year,
          firstDate: DateTime(2015, 1, 1),
          onYearChanged: (value) => year = value,
        ),
      );
      await tester.tap(find.text('2024'));
      await tester.pump();
      expect(year, 2024);
      expect(find.byType(TsaiPickerTile), findsNWidgets(12));
    });
  });

  group('showTsaiDatePicker', () {
    testWidgets('sizes the sheet to the calendar, not the viewport', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(_sheetHost(today));
      await tester.tap(find.text('Open date'));
      await tester.pumpAndSettle();
      final height = tester.getSize(find.byType(TsaiBottomSheet)).height;
      expect(height, lessThan(700));
      expect(height, greaterThan(400));
    });

    testWidgets('Apply stays disabled until a day is chosen', (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: TsaiTheme.dark(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TsaiButton(
                label: 'Open',
                onPressed: () async {
                  result = await showTsaiDatePicker(
                    context: context,
                    now: today,
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TsaiButton>(find.byKey(const ValueKey('tsai-picker-apply')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isNull);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('12'));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tsai-picker-apply')));
      await tester.pumpAndSettle();
      expect(result, DateTime(2026, 8, 12));
    });
  });

  group('TsaiTimePicker', () {
    testWidgets('renders a 342×220 wheel', (tester) async {
      await _pump(
        tester,
        child: const TsaiTimePicker(
          initialTime: TimeOfDay(hour: 15, minute: 30),
        ),
      );
      expect(tester.getSize(find.byType(TsaiTimeWheel)), const Size(342, 220));
      final hour = tester.getRect(find.byKey(const ValueKey('tsai-time-hour')));
      final colon = tester.getRect(
        find.byKey(const ValueKey('tsai-time-colon')),
      );
      final minute = tester.getRect(
        find.byKey(const ValueKey('tsai-time-minute')),
      );
      expect(colon.left - hour.right, 12);
      expect(minute.left - colon.right, 12);
    });
  });

  group('picker fields', () {
    testWidgets('date field commits through Apply', (tester) async {
      DateTime? value;
      await tester.pumpWidget(
        MaterialApp(
          theme: TsaiTheme.dark(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => TsaiDateField(
                now: today,
                lastDate: today,
                value: value,
                onChanged: (next) => setState(() => value = next),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('tsai-date-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('12'));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tsai-picker-apply')));
      await tester.pumpAndSettle();
      expect(value, DateTime(2026, 8, 12));
      expect(find.textContaining('12'), findsWidgets);
    });

    testWidgets('range field stays empty until two days and Apply', (
      tester,
    ) async {
      DateTimeRange? value;
      await tester.pumpWidget(
        MaterialApp(
          theme: TsaiTheme.dark(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => TsaiDateRangeField(
                now: today,
                lastDate: today,
                value: value,
                onChanged: (next) => setState(() => value = next),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('tsai-date-range-field')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TsaiButton>(find.byKey(const ValueKey('tsai-picker-apply')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(
        tester
            .widget<TsaiButton>(find.byKey(const ValueKey('tsai-picker-apply')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('12'));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tsai-picker-apply')));
      await tester.pumpAndSettle();
      expect(value?.start, DateTime(2026, 8, 10));
      expect(value?.end, DateTime(2026, 8, 12));
    });
  });
}

Widget _sheetHost(DateTime today) => MaterialApp(
  theme: TsaiTheme.dark(),
  home: Scaffold(
    body: Builder(
      builder: (context) => TsaiButton(
        label: 'Open date',
        onPressed: () => showTsaiDatePicker(context: context, now: today),
      ),
    ),
  ),
);

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: Center(child: SingleChildScrollView(child: child)),
        ),
      ),
    );
