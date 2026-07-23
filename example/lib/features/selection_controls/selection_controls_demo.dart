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
  String _semanticLabel = '';
  bool _enabled = true;
  bool _error = false;
  bool _tristate = false;
  bool _autofocus = false;
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
        _TextProperty(
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
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
          label: 'isError',
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
        _Toggle(
          label: 'autofocus',
          value: _autofocus,
          onChanged: (value) => setState(() => _autofocus = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiCheckbox(
        value: _value,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        semanticLabel: _emptyToNull(_semanticLabel),
        labelPosition: _position,
        tristate: _tristate,
        isError: _error,
        autofocus: _autofocus,
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
    examples: [
      PenpotExample(
        title: 'Checkbox',
        child: PenpotBoard(
          width: 260,
          child: Column(
            children: [
              _checkboxPair(false),
              _gap24,
              _checkboxPair(true),
              _gap24,
              _checkboxPair(null),
              _gap24,
              _checkboxPair(false, error: true),
              _gap24,
              _checkboxPair(false, enabled: false),
              _gap24,
              _checkboxPair(true, enabled: false),
            ],
          ),
        ),
      ),
      PenpotExample(
        title: 'Checkbox List (example)',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _listCheckbox(true, 'Payments'),
            _gap16,
            _listCheckbox(false, 'Transfers'),
            _gap16,
            _listCheckbox(true, 'Card activity'),
            _gap16,
            _listCheckbox(false, 'Security alerts'),
            _gap16,
            _listCheckbox(false, 'Promotions'),
          ],
        ),
      ),
      PenpotExample(
        title: 'Checkbox Multiline (example)',
        child: SizedBox(
          width: 320,
          child: Column(
            children: [
              _listCheckbox(
                true,
                'I agree to the Terms of Service\nand acknowledge the Privacy Policy',
              ),
              _gap24,
              _listCheckbox(
                false,
                'Send me product updates and offers\nby email',
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _checkboxPair(
    bool? value, {
    bool enabled = true,
    bool error = false,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _penpotControl(
        TsaiCheckbox(
          value: value,
          tristate: value == null,
          label: 'Label',
          isError: error,
          onChanged: enabled ? (_) {} : null,
        ),
        width: 72,
      ),
      const SizedBox(width: 56),
      _penpotControl(
        TsaiCheckbox(
          value: value,
          tristate: value == null,
          label: 'Label',
          labelPosition: TsaiControlLabelPosition.left,
          isError: error,
          onChanged: enabled ? (_) {} : null,
        ),
        width: 72,
      ),
    ],
  );

  Widget _listCheckbox(bool value, String label) {
    final checkbox = TsaiCheckbox(
      value: value,
      label: label,
      onChanged: (_) {},
    );
    if (label.contains('\n')) {
      return SizedBox(width: 320, child: checkbox);
    }
    return _penpotControl(checkbox);
  }
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
  String _semanticLabel = '';
  bool _enabled = true;
  bool _error = false;
  bool _autofocus = false;
  TsaiControlLabelPosition _position = TsaiControlLabelPosition.right;
  String _event = 'No events';
  String? _payment = 'Bank card';

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
        _TextProperty(
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
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
          label: 'isError',
          value: _error,
          onChanged: (value) => setState(() => _error = value),
        ),
        _Toggle(
          label: 'autofocus',
          value: _autofocus,
          onChanged: (value) => setState(() => _autofocus = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiRadio<String>(
        value: 'value',
        groupValue: _selected ? 'value' : null,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        semanticLabel: _emptyToNull(_semanticLabel),
        labelPosition: _position,
        isError: _error,
        autofocus: _autofocus,
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
    examples: [
      PenpotExample(
        title: 'Radio',
        child: PenpotBoard(
          width: 260,
          child: Column(
            children: [
              _radioPair(false),
              _gap24,
              _radioPair(true),
              _gap24,
              _radioPair(false, error: true),
              _gap24,
              _radioPair(false, enabled: false),
              _gap24,
              _radioPair(true, enabled: false),
            ],
          ),
        ),
      ),
      PenpotExample(
        title: 'Radio List (example)',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final label in const [
              'Bank card',
              'Bank transfer',
              'Crypto wallet',
              'Apple Pay',
              'PayPal',
            ]) ...[
              _penpotControl(
                TsaiRadio<String>(
                  value: label,
                  groupValue: _payment,
                  label: label,
                  onChanged: (value) => setState(() => _payment = value),
                ),
              ),
              if (label != 'PayPal') _gap16,
            ],
          ],
        ),
      ),
      PenpotExample(
        title: 'Radio Multiline (example)',
        child: SizedBox(
          width: 320,
          child: Column(
            children: [
              _penpotControl(
                TsaiRadio<String>(
                  value: 'standard',
                  groupValue: 'standard',
                  label:
                      'Standard delivery (3-5 business days), free for orders over \$100',
                  onChanged: (_) {},
                ),
                height: 34,
              ),
              _gap24,
              _penpotControl(
                TsaiRadio<String>(
                  value: 'express',
                  groupValue: 'standard',
                  label:
                      'Express delivery (1-2 business days) with real-time courier tracking',
                  onChanged: (_) {},
                ),
                height: 34,
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _radioPair(bool selected, {bool enabled = true, bool error = false}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _penpotControl(
            TsaiRadio<String>(
              value: 'value',
              groupValue: selected ? 'value' : null,
              label: 'Label',
              isError: error,
              onChanged: enabled ? (_) {} : null,
            ),
            width: 72,
          ),
          const SizedBox(width: 56),
          _penpotControl(
            TsaiRadio<String>(
              value: 'value',
              groupValue: selected ? 'value' : null,
              label: 'Label',
              labelPosition: TsaiControlLabelPosition.left,
              isError: error,
              onChanged: enabled ? (_) {} : null,
            ),
            width: 72,
          ),
        ],
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
  String _semanticLabel = '';
  bool _enabled = true;
  bool _autofocus = false;
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
        _TextProperty(
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
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
        _Toggle(
          label: 'autofocus',
          value: _autofocus,
          onChanged: (value) => setState(() => _autofocus = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiSwitch(
        value: _value,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        semanticLabel: _emptyToNull(_semanticLabel),
        labelPosition: _position,
        autofocus: _autofocus,
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
    examples: [
      PenpotExample(
        title: 'Switch',
        child: PenpotBoard(
          width: 260,
          child: Column(
            children: [
              _switchPair(false),
              _gap24,
              _switchPair(true),
              _gap24,
              _switchPair(false, enabled: false),
              _gap24,
              _switchPair(true, enabled: false),
            ],
          ),
        ),
      ),
      PenpotExample(
        title: 'Switch List (example)',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _listSwitch(true, 'Push notifications'),
            _gap16,
            _listSwitch(false, 'Email alerts'),
            _gap16,
            _listSwitch(true, 'Biometric login'),
            _gap16,
            _listSwitch(false, 'Marketing emails'),
            _gap16,
            _listSwitch(false, 'Auto top-up'),
          ],
        ),
      ),
      PenpotExample(
        title: 'Switch Multiline (example)',
        child: SizedBox(
          width: 320,
          child: Column(
            children: [
              _listSwitch(
                false,
                'Notify me about new sign-ins from unknown devices and locations',
              ),
              _gap24,
              _penpotControl(
                TsaiSwitch(
                  value: false,
                  label:
                      'Automatically top up the card balance when it drops below \$50',
                  labelPosition: TsaiControlLabelPosition.left,
                  onChanged: (_) {},
                ),
                height: 34,
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _switchPair(bool value, {bool enabled = true}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _penpotControl(
        TsaiSwitch(
          value: value,
          label: 'Label',
          onChanged: enabled ? (_) {} : null,
        ),
        width: 88,
      ),
      const SizedBox(width: 24),
      _penpotControl(
        TsaiSwitch(
          value: value,
          label: 'Label',
          labelPosition: TsaiControlLabelPosition.left,
          onChanged: enabled ? (_) {} : null,
        ),
        width: 88,
      ),
    ],
  );

  Widget _listSwitch(bool value, String label) => _penpotControl(
    TsaiSwitch(value: value, label: label, onChanged: (_) {}),
    height: label.length > 30 ? 34 : 20,
  );
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({
    required this.pageKey,
    required this.playground,
    required this.examples,
  });
  final String pageKey;
  final Widget playground;
  final List<Widget> examples;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: ValueKey<String>(pageKey),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [...examples, playground],
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
        label: 'labelPosition',
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

const _gap16 = SizedBox(height: 16);
const _gap24 = SizedBox(height: 24);

String? _emptyToNull(String value) => value.isEmpty ? null : value;

Widget _penpotControl(Widget child, {double? width, double height = 20}) =>
    SizedBox(
      width: width,
      height: height,
      child: OverflowBox(
        minWidth: width ?? 0,
        maxWidth: width ?? double.infinity,
        minHeight: 48,
        maxHeight: 48,
        alignment: AlignmentDirectional.centerStart,
        child: child,
      ),
    );
