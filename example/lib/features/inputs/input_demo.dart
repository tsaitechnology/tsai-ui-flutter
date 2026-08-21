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
  String _placeholder = 'Label';
  String _description = 'Description';
  String _errorText = '';
  bool _enabled = true;
  bool _readOnly = false;
  bool _obscure = false;
  bool _showVisibility = false;
  bool _clear = true;
  bool _labeledPlaceholder = true;
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
          label: 'digitsOnly formatter',
          value: _digitsOnly,
          onChanged: (value) => setState(() => _digitsOnly = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiInput(
        controller: _controller,
        placeholder: _emptyToNull(_placeholder),
        labeledPlaceholder: _labeledPlaceholder,
        description: _emptyToNull(_description),
        errorText: _emptyToNull(_errorText),
        enabled: _enabled,
        readOnly: _readOnly,
        obscureText: _obscure,
        showVisibilityButton: _showVisibility,
        showClearButton: _clear,
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
  );
}

class SearchInputDemo extends StatefulWidget {
  const SearchInputDemo({super.key});

  @override
  State<SearchInputDemo> createState() => _SearchInputDemoState();
}

class _SearchInputDemoState extends State<SearchInputDemo> {
  final _controller = TextEditingController();
  String _placeholder = 'Search';
  bool _enabled = true;
  bool _showClearButton = true;
  String _event = 'No events';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DemoPage(
    pageKey: 'input-search-demo',
    playground: ComponentPlayground(
      controls: [
        _TextProperty(
          label: 'value',
          controller: _controller,
          onChanged: (_) => setState(() {}),
        ),
        _TextProperty(
          label: 'placeholder',
          value: _placeholder,
          onChanged: (value) => setState(() => _placeholder = value),
        ),
        _Toggle(
          label: 'enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        _Toggle(
          label: 'showClearButton',
          value: _showClearButton,
          onChanged: (value) => setState(() => _showClearButton = value),
        ),
        _EventProperty(_event),
      ],
      preview: TsaiSearchInput(
        controller: _controller,
        placeholder: _placeholder,
        enabled: _enabled,
        showClearButton: _showClearButton,
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
        onCleared: () => setState(() => _event = 'onCleared()'),
      ),
    ),
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
  String _mask = '### ### ## ##';
  bool _enabled = true;
  bool _readOnly = false;
  bool _clear = true;
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
        _EventProperty(_event),
      ],
      preview: TsaiPhoneInput(
        key: ValueKey<String>(_mask),
        controller: _controller,
        countryCodeController: _countryController,
        label: _emptyToNull(_label),
        description: _emptyToNull(_description),
        errorText: _emptyToNull(_errorText),
        mask: _mask,
        enabled: _enabled,
        readOnly: _readOnly,
        showClearButton: _clear,
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
  bool _error = false;
  bool _success = false;
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
        isError: _error,
        isSuccess: _success,
        semanticLabel: 'One-time password',
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onCompleted: (value) => setState(() => _event = 'onCompleted($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
      ),
    ),
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
  bool _error = false;
  bool _success = false;
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
        isError: _error,
        isSuccess: _success,
        semanticLabel: 'PIN',
        onChanged: (value) => setState(() => _event = 'onChanged($value)'),
        onCompleted: (value) => setState(() => _event = 'onCompleted($value)'),
        onSubmitted: (value) => setState(() => _event = 'onSubmitted($value)'),
        onFocusChange: (value) =>
            setState(() => _event = 'onFocusChange($value)'),
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
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      PlaygroundToggleControl(
        label: 'Error state',
        value: error,
        onChanged: onError,
      ),
      PlaygroundToggleControl(
        label: 'Success state',
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

String? _emptyToNull(String value) => value.isEmpty ? null : value;
