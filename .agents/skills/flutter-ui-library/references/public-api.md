# Public API Design

## Contents

- API inventory
- Library entrypoints
- Widget constructors
- State and callbacks
- Theme and value objects
- Documentation
- Compatibility
- Review checklist

## API inventory

Before coding, classify each declaration:

| Classification | Location | Compatibility promise |
|---|---|---|
| Public | Deliberately exported from `lib/` | Semver protected |
| Internal | `lib/src/` and not exported | May evolve internally |
| Example-only | `example/` | Not package API |
| Test support | `test/` or a deliberate testing library | Protected only if exported |

Write the intended consumer import and a minimal usage example first. Remove
types and parameters that are not required by that example or a confirmed
extension use case.

## Library entrypoints

Provide one canonical import:

```dart
import 'package:<package>/<package>.dart';
```

Use secondary public libraries only when they create meaningful opt-in
boundaries, such as testing utilities or an optional integration. Avoid a file
per public widget as a consumer-facing import model.

Export exact files or declarations. Do not export directories indirectly and
do not expose generated files, private resolvers, raw palettes, or internal base
classes.

Examples and black-box tests must import the public package entrypoint. Internal
tests can import `package:<package>/src/...` only to verify genuinely internal
logic.

## Widget constructors

- Make constructors `const` whenever all fields permit it.
- Accept `super.key`.
- Prefer named parameters for independently meaningful options.
- Mark essential values `required`.
- Avoid positional booleans and sentinel values.
- Use enums or typed value objects for mutually exclusive modes.
- Keep defaults stable, documented, and derived from the theme when visual.
- Accept `Widget?`, `WidgetBuilder`, or typed callbacks where composition is
  intended; do not accept untyped maps.
- Avoid constructors that mirror every internal style property.

Do not store `BuildContext`. Do not require callers to own a `GlobalKey` unless
the capability fundamentally needs one. Dispose resources owned by state and
never dispose caller-owned controllers.

## State and callbacks

Prefer caller-owned state for business values. Use conventional pairs such as
`value` and `onChanged` for controlled components.

Add uncontrolled state only when it materially simplifies common use. Clearly
define:

- initial value behavior;
- whether later initial-value changes are observed;
- callback ordering;
- restoration behavior;
- controller ownership and disposal.

Callbacks must be precisely typed. Use `VoidCallback`, `ValueChanged<T>`, or a
domain-specific typedef only when the typedef adds meaning. Do not return
nullable `Future`, `Stream`, or collection types.

## Theme and value objects

Make exported configuration objects immutable. Prefer:

- `final` fields;
- `const` constructors;
- typed `copyWith`;
- complete public type annotations;
- value equality when instances are compared, cached, or tested;
- documented interpolation behavior for visual values.

Do not expose implementation inheritance solely for code reuse. Prefer sealed
or final classes unless consumer extension or implementation is an explicit
contract. Avoid public abstract classes with methods that may grow unless
external implementations are required.

Use standard Flutter types in the API. A third-party type in a signature makes
that package part of the compatibility surface and dependency graph.

## Component customization

Use this order of preference:

1. semantic theme tokens for system-wide consistency;
2. a typed component theme for coherent global overrides;
3. a small number of explicit instance parameters;
4. composition slots for content;
5. builders only when the caller genuinely controls rendering.

Do not expose private layout mechanics as customization. Do not add a generic
`Map<String, Object?> options` escape hatch.

## Documentation

Add `///` documentation to public libraries, types, constructors, fields, enum
values, callbacks, and non-obvious parameters.

Start with a one-sentence consumer-focused summary. Then document:

- default behavior and theme resolution;
- valid ranges and assertions;
- ownership and lifecycle;
- callback timing;
- semantics and keyboard behavior;
- thrown exceptions;
- a short compilable example when usage is not obvious.

Use `[Identifier]` references so `dart doc` creates links. Keep examples written
against the public package import.

## Compatibility

Treat these as breaking changes:

- removing or renaming a public declaration;
- adding a required parameter;
- changing a parameter or return type incompatibly;
- changing defaults or behavior relied on by consumers;
- adding abstract members consumers must implement;
- narrowing supported SDKs or platforms;
- changing exported transitive types;
- changing token meaning even when its Dart type stays the same.

Before removal, annotate with a message that names the replacement and intended
removal release:

```dart
@Deprecated('Use NewComponent. Scheduled for removal in 3.0.0.')
```

Keep deprecated behavior working during the migration window. Add migration
examples to the changelog or a dedicated guide for broad changes.

## Review checklist

- Can a consumer accomplish the primary use case with one canonical import?
- Is every export intentional?
- Does the API use familiar Flutter terminology?
- Are public types independent from replaceable implementation dependencies?
- Are constructors const, immutable, and typed where possible?
- Are accessibility and lifecycle semantics documented?
- Can the implementation evolve without changing the public signature?
- Is the semver impact explicitly classified?
