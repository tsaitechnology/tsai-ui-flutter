# Architecture

## Package topology

The initial implementation is a single Flutter package. Tokens, themes,
primitives, and components share one release lifecycle, so a multi-package
workspace would add coordination cost without a concrete benefit.

```text
public entrypoints
  -> component API and implementation
    -> component theme override
      -> semantic theme tokens
        -> private Penpot reference values
          -> Flutter SDK
```

Reverse dependencies are forbidden. The package does not depend on the example
application, and components do not import private implementations from sibling
components.

## Token model

`TsaiThemeTokens.light` and `TsaiThemeTokens.dark` are two complete instances
of the same immutable schema. Every field is non-null, and Dart constructors
enforce parity.

- Reference tokens are private values transferred directly from Penpot.
- Semantic tokens are public, intent-based roles.
- Component defaults are resolved by the component; global overrides use
  `TsaiButtonTheme`.

Resolution order:

```text
component theme override
  -> semantic token
    -> private reference value
```

Instance-level visual overrides are intentionally limited. This protects
design-system consistency while preserving composition slots for content.

## Theming

`TsaiThemeTokens` is a `ThemeExtension`. `TsaiTheme.light()` and
`TsaiTheme.dark()` install the tokens and a matching `ColorScheme` while
preserving unrelated consumer-owned theme extensions.

Components never branch on `Brightness` and never contain hard-coded colors.

## Dependencies

- Flutter SDK provides rendering, interaction, semantics, and theming.
- `flutter_lucide` is the only runtime dependency. It is isolated behind the
  opt-in `tsai_icons.dart` entrypoint, and its types do not appear in
  `TsaiButton` signatures.

Inter and JetBrains Mono are bundled as package fonts with their OFL license
files, keeping mobile and web rendering independent from network font loading.

## Compatibility

Version `0.0.1` is pre-stable. After `1.0.0`, every export is a semantic
versioning commitment. Adding required token fields, changing button defaults,
or removing enum values is a breaking change.
