import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/demo/component_playground.dart';

void main() {
  const previewKey = ValueKey<String>('compact-preview');

  testWidgets('uses a compact bordered playground layout', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: ComponentPlayground(
            controls: [
              PlaygroundTextControl(
                label: 'label',
                value: 'Value',
                onChanged: _noopString,
              ),
              PlaygroundRadioGroup<bool>(
                label: 'enabled',
                value: true,
                options: const [(true, 'Yes'), (false, 'No')],
                onChanged: _noopBool,
              ),
            ],
            preview: const SizedBox.square(
              key: previewKey,
              dimension: 32,
              child: Text('Preview value'),
            ),
          ),
        ),
      ),
    );

    final section = tester.widget<Container>(
      find.byKey(const ValueKey('component-playground')),
    );
    final decoration = section.decoration! as BoxDecoration;
    expect(decoration.border, isA<Border>());
    expect(decoration.borderRadius, BorderRadius.circular(12));

    final controls = tester.widget<Wrap>(
      find.byKey(const ValueKey('component-playground-controls-wrap')),
    );
    expect(controls.spacing, 12);
    expect(controls.runSpacing, 12);
    expect(find.text('checkerboardBackground'), findsOneWidget);
    expect(find.byType(TsaiSwitch), findsOneWidget);

    final checkerboard = find.byKey(
      const ValueKey<String>('component-playground-checkerboard'),
    );
    expect(tester.widget<CustomPaint>(checkerboard).painter, isNotNull);

    final radioOptions = tester.widget<Wrap>(
      find.byKey(const ValueKey('playground-radio-options')),
    );
    expect(radioOptions.spacing, 8);
    expect(radioOptions.runSpacing, 0);
    expect(
      tester.getSize(
        find.byKey(const ValueKey('component-playground-preview')),
      ),
      const Size(766, 96),
    );
    expect(tester.getSize(find.byKey(previewKey)), const Size.square(32));

    await tester.tap(find.byType(TsaiSwitch));
    await tester.pump();
    expect(tester.widget<CustomPaint>(checkerboard).painter, isNull);
  });
}

void _noopString(String value) {}

void _noopBool(bool value) {}
