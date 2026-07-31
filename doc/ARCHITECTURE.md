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

- Reference tokens and reusable gradient assets are private values transferred
  directly from Penpot.
- Semantic tokens are public, intent-based roles.
- Component defaults are resolved by the component; global button overrides
  use `TsaiButtonTheme`.

Resolution order:

```text
component theme override
  -> semantic token
    -> private reference value
```

Instance-level visual overrides are intentionally limited. This protects
design-system consistency while preserving composition slots for content.

Penpot currently defines tokens for color, typography, spacing, radius, border
width, shadow, and font family, plus reusable top/bottom scrim assets. Values
from those domains must come from `TsaiThemeTokens` or be an explicit
mathematical derivative, such as a two-hairline focus border. Fixed component
geometry such as control height, icon slot, OTP cell, switch track, touch
target, and spinner path remains a private component specification because
Penpot does not expose sizing tokens for it. Reusing a spacing token for an
unrelated glyph or control size is forbidden even when the numeric values
happen to match.

Transparent paint used to suppress native overlays and platform semantic
colors used by adaptive Cupertino surfaces are rendering behavior, not
design-system palette values.

Selection, select, and input components preserve the container hierarchy from
their Penpot main instances. Shared behavior remains private: selection
controls share focus and activation handling, Input and Input Phone share the
field/content/action frame, and OTP/PIN share a native editable overlay. These
helpers do not cross component ownership boundaries through public APIs.

Tabs keep selection separate from scroll ownership. `TsaiTabBar` and
`TsaiTabContent` compose through Flutter's `TabController`; the convenience
`TsaiTabs` widget owns a controller only when the caller does not provide one.
Natural-height content delegates scrolling to its parent, viewport content
expects bounded height and section-owned scrollables, and sticky behavior is a
sliver composition rather than a visual tab property.

Typography is exposed through category widgets rather than raw style lookup in
application code. Required size and weight enums only represent combinations
that exist in Penpot. Widgets resolve the active typography and content-color
tokens, while allowing a semantic color override and standard text layout and
accessibility behavior.

## Theming

`TsaiThemeTokens` is a `ThemeExtension`. `TsaiTheme.light()` and
`TsaiTheme.dark()` install the tokens and a matching `ColorScheme` while
preserving unrelated consumer-owned theme extensions.

Components never branch on `Brightness` and never contain product palette
values outside the private reference-token layer.

## Dependencies

- Flutter SDK provides rendering, interaction, semantics, and theming.
- `flutter_lucide` is the only non-SDK runtime dependency. Components use it
  internally for canonical glyphs, while the complete catalog is re-exported
  only through the opt-in `tsai_icons.dart` entrypoint. Third-party types do
  not appear in component signatures.

Inter and JetBrains Mono are bundled as package fonts with their OFL license
files, keeping mobile and web rendering independent from network font loading.

## Compatibility

The package is pre-stable and has no consumers. Until `1.0.0`, design quality
and a coherent final API take priority over backward compatibility. Do not add
deprecated aliases, compatibility defaults, migration shims, or preserve
obsolete behavior. Remove superseded APIs and implementations directly.

Starting with `1.0.0`, every export becomes a semantic-versioning commitment.
Adding required token fields, changing defaults, or removing enum values then
requires a major release.
