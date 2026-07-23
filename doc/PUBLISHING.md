# Publishing

Tsai UI uses a two-stage GitHub Actions release:

1. `Prepare pub.dev release` is started manually with a version.
2. After all quality gates pass, it pushes `v<version>`.
3. The tag starts `Publish to pub.dev`, which publishes through pub.dev OIDC.

The package version, changelog heading, workflow input, and Git tag must match.

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
2. Run **Actions > Prepare pub.dev release > Run workflow**.
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

`Prepare pub.dev release` uses `workflow_dispatch` only to validate the version
and push its tag. The separate publishing workflow is triggered by that tag
push, so pub.dev should authorize push events rather than direct manual
publication events.

The first package upload cannot target a verified publisher directly. Publish
with an authorized Google Account, then transfer it.

## Later releases

1. Update `version` in `pubspec.yaml`.
2. Add the matching version heading and release notes to `CHANGELOG.md`.
3. Commit and push the release to `main`.
4. Run **Prepare pub.dev release** with that version.

The workflow runs formatting, analysis, tests, the example web build, API
documentation generation, publish dry-run, and pana. It only pushes the tag
when every gate passes. The tag-triggered workflow then publishes through OIDC;
no pub.dev credential is stored in GitHub.
