import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('core form remains usable at 320 pixels and 200% text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 1200);
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
              size: Size(320, 1200),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TsaiTextHeading(
                      'Create an account',
                      size: TsaiHeadingSize.large,
                    ),
                    const SizedBox(height: 16),
                    const TsaiInput(
                      placeholder: 'Email address',
                      semanticLabel: 'Email address',
                    ),
                    const SizedBox(height: 16),
                    TsaiSelect<String>(
                      options: const [
                        TsaiSelectOption(value: 'uy', label: 'Uruguay'),
                      ],
                      value: 'uy',
                      onChanged: (_) {},
                      placeholder: 'Country',
                    ),
                    const SizedBox(height: 16),
                    TsaiCheckbox(
                      value: true,
                      label: 'Accept account terms',
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 16),
                    TsaiButton(
                      label: 'Create account',
                      isExpanded: true,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 16),
                    const TsaiTextCaption(
                      'Account status',
                      size: TsaiCaptionSize.small,
                      weight: TsaiTextWeight.regular,
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
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    }

    semantics.dispose();
  });
}
