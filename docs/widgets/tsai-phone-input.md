# TsaiPhoneInput

A phone input with separate country-code and cursor-aware masked national
number fields.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input-phone){ target="_blank" rel="noopener" .md-button }

```dart
TsaiPhoneInput(
  initialCountryCode: '598',
  mask: '## ### ####',
  onCountryCodeChanged: (value) => countryCode = value,
  onChanged: (value) => phone = value,
  onCompleted: submitPhone,
)
```

Each `#` in `mask` accepts one digit. `onChanged` receives the formatted
national number; `onCompleted` runs when all mask positions are filled.
`TsaiPhoneInputFormatter` is available for standalone formatting.
