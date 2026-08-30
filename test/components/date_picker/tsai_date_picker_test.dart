import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  final today = DateTime(2026, 8, 30);

  group('TsaiCalendarDayCell', () {
    testWidgets('selected state uses the accent circle', (tester) async {
      await _pump(
        tester,
        child: const TsaiCalendarDayCell(
          label: '15',
          state: TsaiCalendarDayCellState.selected,
        ),
      );
      expect(find.text('15'), findsOneWidget);
      expect(
        tester.getSize(find.byType(TsaiCalendarDayCell)),
        const Size(44, 44),
      );
    });

    testWidgets('empty tails hide the label', (tester) async {
      await _pump(
        tester,
        child: const TsaiCalendarDayCell(
          label: '31',
          state: TsaiCalendarDayCellState.empty,
        ),
      );
      expect(find.text('31'), findsNothing);
    });
  });

  group('TsaiDatePeriodPicker', () {
    testWidgets('builds a 6-week August 2026 grid', (tester) async {
      await _pump(
        tester,
        child: TsaiDatePeriodPicker(
          now: today,
          initialPeriod: TsaiDatePeriod(
            start: DateTime(2026, 8, 5),
            end: DateTime(2026, 8, 13),
            granularity: TsaiDateGranularity.weekly,
          ),
        ),
      );
      expect(find.text('August 2026'), findsOneWidget);
      expect(find.text('Mo'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
      expect(find.byType(TsaiCalendarDayCell), findsNWidgets(42));
      expect(
        tester
            .getSize(find.byKey(const ValueKey('tsai-date-period-picker')))
            .width,
        342,
      );
    });

    testWidgets('packs weekdays and days with 44-pixel space-between cells', (
      tester,
    ) async {
      await _pump(tester, child: TsaiDatePeriodPicker(now: today));
      final weekdays = tester.getSize(
        find.byKey(const ValueKey('tsai-calendar-weekdays')),
      );
      expect(weekdays, const Size(342, 20));

      final first = tester.getTopLeft(find.byType(TsaiCalendarDayCell).first);
      final seventhRight = tester.getTopRight(
        find.byType(TsaiCalendarDayCell).at(6),
      );
      expect(seventhRight.dx - first.dx, 342);
    });

    testWidgets('first tap selects a day and second tap forms a range', (
      tester,
    ) async {
      TsaiDatePeriod? period;
      await _pump(
        tester,
        child: TsaiDatePeriodPicker(
          now: today,
          onChanged: (value) => period = value,
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pump();
      expect(period?.start, DateTime(2026, 8, 10));
      expect(period?.end, isNull);

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(period?.start, DateTime(2026, 8, 10));
      expect(period?.end, DateTime(2026, 8, 15));
    });

    testWidgets('future days are not selectable', (tester) async {
      TsaiDatePeriod? period;
      await _pump(
        tester,
        child: TsaiDatePeriodPicker(
          now: DateTime(2026, 8, 20),
          onChanged: (value) => period = value,
        ),
      );
      await tester.tap(find.text('25'));
      await tester.pump();
      expect(period, isNull);
    });

    testWidgets('monthly tiles disable months after today', (tester) async {
      await _pump(
        tester,
        child: TsaiDatePeriodPicker(
          now: today,
          granularity: TsaiDateGranularity.monthly,
        ),
      );
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Aug'), findsOneWidget);
      expect(find.text('Sep'), findsOneWidget);

      final sep = tester.widget<TsaiPickerTile>(
        find.widgetWithText(TsaiPickerTile, 'Sep'),
      );
      expect(sep.onPressed, isNull);
      expect(sep.state, TsaiPickerTileState.disabled);
    });

    testWidgets('next month chevron is disabled at the current period', (
      tester,
    ) async {
      await _pump(tester, child: TsaiDatePeriodPicker(now: today));
      final next = tester.widget<IconButton>(
        find.descendant(
          of: find.byKey(const ValueKey('tsai-calendar-next')),
          matching: find.byType(IconButton),
        ),
      );
      expect(next.onPressed, isNull);
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
      expect(find.byKey(const ValueKey('tsai-time-wheel')), findsOneWidget);
      expect(tester.getSize(find.byType(TsaiTimeWheel)), const Size(342, 220));
      expect(find.text(':'), findsOneWidget);
      final hour = tester.getRect(find.byKey(const ValueKey('tsai-time-hour')));
      final colon = tester.getRect(
        find.byKey(const ValueKey('tsai-time-colon')),
      );
      final minute = tester.getRect(
        find.byKey(const ValueKey('tsai-time-minute')),
      );
      expect(colon.width, 12);
      expect(colon.left - hour.right, 12);
      expect(minute.left - colon.right, 12);
      expect(minute.right - hour.left, 156);
    });

    testWidgets('minute step 15 exposes four values per hour', (tester) async {
      TimeOfDay? time;
      await _pump(
        tester,
        child: TsaiTimePicker(
          initialTime: const TimeOfDay(hour: 9, minute: 0),
          minuteStep: 15,
          onChanged: (value) => time = value,
        ),
      );
      expect(find.byType(TsaiTimeWheelColumn), findsNWidgets(2));
      expect(time, isNull);
    });
  });

  group('showTsaiDatePeriodPicker', () {
    testWidgets('commits on Apply and dismisses on Cancel', (tester) async {
      TsaiDatePeriod? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: TsaiTheme.dark(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TsaiButton(
                label: 'Open',
                onPressed: () async {
                  result = await showTsaiDatePeriodPicker(
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
      expect(find.text('Select period'), findsOneWidget);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result, isNull);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Select period'), findsNothing);
    });
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: Center(child: SingleChildScrollView(child: child)),
        ),
      ),
    );
