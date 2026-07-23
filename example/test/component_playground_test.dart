import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/demo/component_playground.dart';

void main() {
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
            preview: const Text('Preview value'),
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
  });
}

void _noopString(String value) {}

void _noopBool(bool value) {}
