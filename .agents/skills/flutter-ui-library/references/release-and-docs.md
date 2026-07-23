# Release, Dependencies, And Documentation

## Contents

- Package metadata
- Dependency policy
- Documentation contract
- Versioning
- Deprecation and migration
- Publication
- Release checklist

## Package metadata

Maintain a complete `pubspec.yaml` with:

- package name and concise description;
- semantic version;
- repository and issue tracker;
- supported Dart and Flutter SDK constraints;
- explicit platform declaration only when automatic detection is insufficient;
- only required runtime dependencies;
- declared assets and fonts owned by the package.

Do not claim a platform unless its public import graph and example build work on
that platform.

## Dependency policy

Prefer SDK functionality before adding a package. For every runtime dependency,
document internally:

- why it is needed;
- whether its types leak into public API;
- license and maintenance status;
- supported platform impact;
- size and initialization cost;
- replacement and upgrade risk.

Use compatible version ranges. Avoid pinning a single version without a
technical reason. Test lower bounds and current resolvable versions.

Place test, lint, code-generation, and documentation tools in
`dev_dependencies`. Never import a dev dependency from `lib/`.

Do not depend on another package's `lib/src`. Do not rely on a transitive
dependency. Do not put `dependency_overrides` in the publishable contract;
consumer packages ignore those overrides.

For a reusable package, omit `pubspec.lock` from version control. An example app
is an application and may commit its lockfile for reproducible documentation
and integration builds.

## Documentation contract

Ship:

- `README.md` with purpose, supported platforms, install, minimal usage,
  theming, accessibility notes, and links;
- `CHANGELOG.md` with every released user-visible change;
- `LICENSE`;
- a runnable `example/` that uses only public imports;
- generated API docs from comprehensive `///` comments.

The minimal README example must compile. Show installation of both token sets
and theme switching. Keep exhaustive component demos in the example/web
documentation rather than making the README enormous.

Document token semantics and customization guarantees. Do not promise direct
access to raw design-tool tokens if the public contract is semantic.

## Versioning

Apply semantic versioning to API and behavior:

- patch: compatible bug fix or internal change;
- minor: backwards-compatible public capability;
- major: incompatible API, behavior, platform, or SDK change.

Before `1.0.0`, follow Dart community convention:

- `0.x.y` to `0.(x+1).0` for breaking changes;
- `0.x.y` to `0.x.(y+1)` for compatible features;
- build suffix for changes that do not affect public API when appropriate.

Because the design system is evolving, publish prereleases for broad token or
component experiments. Do not use pre-1.0 status as permission for undocumented
breaking changes.

Changes to visual defaults can be breaking even when signatures are unchanged.
Classify token renames, semantic changes, interaction changes, and golden
contract changes explicitly.

## Deprecation and migration

Prefer additive migration:

1. Introduce the replacement.
2. Mark the old API with `@Deprecated`.
3. Include the replacement and expected removal release in the message.
4. Document before/after usage.
5. Keep tests for both paths during the window.
6. Remove only in the declared breaking release.

For large migrations, provide a guide and mechanical `dart fix` support when
the volume and repeatability justify maintaining it.

## Publication

Before publishing:

1. Verify clean formatting, analysis, tests, docs, example, and web build.
2. Run `flutter pub outdated` and review constraints.
3. Run `flutter pub publish --dry-run`.
4. Inspect every file in the proposed archive.
5. Run current `pana` and review lost pub points.
6. Confirm version and changelog agree.
7. Confirm migration guidance for breaking or deprecated APIs.
8. Publish a prerelease when compatibility is not yet proven.

Published versions are immutable. Never publish secrets, local generated
caches, goldens not intended for distribution, or internal planning files.
Use `.pubignore` only when `.gitignore` cannot express the publication set.

## Release checklist

- Public API inventory reviewed.
- Both token sets complete and tested.
- API documentation generated without unresolved references.
- README example compiled.
- Example application tested from public imports.
- Android, iOS, and web support verified as claimed.
- Accessibility and golden matrices passed.
- Minimum and current dependency graphs passed.
- Changelog and semver classification reviewed.
- Publish dry run contains only intended files.
- Remaining risks recorded.
