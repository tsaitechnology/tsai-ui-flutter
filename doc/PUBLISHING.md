# Publishing

Tsai UI uses a tag-driven GitHub Actions release:

1. `Start release` is started manually with a version increment.
2. It updates package metadata and generates release notes from Git history.
3. After all quality gates pass, it atomically pushes the release commit and
   `v<version>`.
4. The tag automatically starts `Publish to pub.dev`, which publishes through
   pub.dev OIDC.
5. The same tag automatically starts `Deploy documentation and example`, which
   deploys the tagged documentation and web catalog to GitHub Pages.

The workflow keeps the calculated package version, changelog heading,
installation examples, example lockfile, and Git tag aligned.

Only `Start release` supports manual dispatch and starts the complete release
pipeline. Package publication and Pages deployment have no manual trigger and
do not run on ordinary pushes to `main`.

## One-time GitHub setup

### Release token

Create a fine-grained personal access token for
`tsaitechnology/tsai-ui-flutter`:

- repository permission: `Contents: Read and write`;
- the shortest practical expiration;
- an organization-owned release account when available.

Store it in the repository as an Actions secret named `RELEASE_TOKEN`.

The token is necessary because tags pushed with the default `GITHUB_TOKEN` do
not trigger another workflow. Rotate the token before it expires.

The release workflow disables the credential persisted by `actions/checkout`
before pushing the tag. The displayed `git config user.name` controls the tag
author only; GitHub authentication must resolve to the owner of
`RELEASE_TOKEN`, not `github-actions[bot]`. The workflow checks repository push
permission through the GitHub API before starting the release gates.

If the token check returns HTTP 403, verify that:

- the token resource owner is the `tsaitechnology` organization;
- `tsai-ui-flutter` is included in its repository access;
- `Contents` is set to `Read and write`;
- the organization has approved the token and any required SSO authorization.

### Deployment environment

Create a GitHub Actions environment named `pub.dev`. Add required reviewers to
protect publication.

## Publisher and OIDC setup

1. Transfer `tsai_ui` to the verified publisher from the package Admin page.
2. In **Admin > Automated publishing**, select GitHub Actions.
3. Set repository to `tsaitechnology/tsai-ui-flutter`.
4. Set tag pattern to `v{{version}}`.
5. Configure the event and environment options:
   - **Enable publishing from push events:** enabled.
   - **Enable publishing from workflow_dispatch events:** disabled.
   - **Require GitHub Actions environment:** enabled.
   - Environment name: `pub.dev`.

`Start release` uses `workflow_dispatch` to accept the version increment and
run the release gates before pushing its calculated tag. The separate
publishing and Pages workflows are triggered by that tag push, so pub.dev
should authorize push events rather than direct manual publication events.

## Release process

1. Commit finished code and tests, then push them to `main`.
2. Run **Start release** and select `patch`, `minor`, or `major`.
3. Approve the `pub.dev` environment deployment when GitHub requests it.

Do not manually edit `version`, `CHANGELOG.md`, installation version examples,
or `example/pubspec.lock`. The workflow:

1. calculates the next stable version from the selected increment;
2. reads every commit since the latest `v<version>` tag;
3. updates `pubspec.yaml`, README installation examples, and dependency state;
4. generates a dated `CHANGELOG.md` section with commit links;
5. creates a `chore: release <version>` commit;
6. runs formatting, analysis, tests, the example web build, API documentation
   generation, publish dry-run, and pana;
7. atomically pushes the release commit and tag;
8. publishes the tag through OIDC;
9. deploys the documentation and example built from the same tag to GitHub
   Pages.

Use Conventional Commit subjects to produce structured release notes:

```text
feat: add date picker
fix(select): preserve focus after clearing
docs: explain theme overrides
deps: update flutter_lucide
refactor(button): replace button variants
```

`feat`, `fix`, `docs`, and `deps` are grouped into their own changelog sections.
`!` or a `BREAKING CHANGE:` footer creates a Breaking Changes section. Other
commit subjects remain visible under Maintenance.

For the current pre-1.0 lifecycle:

- backward compatibility is not maintained because the package has no
  consumers;
- deprecated aliases, migration shims, and legacy behavior are not retained;
- releases increment the version according to project milestones rather than
  compatibility impact.

Semantic-versioning compatibility begins with `1.0.0`.

No pub.dev credential is stored in GitHub.
