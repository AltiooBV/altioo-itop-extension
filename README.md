# Altioo iTop extension template

A GitHub template repository for building an iTop extension - any kind:
a console UI module, a background integration, a REST or MCP server, a
datamodel-only package. Nothing in here is specific to one domain; where a
decision genuinely cannot be generic (a threat model, a changelog, the
extension's own datamodel), this template says so and leaves it to you rather
than guessing.

It exists so that the CI harness, the contributor process and the coding
standard are written once and reused, instead of copied and lightly edited
into a slightly different version each time a new extension starts. The
harness this template ships is the one built for
[`altioo-mcp`](https://github.com/AltiooBV/altioo-mcp) and proved out there
first - iTop install/upgrade against packaged releases, a PHP matrix, a
release archive with an SBOM, a coding-standard gate, static analysis, a
vulnerability scan - then generalised so it carries no reference to that or
any other specific module.

## Using this template

1. **GitHub → "Use this template" → "Create a new repository".**
2. Clone it, then run the checklist:

   ```bash
   cat TEMPLATE-CHECKLIST.md
   ```

   Start with `tools/instantiate.sh`, which fills in every `{{PLACEHOLDER}}`
   token this template carries - the module code, the GitHub org, the
   contact mailboxes, the supported iTop branch and PHP range. What it cannot fill in - the
   extension's own code, its README, its threat model, its changelog - is
   listed in the same file.
3. Read `doc/itop-extension-guide.md` before writing the first line of
   datamodel or PHP. It is the generic development guide - the same file in
   every repository that adopts it - and it is the only file in this
   template that never needs a placeholder filled in.

## What is in here, and why

| | |
|---|---|
| `doc/itop-extension-guide.md`, `doc/itop-branch-notes.md` | The development guide and its dated, branch-specific companion. Read both before the first change. |
| `doc/ci-itop-matrix.md`, `doc/ci-upgrade.md`, `doc/release-checklist.md` | What each CI stage asks, how to run it locally, and the release procedure - generic, to adapt to the extension (`TEMPLATE-CHECKLIST.md` §2). |
| `tools/ci/*`, `tools/ci/local/run.sh` | The CI harness: install/upgrade against a packaged iTop release, a smoke test, a Docker-based local runner that gives the same answer as Actions without spending Actions minutes. |
| `.github/workflows/{ci,itop-matrix,upgrade,release}.yml` | The workflows that call the harness above. None of them names a module - `tools/ci/*` reads the module code from `extension.xml` at run time, so this tree carries over to a renamed or forked extension unchanged. |
| `.github/itop-support.json` | The single declared-support file the CI matrix is computed from, and (if you wire up the equivalent of `altioo-mcp`'s `ModuleMetadataTest`) that every prose claim of supported versions should be checked against. |
| `phpcs.xml.dist`, `tools/phpcs/iTop/`, `psalm.xml`, `phpunit.xml.dist` | The coding standard, static analysis and test-suite configuration this guide expects. |
| `review/review-personas.md` | The review passes this extension adds to the guide's - none until you write them (`TEMPLATE-CHECKLIST.md` §8). Findings go beside it, gitignored. |
| `tools/hooks/guide-gate.sh`, `.claude/settings.json` | A hook that refuses an AI assistant's first edit until it has read the development guide - the enforcement for `AGENTS.md`'s "read the guide first", for the harnesses that support hooks. |
| `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/*` | Contributor process, disclosure rules for AI-assisted work, and the security-reporting commitment. Marked with `TEMPLATE NOTE` comments wherever a section cannot be generic. |
| `exclude.txt` | What stays out of the release archive `release.yml` builds - the process/tooling files above, none of which an installed instance has use for. |
| `tools/reconcile-since.py`, `tools/sbom.php` | Small maintenance scripts referenced from the guide. |

## What is deliberately *not* in here

`extension.xml`, `module.<code>.php`, datamodel XML, `src/`, `index.php`,
`register.php`, `README.md`'s own content, `CHANGELOG.md`, and most unit
tests - these are what make an extension *that* extension, not boilerplate.
`TEMPLATE-CHECKLIST.md` says what to do about each.

## Reporting a vulnerability in this template

`SECURITY.md` here is the template for *your* extension's policy: until
`tools/instantiate.sh` and you have filled it in, it names no address anyone
reads. A vulnerability in the template itself - the CI harness, the release
workflow, `tools/` - is reported privately, never in a public issue, through
either channel:

- **GitHub** - [Report a vulnerability](https://github.com/AltiooBV/altioo-itop-extension/security/advisories/new)
  on this repository.
- **Email** - <security@altioo.com>, the same mailbox altioo-mcp names, if
  you would rather not use GitHub or the form is not available to you.

Every extension created from the template carries the same harness, so a fix
here is announced with what each of them has to change.

## Provenance

This template was extracted from
[`altioo-mcp`](https://github.com/AltiooBV/altioo-mcp) with AI assistance,
disclosed per that repository's own `CONTRIBUTING.md`. See its history for
the decisions behind the split (which files are generic vs. module-specific,
and why).
