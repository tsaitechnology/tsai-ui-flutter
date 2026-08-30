import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets(
    'interactive chrome stays labeled and meets tap targets at 200% scale',
    (tester) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final semantics = tester.ensureSemantics();

      for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(390, 1600),
                textScaler: TextScaler.linear(2),
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TsaiAccordion(
                        title: 'Fees and limits',
                        body: 'Explains the fee schedule.',
                        expanded: false,
                        onChanged: (_) {},
                      ),
                      TsaiSelect<String>(
                        options: const [
                          TsaiSelectOption(value: 'uy', label: 'Uruguay'),
                        ],
                        value: 'uy',
                        onChanged: (_) {},
                        placeholder: 'Country',
                        semanticLabel: 'Country selector',
                      ),
                      TsaiChip(label: 'USD', onTap: () {}),
                      TsaiLink(label: 'View details', onPressed: () {}),
                      TsaiIconButton(
                        icon: const Icon(Icons.more_horiz),
                        semanticLabel: 'More actions',
                        onPressed: () {},
                      ),
                      TsaiSlider(
                        value: 0.4,
                        semanticLabel: 'Amount',
                        onChanged: (_) {},
                      ),
                      TsaiStepper(value: 2, onChanged: (_) {}),
                      const TsaiPageIndicator(count: 4, index: 1),
                      TsaiTabs(
                        sections: const [
                          TsaiTabSection(
                            tab: Text('Overview'),
                            content: SizedBox(height: 48),
                          ),
                          TsaiTabSection(
                            tab: Text('Activity'),
                            content: SizedBox(height: 48),
                          ),
                        ],
                      ),
                      BottomNavBar(
                        selectedIndex: 0,
                        onSelected: (_) {},
                        items: const [
                          BottomNavBarItem(
                            icon: TsaiIcon(Icons.home),
                            label: 'Home',
                          ),
                          BottomNavBarItem(
                            icon: TsaiIcon(Icons.credit_card),
                            label: 'Cards',
                          ),
                        ],
                      ),
                      TsaiNumericKeypad(
                        onDigit: (_) {},
                        onDecimal: () {},
                        onBackspace: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      }

      semantics.dispose();
    },
  );

  testWidgets('primary copy on canvas meets text contrast in both themes', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TsaiTextHeading(
                    'Create an account',
                    size: TsaiHeadingSize.large,
                  ),
                  const TsaiTextBody(
                    'Review current positions and recent activity.',
                    size: TsaiBodySize.medium,
                    weight: TsaiTextWeight.regular,
                  ),
                  TsaiCheckbox(
                    value: true,
                    label: 'Accept account terms',
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    semantics.dispose();
  });

  testWidgets('accordion header and keypad meet Android tap targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: Column(
            children: [
              TsaiAccordion(
                title: 'Fees and limits',
                body: 'Explains the fee schedule.',
                expanded: false,
                onChanged: (_) {},
              ),
              TsaiNumericKeypad(
                onDigit: (_) {},
                onDecimal: () {},
                onBackspace: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('page chrome and divider honor RTL start and end', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        builder: (context, child) =>
            Directionality(textDirection: TextDirection.rtl, child: child!),
        home: Scaffold(
          body: Column(
            children: [
              PageTopBar(
                title: 'Settings',
                leading: [
                  PageTopBarAction(
                    icon: const TsaiIcon(Icons.arrow_back),
                    semanticLabel: 'Back',
                    onPressed: _noop,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  key: const ValueKey<String>('divider-host'),
                  width: 342,
                  child: const TsaiDivider(indent: 16, endIndent: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final back = tester.getRect(find.bySemanticsLabel('Back'));
    final bar = tester.getRect(find.byType(PageTopBar));
    expect(back.center.dx, greaterThan(bar.center.dx));

    final host = tester.getRect(
      find.byKey(const ValueKey<String>('divider-host')),
    );
    final line = tester.getRect(
      find.byKey(const ValueKey<String>('tsai-divider')),
    );
    expect(line.left - host.left, 8);
    expect(host.right - line.right, 16);
  });
}

void _noop() {}
