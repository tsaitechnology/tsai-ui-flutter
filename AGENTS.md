# Project Instructions

## Language

- Write all repository content in English, including source code comments,
  documentation, tests, examples, user-facing copy, and commit messages.
- Use another language only when a task explicitly requires localization or
  non-English content.

## Releases

- Do not manually update the package version, version-only lockfile entries,
  installation version snippets, or `CHANGELOG.md` during feature development.
- Release versions and changelog entries are generated and maintained by CI.

## Local Skills

- Project-specific agent skills are available under `.agents/skills`.
- Before starting a task, check whether a relevant
  `.agents/skills/<skill-name>/SKILL.md` exists and follow its instructions.
- Use the most specific applicable skill; do not duplicate or rewrite skill
  instructions in this file.
