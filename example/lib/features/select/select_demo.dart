import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class SelectDemo extends StatefulWidget {
  const SelectDemo({super.key});

  @override
  State<SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<SelectDemo> {
  String? _value;
  String _firstOption = 'Option';
  String _secondOption = 'Second option';
  String _thirdOption = 'Disabled option';
  String _placeholder = 'Label';
  String _description = 'Description';
  String _errorText = '';
  bool _enabled = true;
  bool _showClear = true;
  bool _showIcons = false;
  bool _thirdOptionEnabled = false;
  bool _labeledPlaceholder = true;
  double _menuMaxHeight = 320;
  TsaiSelectPresentation _presentation = TsaiSelectPresentation.adaptive;
  String _event = 'No events';

  List<TsaiSelectOption<String>> get _options => [
    TsaiSelectOption(
      value: 'option',
      label: _firstOption,
      icon: _showIcons ? const TsaiIcon.emoji('🇺🇸', size: 20) : null,
    ),
    TsaiSelectOption(
      value: 'second',
      label: _secondOption,
      icon: _showIcons ? const TsaiIcon.emoji('🇺🇾', size: 20) : null,
    ),
    TsaiSelectOption(
      value: 'disabled',
      label: _thirdOption,
      icon: _showIcons ? const TsaiIcon.emoji('🇧🇷', size: 20) : null,
      enabled: _thirdOptionEnabled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: const ValueKey<String>('select-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        ComponentPlayground(
          controls: [
            _TextProperty(
              label: 'placeholder',
              value: _placeholder,
              onChanged: (value) => setState(() => _placeholder = value),
            ),
            _TextProperty(
              label: 'description',
              value: _description,
              onChanged: (value) => setState(() => _description = value),
            ),
            _TextProperty(
              label: 'errorText',
              value: _errorText,
              onChanged: (value) => setState(() => _errorText = value),
            ),
            _TextProperty(
              label: 'First option label',
              value: _firstOption,
              onChanged: (value) => setState(() => _firstOption = value),
            ),
            _TextProperty(
              label: 'Second option label',
              value: _secondOption,
              onChanged: (value) => setState(() => _secondOption = value),
            ),
            _TextProperty(
              label: 'Disabled option label',
              value: _thirdOption,
              onChanged: (value) => setState(() => _thirdOption = value),
            ),
            PlaygroundRadioGroup<String>(
              label: 'value',
              value: _value ?? 'null',
              options: const [
                ('null', 'null'),
                ('option', 'Option'),
                ('second', 'Second option'),
              ],
              onChanged: (value) =>
                  setState(() => _value = value == 'null' ? null : value),
            ),
            PlaygroundSelectControl<TsaiSelectPresentation>(
              label: 'presentation',
              value: _presentation,
              values: TsaiSelectPresentation.values,
              labels: const ['Adaptive', 'Menu', 'Bottom sheet'],
              onChanged: (value) => setState(() => _presentation = value),
            ),
            PlaygroundField(
              label: 'menuMaxHeight',
              child: Slider(
                value: _menuMaxHeight,
                min: 120,
                max: 480,
                divisions: 9,
                label: _menuMaxHeight.round().toString(),
                onChanged: (value) => setState(() => _menuMaxHeight = value),
              ),
            ),
            _Toggle(
              label: 'labeledPlaceholder',
              value: _labeledPlaceholder,
              onChanged: (value) => setState(() => _labeledPlaceholder = value),
            ),
            _Toggle(
              label: 'enabled',
              value: _enabled,
              onChanged: (value) => setState(() => _enabled = value),
            ),
            _Toggle(
              label: 'showClearButton',
              value: _showClear,
              onChanged: (value) => setState(() => _showClear = value),
            ),
            _Toggle(
              label: 'Show option icons',
              value: _showIcons,
              onChanged: (value) => setState(() => _showIcons = value),
            ),
            _Toggle(
              label: 'Enable third option',
              value: _thirdOptionEnabled,
              onChanged: (value) => setState(() => _thirdOptionEnabled = value),
            ),
            _EventProperty(_event),
          ],
          preview: TsaiSelect<String>(
            options: _options,
            value: _value,
            placeholder: _emptyToNull(_placeholder),
            labeledPlaceholder: _labeledPlaceholder,
            description: _emptyToNull(_description),
            errorText: _emptyToNull(_errorText),
            showClearButton: _showClear,
            menuMaxHeight: _menuMaxHeight,
            presentation: _presentation,
            onFocusChange: (value) =>
                setState(() => _event = 'onFocusChange($value)'),
            onOpen: () => setState(() => _event = 'onOpen()'),
            onClose: () => setState(() => _event = 'onClose()'),
            onChanged: _enabled
                ? (value) => setState(() {
                    _value = value;
                    _event = 'onChanged($value)';
                  })
                : null,
          ),
        ),
      ],
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
    width: 160,
    value: value,
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
