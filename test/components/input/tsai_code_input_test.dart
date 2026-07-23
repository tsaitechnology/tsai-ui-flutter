import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('OTP uses four Penpot cells and supports paste', (tester) async {
    final changes = <String>[];
    final completed = <String>[];
    await _pump(
      tester,
      child: TsaiOtpInput(
        autofocus: true,
        onChanged: changes.add,
        onCompleted: completed.add,
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('tsai-otp-cells')), findsOneWidget);
    for (var index = 0; index < 4; index++) {
      expect(tester.getSize(find.byKey(ValueKey(index))), const Size(56, 56));
    }
    expect(find.byKey(const ValueKey('tsai-otp-cursor')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('tsai-otp-editable')),
      '1234',
    );
    await tester.pump();
    expect(changes, ['1234']);
    expect(completed, ['1234']);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('OTP completion fires for each new completed sequence', (
    tester,
  ) async {
    final completed = <String>[];
    await _pump(tester, child: TsaiOtpInput(onCompleted: completed.add));
    final input = find.byKey(const ValueKey('tsai-otp-editable'));

    await tester.enterText(input, '1234');
    await tester.enterText(input, '123');
    await tester.enterText(input, '5678');
    await tester.pump();
    expect(completed, ['1234', '5678']);
  });

  testWidgets('OTP error, success, and disabled colors match tokens', (
    tester,
  ) async {
    await _pump(tester, child: const TsaiOtpInput(isError: true));
    expect(
      _cellDecoration(tester, 0).border,
      Border.all(color: TsaiThemeTokens.dark.colors.negative),
    );

    await _pump(tester, child: const TsaiOtpInput(isSuccess: true));
    expect(
      _cellDecoration(tester, 0).border,
      Border.all(color: TsaiThemeTokens.dark.colors.positive),
    );

    await _pump(tester, child: const TsaiOtpInput(enabled: false));
    expect(
      _cellDecoration(tester, 0).color,
      TsaiThemeTokens.dark.colors.surfaceRaised,
    );
  });

  testWidgets('PIN uses 12-pixel dots and reports completion', (tester) async {
    final completed = <String>[];
    await _pump(tester, child: TsaiPinInput(onCompleted: completed.add));

    expect(find.byKey(const ValueKey('tsai-pin-dots')), findsOneWidget);
    for (var index = 0; index < 4; index++) {
      expect(tester.getSize(find.byKey(ValueKey(index))), const Size(12, 12));
    }

    await tester.enterText(
      find.byKey(const ValueKey('tsai-pin-editable')),
      '9021',
    );
    await tester.pump();
    expect(completed, ['9021']);
    expect(
      _dotDecoration(tester, 0).color,
      TsaiThemeTokens.dark.colors.iconBright,
    );
  });

  testWidgets('PIN status colors affect every dot', (tester) async {
    await _pump(
      tester,
      child: const TsaiPinInput(initialValue: '12', isError: true),
    );
    for (var index = 0; index < 4; index++) {
      expect(
        _dotDecoration(tester, index).color,
        TsaiThemeTokens.dark.colors.negative,
      );
    }
  });

  testWidgets('code input filters non-digits and enforces custom length', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await _pump(tester, child: TsaiOtpInput(controller: controller, length: 6));

    await tester.enterText(
      find.byKey(const ValueKey('tsai-otp-editable')),
      '12a34-567',
    );
    await tester.pump();
    expect(controller.text, '123456');
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('six OTP cells fit a narrow mobile width', (tester) async {
    await _pump(
      tester,
      child: const SizedBox(width: 320, child: TsaiOtpInput(length: 6)),
    );

    final cells = [
      for (var index = 0; index < 6; index++)
        tester.getSize(find.byKey(ValueKey(index))),
    ];
    expect(cells, everyElement(isA<Size>()));
    expect(cells.every((size) => size.width == size.height), isTrue);
    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-otp-cells'))).width,
      lessThanOrEqualTo(320),
    );
  });
}

BoxDecoration _cellDecoration(WidgetTester tester, int index) =>
    tester.widget<AnimatedContainer>(find.byKey(ValueKey(index))).decoration!
        as BoxDecoration;

BoxDecoration _dotDecoration(WidgetTester tester, int index) =>
    tester.widget<AnimatedContainer>(find.byKey(ValueKey(index))).decoration!
        as BoxDecoration;

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
