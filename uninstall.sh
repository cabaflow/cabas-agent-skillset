#!/usr/bin/env bash
# Uninstalls Caba's Agent Skillset: removes the skills in manifest/skills.tsv (including the
# "extra" group if present), the 2 own skills, the rules block in CLAUDE.md and AGENTS.md,
# the gate and the name-only entries. Other skills and the rest of your instructions stay.
#
# Usage:
#   bash uninstall.sh                         # Claude Code and Codex
#   bash uninstall.sh --agents claude-code    # only Claude Code (or: codex)
#   bash uninstall.sh --retired               # also remove skills older versions installed
#                                             # (manifest/retired.txt); only if you did not
#                                             # install those yourself from elsewhere
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="claude-code,codex"
RETIRED=0
while [ $# -gt 0 ]; do
  case "$1" in
    --agents|--agentes) AGENTS="$2"; shift 2 ;;
    --retired) RETIRED=1; shift ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done
IFS=',' read -r -a AGENT_LIST <<< "$AGENTS"

START="<!-- agent-basic-skillset:start -->"
END="<!-- agent-basic-skillset:end -->"
OWN="$(cd "$DIR/skills" && ls -d */ | tr -d '/' | tr '\n' ' ')"
PUBLIC="$(awk -F'\t' '!/^#/ && NF >= 3 { printf "%s ", $3 }' "$DIR/manifest/skills.tsv")"
if [ "$RETIRED" = 1 ]; then PUBLIC="$PUBLIC $(grep -v '^#' "$DIR/manifest/retired.txt" | tr '\n' ' ')"; fi

for agent in "${AGENT_LIST[@]}"; do
  case "$agent" in
    claude-code) skills="$HOME/.claude/skills"; file="$HOME/.claude/CLAUDE.md" ;;
    codex) skills="${CODEX_HOME:-$HOME/.codex}/skills"; file="${CODEX_HOME:-$HOME/.codex}/AGENTS.md" ;;
    *) continue ;;
  esac
  for s in $OWN; do rm -rf "${skills:?}/$s"; done
  echo "✓ Own skills removed from $skills"
  if [ -f "$file" ]; then
    tmp="$(mktemp)"
    awk -v i="$START" -v f="$END" '
      $0 == i { skip = 1; next }
      $0 == f { skip = 0; next }
      skip == 1 { next }
      $0 == "" { blank++; next }
      { while (blank > 0) { print ""; blank-- } print }
    ' "$file" > "$tmp"
    cat "$tmp" > "$file"
    rm -f "$tmp"
    echo "✓ Rules removed from $file"
  fi
done

SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ] && command -v node >/dev/null; then
  case ",$AGENTS," in
    *,claude-code,*)
      node "$DIR/hooks/settings.mjs" remove-gate "$SETTINGS" || true
      # shellcheck disable=SC2086
      node "$DIR/hooks/settings.mjs" clear-name-only "$SETTINGS" $OWN $PUBLIC || true
      rm -rf "$HOME/.claude/agent-basic-skillset"
      echo "✓ Gate and name-only entries removed from $SETTINGS" ;;
  esac
fi

if command -v npx >/dev/null; then
  AGENT_FLAGS=()
  for agent in "${AGENT_LIST[@]}"; do AGENT_FLAGS+=(-a "$agent"); done
  # shellcheck disable=SC2086
  DISABLE_TELEMETRY="${DISABLE_TELEMETRY:-1}" npx -y skills remove $PUBLIC "${AGENT_FLAGS[@]}" -g -y < /dev/null \
    && echo "✓ Public skills removed"
else
  echo "Node.js (npx) is missing: could not remove the public skills. Delete them from ~/.agents/skills and ~/.claude/skills."
  exit 1
fi
