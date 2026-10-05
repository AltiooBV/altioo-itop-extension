<?php
/**
 * The self-test's HTTP entry point: exists so that tools/ci/http-smoke.sh and
 * the guard-file rule in tools/ci/build-archive.sh have something to act on in
 * the template's own CI. It boots nothing and reads nothing, and answers every
 * request with an empty 204. Not for installation anywhere else.
 *
 * @copyright   Copyright (C) 2026 Altioo
 * @license     https://www.gnu.org/licenses/agpl-3.0.html AGPL-3.0-or-later
 */

http_response_code(204);
