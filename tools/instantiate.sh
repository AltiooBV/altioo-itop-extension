#!/usr/bin/env bash
#
# Fills in this template's placeholders, in place, in the repository that was
# created from it. One variable per fact instead of a table of manual edits -
# TEMPLATE-CHECKLIST.md is the table, for whoever prefers to edit by hand or
# wants to see what this script is about to touch before it touches it.
#
# Every placeholder is a `{{NAME}}` token, chosen so that grepping for `{{`
# after this script runs finds anything it missed - a file this script does
# not know about, or a value left empty.
#
# Usage:
#   tools/instantiate.sh \
#     --module-code my-extension \
#     --github-org MyOrg \
#     --vendor myorg \
#     --vendor-name "My Org" \
#     --security-email security@example.com \
#     --conduct-email conduct@example.com \
#     --itop-branch 3.2 \
#     --php-floor 8.2 \
#     --php-ceiling 8.4
#
# Every argument is required; there is no safe default for a name that ends up
# in a GitHub URL or a From: address. Run it once, on a fresh checkout, then
# delete this file and TEMPLATE-CHECKLIST.md - both describe the templating
# step, not the extension you are about to build.
#
# @license     https://www.gnu.org/licenses/agpl-3.0.html AGPL-3.0-or-later

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MODULE_CODE=""
GITHUB_ORG=""
VENDOR=""
VENDOR_NAME=""
SECURITY_EMAIL=""
CONDUCT_EMAIL=""
ITOP_BRANCH=""
PHP_FLOOR=""
PHP_CEILING=""

while [ $# -gt 0 ]; do
	case "$1" in
	--module-code) MODULE_CODE="$2"; shift 2 ;;
	--github-org) GITHUB_ORG="$2"; shift 2 ;;
	--vendor) VENDOR="$2"; shift 2 ;;
	--vendor-name) VENDOR_NAME="$2"; shift 2 ;;
	--security-email) SECURITY_EMAIL="$2"; shift 2 ;;
	--conduct-email) CONDUCT_EMAIL="$2"; shift 2 ;;
	--itop-branch) ITOP_BRANCH="$2"; shift 2 ;;
	--php-floor) PHP_FLOOR="$2"; shift 2 ;;
	--php-ceiling) PHP_CEILING="$2"; shift 2 ;;
	*) echo "unknown argument: $1" >&2; exit 1 ;;
	esac
done

for v in MODULE_CODE GITHUB_ORG VENDOR VENDOR_NAME SECURITY_EMAIL CONDUCT_EMAIL \
         ITOP_BRANCH PHP_FLOOR PHP_CEILING; do
	[ -n "${!v}" ] || { echo "missing --$(echo "$v" | tr '[:upper:]_' '[:lower:]-')" >&2; exit 1; }
	# Escaped once here for the sed replacements below: a "/" ends the
	# expression and an "&" stands for the matched token, so a vendor name
	# such as "Smith & Co" would otherwise come out as "Smith {{VENDOR_NAME}} Co".
	printf -v "$v" '%s' "$(printf '%s' "${!v}" | sed -e 's/[/&\]/\\&/g')"
done

echo "Substituting placeholders under $ROOT ..."

# -print0/read -d '' rather than a bare glob: file names here never contain a
# newline, but this is the one place in the template where getting that wrong
# would corrupt a file rather than just look wrong in a diff.
while IFS= read -r -d '' f; do
	# sed -i writes a new file, and on an ACL-backed share that new file loses
	# the executable bit - which git then records as a mode change on every
	# script under tools/. Put the original mode back.
	sMode=$(stat -c '%a' "$f")
	sed -i \
		-e "s/{{MODULE_CODE}}/${MODULE_CODE}/g" \
		-e "s/{{GITHUB_ORG}}/${GITHUB_ORG}/g" \
		-e "s/{{VENDOR}}/${VENDOR}/g" \
		-e "s/{{VENDOR_NAME}}/${VENDOR_NAME}/g" \
		-e "s/{{SECURITY_EMAIL}}/${SECURITY_EMAIL}/g" \
		-e "s/{{CONDUCT_EMAIL}}/${CONDUCT_EMAIL}/g" \
		-e "s/{{ITOP_BRANCH}}/${ITOP_BRANCH}/g" \
		-e "s/{{PHP_FLOOR}}/${PHP_FLOOR}/g" \
		-e "s/{{PHP_CEILING}}/${PHP_CEILING}/g" \
		"$f"
	chmod "$sMode" "$f"
done < <(find "$ROOT" -type f -not -path '*/.git/*' -print0)

echo
echo "Done. Anything this script did not know about is still a literal {{...}} token:"
if grep -rl '{{[A-Z_]*}}' "$ROOT" --exclude-dir=.git; then
	echo
	echo "^ those files still need a manual look - most likely SECURITY.md and CONTRIBUTING.md," \
	     "whose extension-specific sections this script deliberately does not fill in."
else
	echo "  none found."
fi

echo
echo "Next: read TEMPLATE-CHECKLIST.md, then delete it and this script."
