import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class InputDemo extends StatefulWidget {
  const InputDemo({super.key});

  @override
  State<InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  final _controller = TextEditingController(text: 'Value');
  String _label = 'Label';
  String _hint = 'Value';
  String _description = 'Description';
  String _errorText = '';
  String _semanticLabel = '';
  bool _enabled = true;
  bool _readOnly = false;
  bool _obscure = false;
  bool _showVisibility = false;
  bool _clear = true;
  bool _autofocus = false;
  bool _digitsOnly = false;
  int _maxLength = 32;
  String _autofillHint = 'none';
  TextInputType _keyboardType = TextInputType.text;
  TextInputAction _inputAction = TextInputAction.done;
  TextCapitalization _capitalization = TextCapitalization.none;
  String _event = 'No events';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'input-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'value',
          controller: _controller,
          onChanged: (_) => setState(() {}),
        ),
        _TextProperty(
          label: 'label',
          value: _label,
          onChanged: (value) => setState(() => _label = value),
        ),
        _TextProperty(
          label: 'hintText',
          value: _hint,
          onChanged: (value) => setState(() => _hint = value),
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
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
        ),
        _EnumProperty<TextInputType>(
          label: 'keyboardType',
          value: _keyboardType,
          values: const [
            TextInputType.text,
            TextInputType.emailAddress,
            TextInputType.number,
            TextInputType.url,
          ],
          labels: const ['Text', 'Email', 'Number', 'URL'],
          onChanged: (value) => setState(() => _keyboardType = value),
        ),
        _EnumProperty<TextInputAction>(
          label: 'textInputAction',
          value: _inputAction,
          values: const [
            TextInputAction.done,
            TextInputAction.next,
            TextInputAction.search,
            TextInputAction.send,
          ],
          labels: const ['Done', 'Next', 'Search', 'Send'],
          onChanged: (value) => setState(() => _inputAction = value),
        ),
        _EnumProperty<TextCapitalization>(
          label: 'textCapitalization',
          value: _capitalization,
          values: TextCapitalization.values,
          labels: TextCapitalization.values.map((value) => value.name).toList(),
          onChanged: (value) => setState(() => _capitalization = value),
        ),
        _EnumProperty<String>(
          label: 'autofillHints',
          value: _autofillHint,
          values: const ['none', 'email', 'password', 'name'],
          labels: const ['None', 'Email', 'Password', 'Name'],
          onChanged: (value) => setState(() => _autofillHint = value),
        ),
        PlaygroundField(
          label: 'maxLength: $_maxLength',
          child: Slider(
            value: _maxLength.toDouble(),
            min: 1,
            max: 64,
            divisions: 63,
            onChanged: (value) => setState(() => _maxLength = value.round()),
          ),
        ),
        _Toggle(
          label: 'enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        _Toggle(
          label: 'readOnly',
          value: _readOnly,
          onChanged: (value) => setState(() => _readOnly = value),
        ),
        _Toggle(
          label: 'obscureText',
          value: _obscure,
          onChanged: (value) => setState(() => _obscure = value),
        ),
        _Toggle(
          label: 'showVisibilityButton',
          value: _showVisibility,
          onChanged: (value) => setState(() => _showVisibility = value),
        ),
        _Toggle(
          label: 'showClearButton',
          value: _clear,
          onChanged: (value) => setState(() => _clear = value),
        ),
        _Toggle(
          label: 'autofocus',
          value: _autofocus,
          onChanged: (value) => setState(() => _autofocus = value),
        ),
        _Toggle(
          label: 'digitsOnly formatter',
          value: _digitsOnly,
          onChanged: (value) => setState(() => _digitsOnly = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiInput(
        controller: _controller,
        label: _emptyToNull(_label),
        hintText: _emptyToNull(_hint),
        description: _emptyToNull(_description),
        errorText: _emptyToNull(_errorText),
        semanticLabel: _emptyToNull(_semanticLabel),
        enabled: _enabled,
        readOnly: _readOnly,
        obscureText: _obscure,
        showVisibilityButton: _showVisibility,
        showClearButton: _clear,
        autofocus: _autofocus,
        keyboardType: _keyboardType,
        textInputAction: _inputAction,
        textCapitalization: _capitalization,
        inputFormatters: _digitsOnly
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        autofillHints: switch (_autofillHint) {
          'email' => const [AutofillHints.email],
          'password' => const [AutofillHints.password],
          'name' => const [AutofillHints.name],
          _ => null,
        },
        maxLength: _maxLength,
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onEditingComplete: () => setState(() => _event = 'onEditingComplete()'),
        onTap: () => setState(() => _event = 'onTap()'),
        onTapOutside: (_) => setState(() => _event = 'onTapOutside()'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
        onCleared: () => setState(() => _event = 'onCleared()'),
        onObscureChanged: (value) =>
            setState(() => _event = 'onObscureChanged($value)'),
      ),
    ),
    examples: [
      PenpotExample(
        title: 'Input',
        child: PenpotBoard(
          width: 380,
          child: Column(
            children: [
              const TsaiInput(
                label: 'Label',
                hintText: 'Value',
                description: 'Description',
                showVisibilityButton: true,
              ),
              _gap26,
              const TsaiInput(
                label: 'Label',
                hintText: 'Value',
                description: 'Description',
                showVisibilityButton: true,
              ),
              _gap26,
              const TsaiInput(
                label: 'Label',
                initialValue: 'Value',
                description: 'Description',
                showVisibilityButton: true,
              ),
              _gap26,
              const TsaiInput(
                label: 'Label',
                initialValue: 'Value',
                description: 'Description',
                showVisibilityButton: true,
              ),
              _gap26,
              const TsaiInput(
                label: 'Label',
                initialValue: 'Value',
                errorText: 'Description',
                showVisibilityButton: true,
              ),
              _gap26,
              const TsaiInput(
                label: 'Label',
                initialValue: 'Value',
                description: 'Description',
                enabled: false,
                showVisibilityButton: true,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class PhoneInputDemo extends StatefulWidget {
  const PhoneInputDemo({super.key});

  @override
  State<PhoneInputDemo> createState() => _PhoneInputDemoState();
}

class _PhoneInputDemoState extends State<PhoneInputDemo> {
  final _controller = TextEditingController();
  final _countryController = TextEditingController(text: '1');
  String _label = 'Phone number';
  String _description = 'Description';
  String _errorText = '';
  String _semanticLabel = '';
  String _mask = '### ### ## ##';
  bool _enabled = true;
  bool _readOnly = false;
  bool _clear = true;
  bool _autofocus = false;
  String _autofillHint = 'telephoneNumberNational';
  TextInputAction _inputAction = TextInputAction.done;
  String _event = 'No events';

  @override
  void dispose() {
    _controller.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'phone-input-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'value',
          controller: _controller,
          onChanged: (_) => setState(() {}),
        ),
        _TextProperty(
          label: 'countryCode',
          controller: _countryController,
          onChanged: (_) => setState(() {}),
        ),
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
          label: 'errorText',
          value: _errorText,
          onChanged: (value) => setState(() => _errorText = value),
        ),
        _TextProperty(
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
        ),
        _EnumProperty<String>(
          label: 'mask',
          value: _mask,
          values: const ['### ### ## ##', '(###) ###-####', '## #### ####'],
          labels: const ['### ### ## ##', '(###) ###-####', '## #### ####'],
          onChanged: (value) {
            _controller.clear();
            setState(() => _mask = value);
          },
        ),
        _EnumProperty<TextInputAction>(
          label: 'textInputAction',
          value: _inputAction,
          values: const [
            TextInputAction.done,
            TextInputAction.next,
            TextInputAction.send,
          ],
          labels: const ['Done', 'Next', 'Send'],
          onChanged: (value) => setState(() => _inputAction = value),
        ),
        _EnumProperty<String>(
          label: 'autofillHints',
          value: _autofillHint,
          values: const ['none', 'telephoneNumberNational', 'telephoneNumber'],
          labels: const ['None', 'National number', 'Full phone number'],
          onChanged: (value) => setState(() => _autofillHint = value),
        ),
        _Toggle(
          label: 'enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        _Toggle(
          label: 'readOnly',
          value: _readOnly,
          onChanged: (value) => setState(() => _readOnly = value),
        ),
        _Toggle(
          label: 'showClearButton',
          value: _clear,
          onChanged: (value) => setState(() => _clear = value),
        ),
        _Toggle(
          label: 'autofocus',
          value: _autofocus,
          onChanged: (value) => setState(() => _autofocus = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiPhoneInput(
        key: ValueKey<String>(_mask),
        controller: _controller,
        countryCodeController: _countryController,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        errorText: _emptyToNull(_errorText),
        semanticLabel: _emptyToNull(_semanticLabel),
        mask: _mask,
        enabled: _enabled,
        readOnly: _readOnly,
        showClearButton: _clear,
        autofocus: _autofocus,
        textInputAction: _inputAction,
        autofillHints: switch (_autofillHint) {
          'telephoneNumberNational' => const [
            AutofillHints.telephoneNumberNational,
          ],
          'telephoneNumber' => const [AutofillHints.telephoneNumber],
          _ => null,
        },
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onCountryCodeChanged: (value) =>
            setState(() => _event = 'onCountryCodeChanged($value)'),
        onCompleted: (value) => setState(() => _event = 'onCompleted($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
        onCleared: () => setState(() => _event = 'onCleared()'),
      ),
    ),
    examples: [
      PenpotExample(
        title: 'Input Phone',
        child: PenpotBoard(
          width: 380,
          child: Column(
            children: [
              const TsaiPhoneInput(description: 'Description'),
              _gap26,
              const TsaiPhoneInput(description: 'Description'),
              _gap26,
              const TsaiPhoneInput(description: 'Description'),
              _gap26,
              const TsaiPhoneInput(
                initialValue: '555123',
                description: 'Description',
              ),
              _gap26,
              const TsaiPhoneInput(
                initialValue: '5551234567',
                description: 'Description',
              ),
              _gap26,
              const TsaiPhoneInput(
                initialValue: '5551234567',
                errorText: 'Description',
              ),
              _gap26,
              const TsaiPhoneInput(
                initialValue: '5551234567',
                description: 'Description',
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class OtpInputDemo extends StatefulWidget {
  const OtpInputDemo({super.key});

  @override
  State<OtpInputDemo> createState() => _OtpInputDemoState();
}

class _OtpInputDemoState extends State<OtpInputDemo> {
  final _controller = TextEditingController();
  int _length = 4;
  bool _enabled = true;
  bool _autofocus = false;
  bool _error = false;
  bool _success = false;
  String _semanticLabel = 'One-time password';
  String _event = 'No events';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'otp-input-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'value',
          controller: _controller,
          onChanged: (_) => setState(() {}),
        ),
        _TextProperty(
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
        ),
        _LengthProperty(
          value: _length,
          onChanged: (value) {
            _controller.clear();
            setState(() => _length = value);
          },
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
        _StatusToggles(
          error: _error,
          success: _success,
          onError: (value) => setState(() {
            _error = value;
            if (value) _success = false;
          }),
          onSuccess: (value) => setState(() {
            _success = value;
            if (value) _error = false;
          }),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiOtpInput(
        controller: _controller,
        length: _length,
        enabled: _enabled,
        autofocus: _autofocus,
        isError: _error,
        isSuccess: _success,
        semanticLabel: _semanticLabel,
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onCompleted: (value) => setState(() => _event = 'onCompleted($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
      ),
    ),
    examples: [
      PenpotExample(
        title: 'Input OTP',
        child: PenpotBoard(
          width: 308,
          child: Column(
            children: const [
              TsaiOtpInput(),
              _gap24,
              TsaiOtpInput(),
              _gap24,
              TsaiOtpInput(initialValue: '12'),
              _gap24,
              TsaiOtpInput(initialValue: '1234'),
              _gap24,
              TsaiOtpInput(initialValue: '1234', isError: true),
              _gap24,
              TsaiOtpInput(initialValue: '1234', enabled: false),
              _gap24,
              TsaiOtpInput(initialValue: '1234', isSuccess: true),
            ],
          ),
        ),
      ),
    ],
  );
}

class PinInputDemo extends StatefulWidget {
  const PinInputDemo({super.key});

  @override
  State<PinInputDemo> createState() => _PinInputDemoState();
}

class _PinInputDemoState extends State<PinInputDemo> {
  final _controller = TextEditingController();
  int _length = 4;
  bool _enabled = true;
  bool _autofocus = false;
  bool _error = false;
  bool _success = false;
  String _semanticLabel = 'PIN';
  String _event = 'No events';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'pin-input-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'value',
          controller: _controller,
          onChanged: (_) => setState(() {}),
        ),
        _TextProperty(
          label: 'semanticLabel',
          value: _semanticLabel,
          onChanged: (value) => setState(() => _semanticLabel = value),
        ),
        _LengthProperty(
          value: _length,
          onChanged: (value) {
            _controller.clear();
            setState(() => _length = value);
          },
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
        _StatusToggles(
          error: _error,
          success: _success,
          onError: (value) => setState(() {
            _error = value;
            if (value) _success = false;
          }),
          onSuccess: (value) => setState(() {
            _success = value;
            if (value) _error = false;
          }),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiPinInput(
        controller: _controller,
        length: _length,
        enabled: _enabled,
        autofocus: _autofocus,
        isError: _error,
        isSuccess: _success,
        semanticLabel: _semanticLabel,
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onCompleted: (value) => setState(() => _event = 'onCompleted($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
      ),
    ),
    examples: [
      PenpotExample(
        title: 'Input PIN',
        child: PenpotBoard(
          width: 156,
          child: Column(
            children: const [
              TsaiPinInput(),
              _gap68,
              TsaiPinInput(initialValue: '12'),
              _gap68,
              TsaiPinInput(initialValue: '1234'),
              _gap68,
              TsaiPinInput(initialValue: '1234', isError: true),
              _gap68,
              TsaiPinInput(initialValue: '1234', isSuccess: true),
              _gap68,
              TsaiPinInput(initialValue: '1234', enabled: false),
            ],
          ),
        ),
      ),
    ],
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
    required this.onChanged,
    this.value,
    this.controller,
  }) : assert(value == null || controller == null);

  final String label;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => PlaygroundTextControl(
    label: label,
    value: value,
    controller: controller,
    onChanged: onChanged,
  );
}

class _EnumProperty<T> extends StatelessWidget {
  const _EnumProperty({
    required this.label,
    required this.value,
    required this.values,
    required this.labels,
    required this.onChanged,
  });
  final String label;
  final T value;
  final List<T> values;
  final List<String> labels;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => PlaygroundSelectControl<T>(
    label: label,
    value: value,
    values: values,
    labels: labels,
    onChanged: onChanged,
  );
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
  Widget build(BuildContext context) =>
      PlaygroundToggleControl(label: label, value: value, onChanged: onChanged);
}

class _LengthProperty extends StatelessWidget {
  const _LengthProperty({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => PlaygroundRadioGroup<int>(
    label: 'length',
    value: value,
    options: const [(4, '4'), (6, '6')],
    onChanged: onChanged,
  );
}

class _StatusToggles extends StatelessWidget {
  const _StatusToggles({
    required this.error,
    required this.success,
    required this.onError,
    required this.onSuccess,
  });
  final bool error;
  final bool success;
  final ValueChanged<bool> onError;
  final ValueChanged<bool> onSuccess;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      PlaygroundToggleControl(
        label: 'isError',
        value: error,
        onChanged: onError,
      ),
      PlaygroundToggleControl(
        label: 'isSuccess',
        value: success,
        onChanged: onSuccess,
      ),
    ],
  );
}

class _EventProperty extends StatelessWidget {
  const _EventProperty(this.value);
  final String value;

  @override
  Widget build(BuildContext context) =>
      PlaygroundOutput(label: 'Last callback', value: value);
}

const _gap24 = SizedBox(height: 24);
const _gap26 = SizedBox(height: 26);
const _gap68 = SizedBox(height: 68);

String? _emptyToNull(String value) => value.isEmpty ? null : value;
