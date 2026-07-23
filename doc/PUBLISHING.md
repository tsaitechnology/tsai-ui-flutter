# Publishing

Tsai UI uses a tag-driven GitHub Actions release:

1. `Start release` is started manually with a version.
2. It updates package metadata and generates release notes from Git history.
3. After all quality gates pass, it atomically pushes the release commit and
   `v<version>`.
4. The tag automatically starts `Publish to pub.dev`, which publishes through
   pub.dev OIDC.
5. The same tag automatically starts `Deploy documentation and example`, which
   deploys the tagged documentation and web catalog to GitHub Pages.

The workflow keeps the package version, changelog heading, installation
examples, example lockfile, workflow input, and Git tag aligned.

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

## First publication

pub.dev does not allow automation to create a package. The first version must
be uploaded manually.

1. Commit and push the release-ready version to `main`.
2. Run **Actions > Start release > Run workflow**.
3. Enter the exact version from `pubspec.yaml`, without `v`.
4. Wait for all checks and tag creation.
5. Check out the immutable tagged revision locally:

   ```bash
   git fetch --tags
   git switch --detach v0.1.0
   flutter pub publish
   git switch main
   ```

6. Complete the browser authentication and confirm the archive.

For the first tag, `Publish to pub.dev` detects that the package does not exist
and skips OIDC publication with an explanatory message.

## Publisher and OIDC setup

After the first version appears on pub.dev:

1. Transfer `tsai_ui` to the verified publisher from the package Admin page.
2. In **Admin > Automated publishing**, select GitHub Actions.
3. Set repository to `tsaitechnology/tsai-ui-flutter`.
4. Set tag pattern to `v{{version}}`.
5. Configure the event and environment options:
   - **Enable publishing from push events:** enabled.
   - **Enable publishing from workflow_dispatch events:** disabled.
   - **Require GitHub Actions environment:** enabled.
   - Environment name: `pub.dev`.

`Start release` uses `workflow_dispatch` to accept the next version and run the
release gates before pushing its tag. The separate publishing and Pages
workflows are triggered by that tag push, so pub.dev should authorize push
events rather than direct manual publication events.

The first package upload cannot target a verified publisher directly. Publish
with an authorized Google Account, then transfer it.

## Later releases

1. Commit finished code and tests, then push them to `main`.
2. Run **Start release** with the new version, without `v`.
3. Approve the `pub.dev` environment deployment when GitHub requests it.

Do not manually edit `version`, `CHANGELOG.md`, installation version examples,
or `example/pubspec.lock`. The workflow:

1. verifies that the requested stable version is greater than the current one;
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
feat!: replace deprecated button variant
```

`feat`, `fix`, `docs`, and `deps` are grouped into their own changelog sections.
`!` or a `BREAKING CHANGE:` footer creates a Breaking Changes section. Other
commit subjects remain visible under Maintenance.

For the current pre-1.0 lifecycle:

- compatible fixes and additions increment the patch, for example `0.1.0` to
  `0.1.1`;
- breaking public API or behavior increments the minor, for example `0.1.x` to
  `0.2.0`.

No pub.dev credential is stored in GitHub.
