# Architecture And Token Model

## Contents

- Package topology
- Default layout
- Dependency boundaries
- Two-token-set model
- Theme integration
- Component theming
- Token evolution

## Package topology

Start with a single publishable Flutter package. A single release unit keeps
tokens and components compatible and makes adoption simple.

Split into a Pub workspace only when at least one condition is concrete:

- a package needs an independent release cadence or owner;
- a package supports different platforms;
- an optional feature adds material dependency or binary cost;
- consumers need the foundation without widgets;
- compatibility policy differs between surfaces.

Do not split merely to mirror conceptual layers. Package boundaries create
version constraints, release ordering, documentation, and compatibility work.

## Default layout

```text
<package>/
  lib/
    <package>.dart
    src/
      foundation/
        primitives/
        semantic/
        theme/
      components/
        <component>/
          <component>.dart
          <component>_theme.dart
          src/
  example/
    lib/
    web/
  test/
    foundation/
    components/
    accessibility/
    goldens/
  integration_test/
  README.md
  CHANGELOG.md
  LICENSE
  analysis_options.yaml
  pubspec.yaml
```

Keep the root public library small and intentional. Files under `lib/src` are
implementation details even though same-package tests may import them.

## Dependency boundaries

Allowed dependencies:

```text
components -> component theme API -> semantic tokens -> reference tokens
components -> Flutter SDK
example/docs -> package public API
tests -> public API
focused internal tests -> lib/src
```

Forbidden dependencies:

```text
tokens -> components
package -> example/docs
component -> example/docs
component A -> component B private implementation
public API -> generated design-tool model
library -> application state, router, network, or service locator
```

Use sibling components through their stable public contracts only when one
component is intentionally composed from another. Extract a lower-level
primitive when sibling implementation sharing becomes repeated.

## Two-token-set model

Represent light and dark as two instances of one concrete Dart type:

```dart
@immutable
final class UiThemeTokens extends ThemeExtension<UiThemeTokens> {
  const UiThemeTokens({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.elevation,
    required this.motion,
    required this.sizing,
  });

  final UiColorTokens colors;
  final UiTypographyTokens typography;
  final UiSpacingTokens spacing;
  final UiRadiusTokens radii;
  final UiElevationTokens elevation;
  final UiMotionTokens motion;
  final UiSizingTokens sizing;

  // Implement typed copyWith and lerp for every field.
}
```

The actual prefix must match the package name. Keep every field non-null and
`final`. Prefer `const` construction. Define exactly two canonical resolved
instances, for example `UiThemeTokens.light` and `UiThemeTokens.dark`.

Both instances contain every group even when values are identical across
themes. This preserves a stable schema and lets future designs vary a token
without changing the contract.

Do not use:

- `Map<String, dynamic>` as the runtime token API;
- nullable fields with fallback from dark to light;
- component-side `Brightness` switches;
- raw design-tool variable names in exported declarations;
- direct palette values in component build methods.

## Token levels

### Reference

Store raw palette steps, spacing scales, duration scales, and similar source
values internally. Reference tokens describe what a value is, not where it is
used. Do not export them unless consumers have a demonstrated use case.

### Semantic

Expose stable intent roles. Prefer paired roles:

```text
surfaceCanvas / contentOnCanvas
surfaceRaised / contentOnRaised
actionPrimary / contentOnActionPrimary
actionDanger / contentOnActionDanger
borderDefault / borderFocused / borderError
```

Name typography by role, not numeric scale. Name motion by intent. Keep layout
tokens directional-neutral; use directional Flutter APIs in widgets.

### Component

Derive component defaults from semantic roles. Add a component-specific theme
type only when consumers need coherent global customization that semantic
tokens cannot express.

Component theme fields may be optional overrides. Resolve them over semantic
defaults at build time. Avoid adding every component property to the central
semantic token type, because doing so couples unrelated API evolution.

## Theme integration

Use `ThemeData.extensions` and retrieve the nearest extension from
`Theme.of(context)`. Provide an ergonomic `of(context)` and, only when callers
need optional lookup, `maybeOf(context)`.

Implement:

- `copyWith` without silently replacing omitted values;
- `lerp` for every animatable field;
- equality and `hashCode` for standalone token value objects when useful;
- debug diagnostics for large theme objects when it improves inspection.

Offer helpers that install the complete light or dark extension into
`ThemeData`, while preserving a way to merge with consumer-owned `ThemeData`.
Do not force consumers to replace their whole application theme.

## Component resolution

Resolve values in this order:

1. explicit constructor override;
2. nearest component theme override;
3. nearest semantic token;
4. internal reference default used while constructing canonical token sets.

Keep resolution in one private style resolver per component. The widget should
render a resolved, non-null style instead of spreading fallback logic across
the build tree.

## Token evolution

Adding a required field to a public token constructor is breaking. Reduce
avoidable breakage by:

- exposing canonical factories and `copyWith`;
- keeping raw constructors private when consumers do not need full custom sets;
- adding new roles through backwards-compatible factories where possible;
- deprecating renamed roles with a migration window;
- testing both canonical sets whenever the schema changes.

Treat imported design tokens as inputs to a conversion step. Validate generated
output, format it, and keep the stable Dart semantic API independent from the
source tool.
