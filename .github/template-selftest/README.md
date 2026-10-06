# Template self-test

What `.github/workflows/template-selftest.yml` runs the harness against, because this repository
is a template and not an extension: on its own, every job that needs `composer.json` or
`extension.xml` has nothing to run on.

`assemble.sh` builds what an adopter would have the day after "Use this template": the committed
tree, `tools/instantiate.sh` run over it, and the minimal extension in `extension/` laid on top.
The workflow then runs `tools/ci/local/run.sh unit` and `matrix` in that tree - the same
`tools/ci/` scripts the extension's own workflows call, in the containers `run.sh` builds - and
last `tools/ci/build-archive.sh`, which is what `ci.yml`'s package job and `release.yml` run.

The extension here is deliberately minimal - no `src/`, no integration suite, no upgrade fixture -
so it also exercises those "skip what the extension does not have" paths `TEMPLATE-CHECKLIST.md`
§4 lists. It does have an `index.php`, answering an empty 204, with `.htaccess` and `web.config`
beside it: that is what puts the generic half of `tools/ci/http-smoke.sh` and the guard-file rule
of `tools/ci/build-archive.sh` through the template's own CI. What it does not exercise is the
other side of the remaining conditions, `upgrade.yml` (which needs a released `v*` tag to upgrade
from), nor the workflow YAML itself, which the `workflows` job in `ci.yml` lints.

Run it locally the same way:

```bash
.github/template-selftest/assemble.sh /path/to/empty/dir
/path/to/empty/dir/tools/ci/local/run.sh unit
/path/to/empty/dir/tools/ci/local/run.sh matrix
```

An extension built from the template keeps these files and never runs them: the workflow is
guarded to this repository, and `exclude.txt` keeps `.github/` out of every release archive.
