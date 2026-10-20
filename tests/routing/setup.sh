#!/usr/bin/env bash
# Builds isolated projects for the routing test:
#   rules/  the pack as installed (skills, name-only listing, routing rules), no gate
#   gate/   the same plus the gate hook
#   empty/  nothing, to measure the base context size
# Usage: bash tests/routing/setup.sh [--extra]
#   then: python3 tests/routing/run.py rules r1.json && python3 tests/routing/score.py r1.json
set -euo pipefail
R="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
W="${ABS_TEST_DIR:-/tmp/abs-routing-test}"
rm -rf "$W"; mkdir -p "$W/home" "$W/rules/.claude" "$W/empty"
HOME="$W/home" bash "$R/install.sh" --agents claude-code "$@" >/dev/null
cp -R "$W/home/.claude/skills" "$W/rules/.claude/skills"
cp "$W/home/.claude/CLAUDE.md" "$W/rules/CLAUDE.md"
# Project settings get only skillOverrides: the test uses --setting-sources project,local.
node -e '
  const fs = require("fs"); const s = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  fs.writeFileSync(process.argv[2], JSON.stringify({ skillOverrides: s.skillOverrides || {} }, null, 2));
' "$W/home/.claude/settings.json" "$W/rules/.claude/settings.json"
cp -R "$W/rules" "$W/gate"
cp -R "$W/home/.claude/agent-basic-skillset" "$W/gate/.claude/"
node "$R/hooks/settings.mjs" add-gate "$W/gate/.claude/settings.json" "node \"$W/gate/.claude/agent-basic-skillset/skill-gate.mjs\""
rm -f "$W/gate/.claude/settings.json.bak-agent-basic-skillset"
echo "Ready in $W ($(ls "$W/rules/.claude/skills" | wc -l | tr -d ' ') skills)."
