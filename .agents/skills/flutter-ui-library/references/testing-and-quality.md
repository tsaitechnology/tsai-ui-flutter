# Testing And Quality Gates

## Contents

- Test strategy
- Token tests
- Component matrix
- Golden tests
- Accessibility
- Example and web tests
- Dependency compatibility
- Required gates

## Test strategy

Follow Flutter's test pyramid: many unit and widget tests, plus focused
integration tests for complete consumer workflows. For a component library,
widget tests are the primary behavioral contract.

Test through public imports by default. Use internal imports only for isolated
algorithms that cannot be exercised clearly through public behavior.

## Token tests

For both canonical token sets, verify:

- construction uses the same concrete non-null schema;
- all semantic foreground/background pairs meet the agreed contrast policy;
- values that must differ by theme actually differ;
- theme-independent scales remain intentional;
- `copyWith()` changes only requested values;
- `lerp(a, b, 0)` equals `a` and `lerp(a, b, 1)` equals `b`;
- intermediate interpolation is valid;
- theme installation and context lookup work;
- no component requires a light/dark branch to resolve styling.

The shared Dart type enforces field parity. Do not duplicate a string-key schema
test unless external generated input must be validated before Dart generation.

## Component matrix

Cover every applicable dimension:

```text
theme: light, dark
state: enabled, disabled, hovered, focused, pressed, selected, loading, error
input: pointer, touch, keyboard
direction: LTR, RTL
text: default and large/nonlinear scaling
constraints: narrow, normal, unbounded where supported
platform behavior: Android, iOS, web where intentionally different
content: empty, normal, long, localized
```

Do not create meaningless Cartesian combinations. Select cases that exercise
each branch and each public promise.

Widget tests should verify:

- rendering and layout without overflow;
- callback count, value, and ordering;
- focus traversal and keyboard activation;
- pointer hover and cursor behavior on web;
- disabled controls reject interaction;
- semantics labels, values, roles, flags, and actions;
- direction-aware padding and icon placement;
- controller ownership and disposal;
- animation completion and reduced-motion behavior where applicable.

## Golden tests

Use golden tests as an enterprise visual regression layer, not as the only
behavioral test.

Make goldens deterministic:

- load controlled fonts;
- fix surface size and device pixel ratio;
- settle animations or sample a named frame;
- avoid timestamps, randomness, network images, and platform-dependent output;
- group expected images by component, theme, state, and viewport;
- review diffs rather than blindly updating baselines.

Include both token sets and the stable visual states of every component. Add
mobile-sized and web/desktop-sized constraints when layout changes.

## Accessibility

Use `tester.ensureSemantics()` and Flutter's Accessibility Guideline API.
Check applicable guidelines:

- `androidTapTargetGuideline`;
- `iOSTapTargetGuideline`;
- `labeledTapTargetGuideline`;
- `textContrastGuideline`.

Also test:

- logical traversal order;
- meaningful semantics roles and actions;
- large text and display scaling without clipping;
- high contrast and bold-text behavior when supported;
- usability without color as the only state signal;
- web semantics/ARIA through the example application.

Prefer standard Flutter widgets when they already provide correct semantics.
Add explicit `Semantics` only when composition or custom rendering loses intent.

## Example and web tests

Maintain an example application that consumes only the public API. Use it for:

- interactive documentation;
- integration tests of theme switching;
- every component and state;
- keyboard, pointer, focus, and semantics checks;
- release-mode web builds.

Run at least one integration smoke flow for each supported target family. Build
the web example in release mode so conditional imports and web-incompatible
dependencies fail before release.

## Dependency compatibility

Test the current resolvable graph and the lowest supported graph. Run a
downgrade resolution, test it, then restore and test the upgraded resolution.

Check:

- latest stable supported Flutter and Dart SDKs;
- minimum declared SDK;
- oldest allowed direct dependencies;
- newest resolvable direct dependencies;
- no accidental reliance on transitive imports;
- no `dependency_overrides` required for success.

## Required gates

Adapt commands to the workspace, but preserve these outcomes:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test --coverage
dart doc
flutter pub outdated
flutter pub publish --dry-run
flutter build web --release
```

Also run local `pana` analysis before publication when pub.dev quality matters.
Fail CI on analyzer warnings, test failures, documentation generation errors,
unexpected publish contents, and web build failures.

Run integration and golden suites explicitly if the default `flutter test`
command does not include them. Store coverage and golden diffs as CI artifacts.

## Completion evidence

Record:

- exact commands and exit status;
- tested Flutter/Dart versions;
- token sets, states, viewports, and platforms covered;
- intentional golden updates;
- skipped gates with a concrete reason;
- remaining compatibility and accessibility risks.
