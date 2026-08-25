import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class NumericKeypadDemoScreen extends StatelessWidget {
  const NumericKeypadDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.numericKeypad,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _NumericKeypadDemo(),
  );
}

class _NumericKeypadDemo extends StatefulWidget {
  const _NumericKeypadDemo();

  @override
  State<_NumericKeypadDemo> createState() => _NumericKeypadDemoState();
}

class _NumericKeypadDemoState extends State<_NumericKeypadDemo> {
  var _mode = TsaiKeypadMode.decimal;
  var _buffer = '';

  void _append(String value) => setState(() => _buffer += value);

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('numericKeypad-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: FittedBox(
          child: TsaiNumericKeypad(
            mode: _mode,
            onDigit: _append,
            onDecimal: () => _append('.'),
            onBackspace: () {
              if (_buffer.isEmpty) {
                return;
              }
              setState(
                () => _buffer = _buffer.substring(0, _buffer.length - 1),
              );
            },
            onBiometric: () => setState(() => _buffer = 'biometric'),
          ),
        ),
        controls: [
          PlaygroundRadioGroup<TsaiKeypadMode>(
            label: 'mode',
            value: _mode,
            options: const [
              (TsaiKeypadMode.decimal, 'Decimal'),
              (TsaiKeypadMode.integer, 'Integer'),
              (TsaiKeypadMode.pin, 'PIN'),
            ],
            onChanged: (value) => setState(() => _mode = value),
          ),
          PlaygroundOutput(
            label: 'value',
            value: _buffer.isEmpty ? '—' : _buffer,
          ),
        ],
      ),
    ],
  );
}
