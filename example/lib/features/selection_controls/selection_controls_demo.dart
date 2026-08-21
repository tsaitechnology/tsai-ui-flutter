import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({super.key});

  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  bool? _value = false;
  String _label = 'Label';
  String _description = '';
  bool _enabled = true;
  bool _error = false;
  bool _tristate = false;
  TsaiControlLabelPosition _position = TsaiControlLabelPosition.right;
  String _event = 'No events';

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'checkbox-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'label',
          value: _label,
          onChanged: (value) => setState(() => _label = value),
        ),
        _TextProperty(
          label: 'description',
          value: _description,
          onChanged: (value) => setState(() => _description = value),
        ),
        _LabelPosition(
          value: _position,
          onChanged: (value) => setState(() => _position = value),
        ),
        PlaygroundRadioGroup<String>(
          label: 'value',
          value: _value?.toString() ?? 'null',
          options: const [
            ('false', 'False'),
            ('true', 'True'),
            ('null', 'Null'),
          ],
          onChanged: (value) => setState(() {
            _value = switch (value) {
              'true' => true,
              'false' => false,
              _ => null,
            };
            if (_value == null) {
              _tristate = true;
            }
          }),
        ),
        _Toggle(
          label: 'enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        _Toggle(
          label: 'Error state',
          value: _error,
          onChanged: (value) => setState(() => _error = value),
        ),
        _Toggle(
          label: 'tristate',
          value: _tristate,
          onChanged: (value) => setState(() {
            _tristate = value;
            if (!value && _value == null) _value = false;
          }),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiCheckbox(
        value: _value,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        labelPosition: _position,
        tristate: _tristate,
        isError: _error,
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
        onChanged: _enabled
            ? (value) => setState(() {
                _value = value;
                _event = 'onChanged($value)';
              })
            : null,
      ),
    ),
  );
}

class RadioDemo extends StatefulWidget {
  const RadioDemo({super.key});

  @override
  State<RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<RadioDemo> {
  bool _selected = false;
  String _label = 'Label';
  String _description = '';
  bool _enabled = true;
  bool _error = false;
  TsaiControlLabelPosition _position = TsaiControlLabelPosition.right;
  String _event = 'No events';

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'radio-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'label',
          value: _label,
          onChanged: (value) => setState(() => _label = value),
        ),
        _TextProperty(
          label: 'description',
          value: _description,
          onChanged: (value) => setState(() => _description = value),
        ),
        _LabelPosition(
          value: _position,
          onChanged: (value) => setState(() => _position = value),
        ),
        _Toggle(
          label: 'selected',
          value: _selected,
          onChanged: (value) => setState(() => _selected = value),
        ),
        _Toggle(
          label: 'enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        _Toggle(
          label: 'Error state',
          value: _error,
          onChanged: (value) => setState(() => _error = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiRadio<String>(
        value: 'value',
        groupValue: _selected ? 'value' : null,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        labelPosition: _position,
        isError: _error,
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
        onChanged: _enabled
            ? (value) => setState(() {
                _selected = value == 'value';
                _event = 'onChanged($value)';
              })
            : null,
      ),
    ),
  );
}

class SwitchDemo extends StatefulWidget {
  const SwitchDemo({super.key});

  @override
  State<SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool _value = false;
  String _label = 'Label';
  String _description = '';
  bool _enabled = true;
  TsaiControlLabelPosition _position = TsaiControlLabelPosition.right;
  String _event = 'No events';

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'switch-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'label',
          value: _label,
          onChanged: (value) => setState(() => _label = value),
        ),
        _TextProperty(
          label: 'description',
          value: _description,
          onChanged: (value) => setState(() => _description = value),
        ),
        _LabelPosition(
          value: _position,
          onChanged: (value) => setState(() => _position = value),
        ),
        _Toggle(
          label: 'value',
          value: _value,
          onChanged: (value) => setState(() => _value = value),
        ),
        _Toggle(
          label: 'enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiSwitch(
        value: _value,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        labelPosition: _position,
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
        onChanged: _enabled
            ? (value) => setState(() {
                _value = value;
                _event = 'onChanged($value)';
              })
            : null,
      ),
    ),
  );
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({required this.pageKey, required this.playground});
  final String pageKey;
  final Widget playground;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: ValueKey<String>(pageKey),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [playground],
    );
  }
}

class _TextProperty extends StatelessWidget {
  const _TextProperty({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) =>
      PlaygroundTextControl(label: label, value: value, onChanged: onChanged);
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => PlaygroundToggleControl(
    label: label,
    width: 140,
    value: value,
    onChanged: onChanged,
  );
}

class _LabelPosition extends StatelessWidget {
  const _LabelPosition({required this.value, required this.onChanged});
  final TsaiControlLabelPosition value;
  final ValueChanged<TsaiControlLabelPosition> onChanged;

  @override
  Widget build(BuildContext context) =>
      PlaygroundRadioGroup<TsaiControlLabelPosition>(
        label: 'Label position',
        value: value,
        options: const [
          (TsaiControlLabelPosition.left, 'Left'),
          (TsaiControlLabelPosition.right, 'Right'),
        ],
        onChanged: onChanged,
      );
}

class _EventProperty extends StatelessWidget {
  const _EventProperty(this.value);
  final String value;

  @override
  Widget build(BuildContext context) =>
      PlaygroundOutput(label: 'Last callback', value: value);
}

String? _emptyToNull(String value) => value.isEmpty ? null : value;
