#!/usr/bin/env bash
#
# Builds the tree an adopter of this template would have: the committed
# template, tools/instantiate.sh run over it, and the minimal extension in
# extension/ laid on top. See README.md beside this file.
#
# Usage: .github/template-selftest/assemble.sh <empty-target-dir>
#
# @license     https://www.gnu.org/licenses/agpl-3.0.html AGPL-3.0-or-later

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET="${1:?usage: assemble.sh <empty-target-dir>}"

mkdir -p "$TARGET"
[ -z "$(ls -A "$TARGET")" ] || { echo "$TARGET is not empty" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"

# The committed tree, not the working copy: what "Use this template" copies.
git -C "$ROOT" archive HEAD | tar -x -C "$TARGET"

"$TARGET/tools/instantiate.sh" \
	--module-code altioo-template-selftest \
	--github-org AltiooBV \
	--security-email security@example.invalid \
	--conduct-email conduct@example.invalid \
	--itop-branch 3.2 \
	--php-floor 8.2 \
	--php-ceiling 8.4 >/dev/null

# What instantiate.sh must leave intact, checked here because nothing else
# would notice until an adopter's run.sh fails with "Permission denied".
sBroken="$(cd "$TARGET" && git -C "$ROOT" ls-tree -r HEAD | awk '$1=="100755"{print $4}' \
	| while read -r f; do [ -x "$f" ] || echo "$f"; done)"
[ -z "$sBroken" ] || { printf 'instantiate.sh dropped the executable bit on:\n%s\n' "$sBroken" >&2; exit 1; }

# And Dependabot's composer entry, which ships switched off because the
# template has no composer.json: an extension has one, so instantiate.sh must
# have switched it on, and left a file Dependabot can still parse.
python3 - "$TARGET/.github/dependabot.yml" <<'PY'
import sys, yaml
aEcosystems = [u["package-ecosystem"] for u in yaml.safe_load(open(sys.argv[1]))["updates"]]
if "composer" not in aEcosystems:
	sys.exit("instantiate.sh left Dependabot's composer entry switched off: %s" % aEcosystems)
PY
if grep -qE '^#[-~]( |$)' "$TARGET/.github/dependabot.yml"; then
	echo "instantiate.sh left #- or #~ lines in .github/dependabot.yml" >&2
	exit 1
fi

cp -R "$ROOT/.github/template-selftest/extension/." "$TARGET/"

# composer.lock is resolved here rather than committed: a lock nobody updates
# goes stale, and this extension's only dependency is the test runner.
(cd "$TARGET" && composer update --no-install --no-interaction --no-progress --quiet)

echo "assembled in $TARGET"
