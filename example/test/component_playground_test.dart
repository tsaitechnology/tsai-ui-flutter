import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/demo/component_playground.dart';

void main() {
  const previewKey = ValueKey<String>('compact-preview');

  testWidgets('uses preview and controls columns on desktop', (tester) async {
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

    final controls = tester.widget<Column>(
      find.byKey(const ValueKey('component-playground-controls-wrap')),
    );
    expect(controls.crossAxisAlignment, CrossAxisAlignment.stretch);
    expect(find.text('checkerboardBackground'), findsNothing);
    expect(find.byType(TsaiSwitch), findsNothing);

    final checkerboard = find.byKey(
      const ValueKey<String>('component-playground-checkerboard'),
    );
    expect(tester.widget<CustomPaint>(checkerboard).painter, isNull);

    final radioOptions = tester.widget<Wrap>(
      find.byKey(const ValueKey('playground-radio-options')),
    );
    expect(radioOptions.spacing, 8);
    expect(radioOptions.runSpacing, 0);
    final previewSize = tester.getSize(
      find.byKey(const ValueKey('component-playground-preview')),
    );
    expect(previewSize.width, greaterThan(400));
    expect(previewSize.height, 160);
    expect(tester.getSize(find.byKey(previewKey)), const Size.square(32));

    await tester.tap(
      find.byKey(
        const ValueKey<String>('component-playground-checkerboard-toggle'),
      ),
    );
    await tester.pump();
    expect(tester.widget<CustomPaint>(checkerboard).painter, isNotNull);

    await tester.tap(
      find.byKey(
        const ValueKey<String>('component-playground-controls-toggle'),
      ),
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('component-playground-controls')),
      findsNothing,
    );
    expect(
      find.byKey(
        const ValueKey<String>('component-playground-controls-collapsed'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('starts with controls collapsed on mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: const Scaffold(
          body: ComponentPlayground(
            controls: [Text('Mobile control')],
            preview: Text('Mobile preview'),
          ),
        ),
      ),
    );

    expect(find.text('Mobile preview'), findsOneWidget);
    expect(find.text('Mobile control'), findsNothing);
    await tester.tap(
      find.byKey(
        const ValueKey<String>('component-playground-controls-toggle'),
      ),
    );
    await tester.pump();
    expect(find.text('Mobile control'), findsOneWidget);
  });
}

void _noopString(String value) {}

void _noopBool(bool value) {}
