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

Large component families use Dart part files grouped by public widget and
private implementation responsibility. Their canonical exported library file
owns imports and keeps helpers library-private, so file organization does not
expand or fragment the public API.

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
- `flutter_lucide` supplies canonical glyphs. The complete catalog is re-exported
  only through the opt-in `tsai_icons.dart` entrypoint.
- `flutter_svg` renders bundled cryptocurrency artwork inside `TsaiCryptoIcon`.
  `SvgPicture` and other `flutter_svg` types must stay out of public component
  signatures.

Third-party types do not appear in component APIs. Consumers depend on Tsai
widgets, semantic tokens, and Flutter types only.

Inter and JetBrains Mono are bundled as package fonts with their OFL license
files, keeping mobile and web rendering independent from network font loading.

## Component composition

Components may compose other **public** Tsai widgets. That is intentional
product composition, not a reverse-dependency:

- `TsaiSelect` opens options in `TsaiBottomSheet` and reuses list rows.
- `TsaiAccordion` may paint a `TsaiDivider`.
- `TsaiIconButton` may overlay a `TsaiBadge`.
- Chart empty/error chrome may reuse `TsaiLink` and typography widgets.

Forbidden: importing another component's `src/` helpers or private part
files. Shared behavior stays inside the owning family (`part` files) or is
promoted to a public widget.

## Contrast policy

Semantic foreground/background pairs used for body copy must meet WCAG 2.1
AA contrast (4.5:1 for normal text). Token tests enforce that for primary
content on canvas and surface, inverted tooltip pairs, and a 4.4:1 floor for
on-action text (Penpot's indigo fill is ~4.47:1). Accent-colored labels on
tinted navigation chrome are decorative treatments, not the body-copy
contract.

## Compatibility

The package is pre-stable and has no consumers. Until `1.0.0`, design quality
and a coherent final API take priority over backward compatibility. Do not add
deprecated aliases, compatibility defaults, migration shims, or preserve
obsolete behavior. Remove superseded APIs and implementations directly.

Starting with `1.0.0`, every export becomes a semantic-versioning commitment.
Adding required token fields, changing defaults, or removing enum values then
requires a major release.
