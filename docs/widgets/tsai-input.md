# TsaiInput

A text field with a placeholder/floating label, supporting or error text,
clear and password-visibility actions, an optional trailing action, formatters,
autofill, focus, and submission callbacks.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input){ target="_blank" rel="noopener" .md-button }

```dart
TsaiInput(
  placeholder: 'Email',
  keyboardType: TextInputType.emailAddress,
  autofillHints: const [AutofillHints.email],
  onChanged: (value) => setState(() => email = value),
)
```

For passwords, set `obscureText: true`. Use `showVisibilityButton: true` when
the user should be able to toggle visibility. Do not provide both `controller`
and `initialValue`. `trailingAction` accepts a composed widget; the Penpot
example uses a medium `TsaiButton`.
