# Development Plan

## Phase 0: Foundation and buttons

Status: implemented.

- Create one package and Android/iOS/web example.
- Transfer the four Penpot token sets into typed Dart tokens.
- Install light/dark tokens through `ThemeExtension`.
- Bundle typography assets and expose Lucide through an opt-in entrypoint.
- Implement Button variants, sizes, disabled/loading and interactive states.
- Add first unit, widget, keyboard, and accessibility tests.

## Phase 1: Forms

- Input, phone, PIN, OTP, Select.
- Shared field primitive only after repeated behavior is confirmed.
- Controlled values, validation visuals, focus/error/loading semantics.
- Mobile keyboards, autofill, password managers, and web tab traversal.

## Phase 2: Selection controls

- Checkbox, Radio, Switch.
- Label placement and state parity with Penpot variants.
- Controlled APIs and form semantics.

## Phase 3: Interactive web documentation

The existing `example` becomes the documentation app rather than a separate
package.

1. Add declarative routes per component.
2. Add responsive navigation and searchable component index.
3. Render a state matrix for light/dark, size, direction, text scale, and
   enabled/loading/error conditions.
4. Add live controls backed only by public component parameters.
5. Show copyable usage snippets generated from typed examples.
6. Add accessibility panels for focus order and semantics.
7. Add visual regression routes with deterministic dimensions.

The first screen remains the usable component catalog, not a marketing page.

## Testing plan

For every component:

- unit tests for token/style resolution;
- widget tests for every behavior branch;
- light and dark stable-state goldens;
- LTR/RTL, 200% text scale, narrow/mobile and desktop constraints;
- pointer hover, press, focus, keyboard activation, and disabled rejection;
- Android/iOS tap-target, labels, contrast, and semantics guidelines;
- integration smoke test in the example app;
- release-mode web build.

Required gates:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test --coverage
dart doc
flutter pub outdated
flutter pub publish --dry-run
cd example && flutter build web --release
```

Golden baselines and full integration tests start in Phase 1, after the first
component APIs stabilize.

## Deployment plan

Pull requests:

1. Run format, analyzer, tests, coverage, doc generation, and web build.
2. Upload coverage, web build, and golden diffs as artifacts.
3. Deploy a preview of `example/build/web`.

Main branch:

1. Build the web catalog in release mode.
2. Deploy immutable assets to the selected static host.
3. Promote the same artifact to the documentation domain.

Tagged releases:

1. Verify changelog and semver classification.
2. Run lowest-supported and current dependency graphs.
3. Run `flutter pub publish --dry-run` and `pana`.
4. Publish the package only after removing `publish_to: none`.
5. Create a release tag and retain build/test evidence.

Hosting and package publication remain intentionally unconfigured until the
repository URL, CI provider, credentials, package owner, and license are known.
