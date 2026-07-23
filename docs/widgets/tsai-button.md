# TsaiButton

A token-driven action button with primary, secondary, outline, and ghost
variants; medium and large sizes; loading, disabled, expanded, focus, and icon
states.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/buttons){ target="_blank" rel="noopener" .md-button }

```dart
TsaiButton(
  label: 'Create account',
  variant: TsaiButtonVariant.primary,
  size: TsaiButtonSize.large,
  leadingIcon: const TsaiIcon(LucideIcons.plus, size: 16),
  isLoading: saving,
  onPressed: saving ? null : createAccount,
)
```

Set `onPressed` to `null` to disable the button. `isLoading` suppresses
activation and replaces the leading icon with a progress indicator. Use
`semanticLabel` and `loadingSemanticLabel` when visible text is not sufficient.

Variant defaults can be overridden globally with `TsaiButtonTheme`.
