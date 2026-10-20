#!/usr/bin/env bash
# Builds isolated Codex homes for the routing test:
#   codex-rules/  the pack installed for Codex (skills + AGENTS.md rules)
#   codex-empty/  nothing, to measure the base context size
# Your Codex login (auth.json) is copied in; your config, plugins and skills are not.
# Usage: bash tests/routing/setup_codex.sh [--extra]
#   then: python3 tests/routing/run_codex.py codex-rules c1.json && python3 tests/routing/score.py c1.json
set -euo pipefail
R="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
W="${ABS_TEST_DIR:-/tmp/abs-routing-test}"
AUTH="${CODEX_HOME:-$HOME/.codex}/auth.json"
[ -f "$AUTH" ] || { echo "No Codex login found at $AUTH. Run codex login first."; exit 1; }
rm -rf "$W/codex-rules" "$W/codex-empty" "$W/codex-project"
mkdir -p "$W/codex-rules/home/.codex" "$W/codex-empty/home/.codex" "$W/codex-project"
git -C "$W/codex-project" init -q
HOME="$W/codex-rules/home" CODEX_HOME="$W/codex-rules/home/.codex" bash "$R/install.sh" --agents codex "$@" >/dev/null
for c in codex-rules codex-empty; do
  cp "$AUTH" "$W/$c/home/.codex/auth.json"
  : > "$W/$c/home/.codex/config.toml"
done
echo "Ready in $W ($(ls "$W/codex-rules/home/.agents/skills" "$W/codex-rules/home/.codex/skills" | grep -vc ':$\|^$') skills)."
