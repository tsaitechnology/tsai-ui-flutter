# TsaiInput

A text field with label, hint, supporting/error text, clear action, password
visibility, formatters, autofill, focus, and submission callbacks.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input){ target="_blank" rel="noopener" .md-button }

```dart
TsaiInput(
  label: 'Email',
  hintText: 'name@example.com',
  keyboardType: TextInputType.emailAddress,
  autofillHints: const [AutofillHints.email],
  onChanged: (value) => setState(() => email = value),
)
```

For passwords, set `obscureText: true`. Use `showVisibilityButton: true` when
the user should be able to toggle visibility. Do not provide both `controller`
and `initialValue`.
