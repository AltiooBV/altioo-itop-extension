# Template checklist

`doc/itop-extension-guide.md` §9.1 warns about scaffold leftovers before a
first release. This file is how that warning gets actioned for what this
template hands you. Work through it once, then delete this file along with
`tools/instantiate.sh` - both describe the templating step, not the extension
you are building.

## 1. Run the substitution

```bash
tools/instantiate.sh \
  --module-code my-extension \
  --github-org MyOrg \
  --vendor myorg \
  --vendor-name "My Org" \
  --security-email security@example.com \
  --conduct-email conduct@example.com \
  --copyright-holder "My Org" \
  --itop-branch 3.2 \
  --php-floor 8.2 \
  --php-ceiling 8.4
```

It rewrites every `{{PLACEHOLDER}}` token it knows about and then greps for
any it does not - if that grep finds something, a file was added to the
template after this script was last touched, and needs the same treatment.

## 2. What the substitution cannot do for you

- **Write the extension itself.** This template deliberately carries no
  `extension.xml`, `module.<code>.php`, datamodel XML, `src/`, `index.php` or
  `register.php` - those are what makes your extension *this* extension, not
  boilerplate to template over. Use iTop's own extension-creation tooling or
  `doc/itop-extension-guide.md` §1-§2 to start them, and read the whole guide
  before the first line of datamodel.

  **`tools/ci/*` needs `extension.xml` to exist before any of it runs.**
  Every script under `tools/ci/` (and `local/run.sh`) resolves the module
  code from `extension.xml`'s `<extension_code>` at run time rather than
  from a literal - that is what lets this harness carry over unchanged - but
  that means CI is red, not silently skipped, until `extension.xml` exists
  with the right code in it. Write it before the first push, not after the
  first red run.
- **Fill in `CONTRIBUTING.md`'s "How this extension is built" section** and
  `SECURITY.md`'s extension-specific sections (marked with `TEMPLATE NOTE`
  comments in each file). These are facts about *your* repository - its own
  history, its own threat model - not something a sibling repository's answer
  can be copied into. Copying another repository's dates, signing-key history
  or squash decision here would be the first inaccurate provenance claim in
  this one's history; `doc/itop-extension-guide.md` explains why that
  matters and `CONTRIBUTING.md`'s comment says what is policy (reusable) vs.
  fact (yours to state).
- **Write `README.md` and `CHANGELOG.md`.** Deliberately not templated -
  see `doc/itop-extension-guide.md`'s guidance on what a README must cover
  (§9.3) and start `CHANGELOG.md` from its first entry, in Keep a Changelog
  format, the day you cut `0.1.0` or `1.0.0`.
- **Populate `.github/ISSUE_TEMPLATE/feature_request.yml` and `config.yml`**
  if this extension has its own extension point (a plugin mechanism, a tool
  pack convention) - both carry a `TEMPLATE NOTE` where that link goes, and
  are fine to leave generic if there is no such split.
- **Write `doc/ci-itop-matrix.md`, `doc/ci-upgrade.md` and
  `doc/release-checklist.md`.** Not included in this first pass of the
  template - `tools/ci/*` and the three workflows they document are, so the
  scripts work out of the box, but the prose walking through what each stage
  asks still needs writing (or porting and genericising from a sibling
  repository such as `altioo-mcp`, whose versions are close to generic
  already).

## 3. Decide `exclude.txt` for every file you add

Not optional, and easy to forget precisely because forgetting is silent: a
new root-level or `doc/` file that nobody classified ships to a customer
instance by default. `doc/itop-extension-guide.md` §9.1 and `AGENTS.md` §4
(if you copy one, see below) say why.

## 4. If this extension has an HTTP entry point

`tools/ci/http-smoke.sh` assumes one at
`env-<env>/<module code>/index.php` and `extensions/<module code>/index.php`,
and `.github/workflows/ci.yml`'s `package` job comment names `.htaccess` and
`web.config` as the guard files to add to its required-file list. An
extension with no entry point can delete `http-smoke.sh` and the step in
`itop-matrix.yml`/`ci.yml` that calls it, and the `MCP scope` example in
`upgrade-fixture.php` (see below) does not apply.

## 5. Write `tools/ci/checks/module-smoke.php` and `tools/ci/upgrade-fixture.php`

Deliberately not included: they are this extension's own post-setup checks
and upgrade fixture, the way `itop-smoke.php`'s split in `altioo-mcp` (see
`AGENTS.md` there) separates the generic harness from the module's own
checks. `itop-smoke.php` in this template already includes
`tools/ci/checks/module-smoke.php` if present - write that file with your
own settings/class/scope checks, following the shape of the one in
`altioo-mcp` (`tools/ci/checks/module-smoke.php` there). `upgrade-fixture.php`
needs the same kind of extension-specific rewrite; there is no generic
version to copy.

## 6. Point your own harness's instruction file at your own `AGENTS.md`

If you adopt `AGENTS.md` as the repository brief the way `altioo-mcp` does,
write your own - it is deliberately not part of this template because it
names *this* repository's own layout and conventions. Point whichever
harness-specific file you use (`CLAUDE.md`, `GEMINI.md`,
`.github/copilot-instructions.md`, ...) at it with a one-line import, never a
copy - `AGENTS.md` §5 in `altioo-mcp` explains why.

## 7. Add the branch once it is actually exercised

`.github/itop-support.json`'s `branches` array ships with one entry from
`--itop-branch`. Add a second branch only once you have actually installed
on it - the whole matrix, floor and ceiling of the PHP range - never before.
The file's own `_comment` says why.
