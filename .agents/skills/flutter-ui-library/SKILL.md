---
name: flutter-ui-library
description: Design, implement, review, and evolve reusable enterprise Flutter UI packages and component libraries. Use for public API design, two-theme token architecture, component boundaries, dependency rules, theming, accessibility, testing, documentation, semantic versioning, package quality gates, and publishing reusable Flutter libraries for mobile and web.
---

# Flutter UI Library

Build a reusable library, not an application. Optimize for a small stable API,
predictable theming, low dependency cost, accessibility, testability, and safe
evolution across hundreds of consuming applications.

## Core workflow

1. Inspect the package, its consumers, supported Flutter/Dart constraints, and
   existing public exports. Do not assume an application architecture applies
   to a component package.
2. Write or update an API inventory before implementation:
   - intended public libraries, types, constructors, callbacks, and themes;
   - internal implementation types;
   - compatibility impact of each change.
3. Define the dependency graph and token contract before adding components.
4. Implement the smallest coherent public surface. Keep implementation under
   `lib/src/` and expose it through deliberate top-level libraries.
5. Test tokens, behavior, semantics, visuals, mobile constraints, and web.
6. Run all quality and publication gates before declaring the package ready.
7. Classify every public API change with semantic versioning and document the
   migration path.

## Required architectural decisions

Default to one Flutter package while tokens, themes, primitives, and components
share a release lifecycle. Split packages only when ownership, supported
platforms, dependency cost, or independent versioning justify the added
coordination burden.

Keep this dependency direction:

```text
public entrypoints
  -> component APIs and implementations
    -> component theme overrides
      -> semantic theme tokens
        -> internal reference tokens and Flutter SDK
```

Never introduce reverse dependencies. Keep the token layer independent of
components. Keep the library independent of the example and documentation apps.
Read [references/architecture.md](references/architecture.md) when creating or
changing package structure, token types, theming, or component boundaries.

## Two-token-set contract

Model exactly two complete theme token sets: light and dark. Both sets must be
instances of the same immutable, strongly typed schema and must contain the
same non-null token fields. Enforce parity through the Dart type system, not
string-keyed maps or runtime fallback.

Organize tokens into three levels:

1. Reference tokens: raw palettes and scales; internal by default.
2. Semantic tokens: public intent-based roles consumed by components.
3. Component tokens: derived defaults or narrowly exposed component overrides.

Use semantic names such as `contentPrimary`, `surfaceRaised`, and
`actionDanger`; do not expose appearance names such as `gray900` as component
contracts. Include paired foreground/background roles so contrast is explicit.

Integrate the resolved semantic set with Flutter theming through a typed
`ThemeExtension` that implements `copyWith` and `lerp`. Components must read the
nearest resolved tokens from context and must not branch on light/dark mode or
hardcode theme values.

Use this resolution order:

```text
explicit component parameter
  -> component theme override
    -> semantic token
      -> internal reference value
```

Treat generated design-token input as replaceable build input. Do not leak
generator names, source JSON shapes, or design-tool identifiers into the public
API.

## Public API rules

- Expose a canonical `lib/<package_name>.dart` library. Add secondary public
  libraries only for meaningful opt-in surfaces.
- Export declarations explicitly. Never export all of `lib/src/`.
- Treat every exported declaration, constructor, parameter, callback,
  extension, enum value, and behavior as a compatibility commitment.
- Prefer immutable `final` value types and `const` constructors.
- Use familiar Flutter types and conventions. Accept `Key? key`, named
  parameters, typed callbacks, and `WidgetState` behavior where applicable.
- Do not require a state-management, routing, networking, service-locator, or
  code-generation framework to consume a visual component.
- Do not expose third-party dependency types unless that dependency is an
  intentional part of the library contract.
- Document public members with `///`, including defaults, constraints,
  semantics, exceptions, and examples when behavior is not obvious.
- Deprecate before removal and include the replacement and removal target in
  the `@Deprecated` message.

Read [references/public-api.md](references/public-api.md) before adding or
changing exports, constructors, token types, callbacks, or deprecations.

## Component rules

- Give each component one clear responsibility and a bounded public API.
- Keep application business state outside the library. Support controlled and
  uncontrolled behavior only when both use cases are real and documented.
- Derive visual defaults from semantic tokens. Expose per-instance overrides
  sparingly; repeated customization belongs in a typed component theme.
- Preserve standard Flutter behavior for focus, keyboard, pointer, gestures,
  semantics, text scaling, directionality, and disabled states.
- Prefer composition and standard Flutter primitives over custom render
  objects. Use a custom render object only for measured layout or performance
  requirements that widgets cannot satisfy.
- Avoid sibling-component implementation imports. Compose through a stable
  public component contract when composition is intentional.
- Keep asynchronous work, navigation, data fetching, and global mutable state
  out of visual components.

## Dependency rules

- Minimize runtime dependencies; prefer the Flutter and Dart SDKs.
- Put runtime imports in `dependencies` and tools/tests in `dev_dependencies`.
- Use tested version ranges and avoid unnecessarily narrow constraints.
- Never rely on transitive imports.
- Do not publish `dependency_overrides`; consumer resolution ignores them.
- Do not commit the package lockfile for a reusable library. Treat an example
  application as an application and lock it when reproducibility requires it.
- Test both the lowest supported and current resolvable dependency graphs.
- Keep platform-specific imports behind conditional imports and preserve web
  compatibility across every top-level public library.

## Verification

Require many unit and widget tests, focused integration tests through the
example application, deterministic golden tests for stable visual contracts,
and automated accessibility checks. Cover both token sets and all applicable
component states.

Read [references/testing-and-quality.md](references/testing-and-quality.md)
when implementing tests, CI, accessibility checks, or release gates.

Read [references/release-and-docs.md](references/release-and-docs.md) when
writing package documentation, changing dependencies, versioning, deprecating,
or publishing.

Use [references/official-sources.md](references/official-sources.md) to verify
SDK-sensitive guidance against current official Dart and Flutter documentation.
Prefer official sources over blog posts and re-check them when the supported SDK
range changes.

## Completion report

Report:

- public API additions and removals;
- token-schema or dependency-direction changes;
- compatibility and version impact;
- tests and quality gates run;
- unsupported platforms, unverified assumptions, and remaining risks.
