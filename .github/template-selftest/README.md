# Template self-test

What `.github/workflows/template-selftest.yml` runs the harness against, because this repository
is a template and not an extension: on its own, every job that needs `composer.json` or
`extension.xml` has nothing to run on.

`assemble.sh` builds what an adopter would have the day after "Use this template": the committed
tree, `tools/instantiate.sh` run over it, and the minimal extension in `extension/` laid on top.
The workflow then runs `tools/ci/local/run.sh unit` and `matrix` in that tree - the same
`tools/ci/` scripts the extension's own workflows call, in the containers `run.sh` builds.

The extension here is deliberately minimal - no `src/`, no HTTP entry point, no integration suite,
no upgrade fixture - so it also exercises every "skip what the extension does not have" path
`TEMPLATE-CHECKLIST.md` §4 lists. What it does not exercise is the other side of each of those
conditions, nor the workflow YAML itself, which the `workflows` job in `ci.yml` lints.

Run it locally the same way:

```bash
.github/template-selftest/assemble.sh /path/to/empty/dir
/path/to/empty/dir/tools/ci/local/run.sh unit
/path/to/empty/dir/tools/ci/local/run.sh matrix
```

An extension built from the template keeps these files and never runs them: the workflow is
guarded to this repository, and `exclude.txt` keeps `.github/` out of every release archive.
