# Theming

Install both canonical token sets on `MaterialApp`:

```dart
MaterialApp(
  theme: TsaiTheme.light(),
  darkTheme: TsaiTheme.dark(),
  themeMode: ThemeMode.system,
  home: const HomeScreen(),
);
```

`TsaiTheme.light` and `TsaiTheme.dark` accept an existing `ThemeData` through
`base`. Unrelated theme extensions are preserved:

```dart
final lightTheme = TsaiTheme.light(
  base: ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
  ),
);
```

Read semantic values inside a custom widget with:

```dart
final tokens = TsaiThemeTokens.of(context);

return ColoredBox(
  color: tokens.colors.surfaceRaised,
  child: Padding(
    padding: EdgeInsets.all(tokens.spacing.space16),
    child: Text(
      'Account',
      style: tokens.typography.bodyLarge,
    ),
  ),
);
```

Reusable Penpot scrim assets are exposed through the typed gradient group:

```dart
DecoratedBox(
  decoration: BoxDecoration(
    gradient: tokens.gradients.bottomScrim,
  ),
  child: content,
);
```

`topScrim` and `bottomScrim` resolve to their light or dark Penpot asset with
the active `TsaiTheme`. Backdrop effects such as glass surfaces read
`tokens.effects.glassBlur`; applications creating a complete custom token set
must provide every color, gradient, and effect role.

Nested surfaces inside a medium-radius container use
`tokens.radii.innerMedium` rather than deriving a radius from spacing values.

Buttons also support application-wide variant overrides through
`TsaiButtonTheme`. Keep overrides semantic and test them in both brightness
modes.

## Accessibility

Do not disable text scaling. Supply `semanticLabel` when the visible label is
ambiguous, and use the loading/error semantics exposed by each component.
Tsai controls preserve keyboard focus and honor the platform reduced-motion
preference.
