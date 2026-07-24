# Development And Release Readiness

Tsai UI is preparing for its stable `1.0.0` release. The package foundation,
light and dark themes, typography, actions, selection controls, adaptive
selects, and text/code inputs are implemented. The example application is the
interactive component catalog and the source for public live examples.

## Before 1.0.0

1. Freeze the public declarations listed in
   [API_INVENTORY.md](API_INVENTORY.md).
2. Automate the Penpot token snapshot and parity validation described in
   [PENPOT_SYNC.md](PENPOT_SYNC.md).
3. Add stable light/dark goldens for every component and state family.
4. Cover LTR/RTL, 200% text scale, narrow/mobile and desktop constraints.
5. Verify Android, iOS, and web release builds from the same revision.
6. Review accessibility labels, focus order, keyboard behavior, contrast, and
   tap targets.
7. Publish a release candidate and validate migration in at least one consumer
   application.

## Component Changes

Every component change follows the same sequence:

1. Inspect the current Penpot component and affected token sets.
2. Update the public API inventory before changing an exported declaration.
3. Keep product color, typography, spacing, radius, border, shadow, and motion
   values in `TsaiThemeTokens`.
4. Keep fixed component geometry private unless Penpot adds a corresponding
   sizing token.
5. Update the catalog example, public widget page, tests, and changelog.
6. Remove superseded APIs and behavior instead of retaining compatibility
   layers before `1.0.0`.

## Required Gates

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
cd example && flutter test
cd ..
flutter test --coverage
dart doc
mkdocs build --strict
flutter pub outdated
flutter pub publish --dry-run
cd example && flutter build web --release
```

CI should retain coverage, generated API documentation, the release web build,
and golden diffs as artifacts. Tag-driven package publication and catalog
deployment are documented in [PUBLISHING.md](PUBLISHING.md).
