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
	--vendor altioo \
	--vendor-name "Altioo" \
	--security-email security@example.invalid \
	--conduct-email conduct@example.invalid \
	--copyright-holder "Altioo" \
	--itop-branch 3.2 \
	--php-floor 8.2 \
	--php-ceiling 8.4 >/dev/null

# What instantiate.sh must leave intact, checked here because nothing else
# would notice until an adopter's run.sh fails with "Permission denied".
sBroken="$(cd "$TARGET" && git -C "$ROOT" ls-tree -r HEAD | awk '$1=="100755"{print $4}' \
	| while read -r f; do [ -x "$f" ] || echo "$f"; done)"
[ -z "$sBroken" ] || { printf 'instantiate.sh dropped the executable bit on:\n%s\n' "$sBroken" >&2; exit 1; }

cp -R "$ROOT/.github/template-selftest/extension/." "$TARGET/"

# composer.lock is resolved here rather than committed: a lock nobody updates
# goes stale, and this extension's only dependency is the test runner.
(cd "$TARGET" && composer update --no-install --no-interaction --no-progress --quiet)

echo "assembled in $TARGET"
