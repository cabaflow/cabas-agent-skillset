#!/usr/bin/env bash
# Installs Caba's Agent Skillset: the 2 own skills, the public skills in manifest/skills.tsv
# (each at its pinned commit) and the routing rules in the agent's global instructions.
# Needs Node.js 22+ (npx) and git. Public skills are downloaded from their original repositories
# with git and installed with the "skills" CLI (pinned version).
#
# Usage:
#   bash install.sh                          # core pack, for Claude Code and Codex
#   bash install.sh --extra                  # also the optional skills (group "extra")
#   bash install.sh --agents claude-code     # only Claude Code (or: codex)
#   bash install.sh --list                   # show what would be installed, install nothing
#   bash install.sh --latest                 # latest version of each skill, not the pinned commit
#   bash install.sh --no-gate                # skip the gate (local hook that suggests skills)
#   bash install.sh --full-descriptions      # Claude Code: list pack skills with their descriptions
#
# By default, Claude Code lists the pack's skills by name only (skillOverrides "name-only" in
# ~/.claude/settings.json) and the routing rules say when to use each one. That keeps the fixed
# cost per message low. It also sets DISABLE_TELEMETRY=1 for the "skills" CLI.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="claude-code,codex"
EXTRA=0
LIST=0
LATEST=0
GATE=1
NAME_ONLY=1

while [ $# -gt 0 ]; do
  case "$1" in
    --extra) EXTRA=1; shift ;;
    --agents|--agentes) AGENTS="$2"; shift 2 ;;
    --list|--lista) LIST=1; shift ;;
    --latest|--ultimas) LATEST=1; shift ;;
    --no-gate|--sin-gate) GATE=0; shift ;;
    --full-descriptions) NAME_ONLY=0; shift ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# One line "repo|sha skill1 skill2 ..." per repository and commit. Works with macOS bash 3.2.
PLAN="$(awk -F'\t' -v extra="$EXTRA" '
  /^#/ || NF < 3 { next }
  $1 == "extra" && extra != 1 { next }
  { k = $2 "|" $5; if (!(k in s)) order[++n] = k; s[k] = s[k] " " $3 }
  END { for (i = 1; i <= n; i++) print order[i] s[order[i]] }
' "$DIR/manifest/skills.tsv")"

OWN="$(cd "$DIR/skills" && ls -d */ | tr -d '/' | tr '\n' ' ')"
PUBLIC="$(echo "$PLAN" | awk '{ for (i = 2; i <= NF; i++) printf "%s ", $i }')"
ALL_PUBLIC="$(awk -F'\t' '!/^#/ && NF >= 3 { printf "%s ", $3 }' "$DIR/manifest/skills.tsv")"

if [ "$LIST" = 1 ]; then
  echo "Own: $OWN"
  echo "$PLAN" | sed 's/|\([0-9a-f]\{7\}\)[0-9a-f]*/ @ \1/'
  echo "Public skills: $(echo "$PUBLIC" | wc -w | tr -d ' ')"
  exit 0
fi

command -v npx >/dev/null || { echo "Node.js (npx) is missing. Install Node.js 22 or newer and run this script again."; exit 1; }
if [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 22 ]; then
  echo "Node.js 22 or newer is needed (you have $(node -v)). Update it and run this script again."; exit 1
fi
IFS=',' read -r -a AGENT_LIST <<< "$AGENTS"

# 1. Own skills.
for agent in "${AGENT_LIST[@]}"; do
  case "$agent" in
    claude-code) dest="$HOME/.claude/skills" ;;
    codex) dest="${CODEX_HOME:-$HOME/.codex}/skills" ;;
    *) echo "Own skills are copied only for claude-code and codex; skipping $agent."; continue ;;
  esac
  mkdir -p "$dest"
  for s in $OWN; do
    rm -rf "${dest:?}/$s"
    cp -R "$DIR/skills/$s" "$dest/$s"
  done
  echo "✓ Own skills ($OWN) in $dest"
done

# 2. Routing rules in the global instructions (marked block, replaced on reinstall).
START="<!-- agent-basic-skillset:start -->"
END="<!-- agent-basic-skillset:end -->"
for agent in "${AGENT_LIST[@]}"; do
  case "$agent" in
    claude-code) file="$HOME/.claude/CLAUDE.md" ;;
    codex) file="${CODEX_HOME:-$HOME/.codex}/AGENTS.md" ;;
    *) continue ;;
  esac
  mkdir -p "$(dirname "$file")"
  touch "$file"
  tmp="$(mktemp)"
  # Drop the previous block (and the line older versions added) without touching the rest.
  awk -v i="$START" -v f="$END" '
    $0 == i { skip = 1; next }
    $0 == f { skip = 0; next }
    skip == 1 || index($0, "first use the agent-basic-skillset skill") > 0 { next }
    $0 == "" { blank++; next }
    { while (blank > 0) { print ""; blank-- } print }
  ' "$file" > "$tmp"
  {
    cat "$tmp"; printf '\n%s\n' "$START"; cat "$DIR/routing/rules.md"
    if [ "$EXTRA" = 1 ]; then cat "$DIR/routing/rules-extra.md"; fi
    printf '%s\n' "$END"
  } > "$file"
  rm -f "$tmp"
  echo "✓ Routing rules in $file"
done

# 3. Claude Code only: the gate (local hook, no model call) and name-only listing.
for agent in "${AGENT_LIST[@]}"; do
  [ "$agent" = "claude-code" ] || continue
  SETTINGS="$HOME/.claude/settings.json"
  GDIR="$HOME/.claude/agent-basic-skillset"
  if [ "$GATE" = 1 ]; then
    mkdir -p "$GDIR"
    cp "$DIR/hooks/skill-gate.mjs" "$DIR/hooks/triggers.json" "$GDIR/"
    if node "$DIR/hooks/settings.mjs" add-gate "$SETTINGS" "node \"$GDIR/skill-gate.mjs\""; then
      echo "✓ Gate installed in $SETTINGS"
    else
      echo "⚠ Gate not installed: fix $SETTINGS and run the installer again. Everything else continues."
    fi
  else
    if [ -f "$SETTINGS" ]; then node "$DIR/hooks/settings.mjs" remove-gate "$SETTINGS" || true; fi
    rm -rf "$GDIR"
  fi
  # shellcheck disable=SC2086
  if [ "$NAME_ONLY" = 1 ]; then
    node "$DIR/hooks/settings.mjs" name-only "$SETTINGS" $OWN $PUBLIC \
      && echo "✓ Pack skills listed by name only in $SETTINGS" \
      || echo "⚠ Could not set name-only listing: fix $SETTINGS. Skills will show full descriptions."
  elif [ -f "$SETTINGS" ]; then
    node "$DIR/hooks/settings.mjs" clear-name-only "$SETTINGS" $OWN $ALL_PUBLIC || true
  fi
done

# 4. Public skills.
AGENT_FLAGS=()
for agent in "${AGENT_LIST[@]}"; do AGENT_FLAGS+=(-a "$agent"); done

# Pinned commits are fetched with git and handed to the CLI as a local folder: the CLI's own
# clone-by-SHA is not reliable on every machine.
SRC="$(mktemp -d)"
trap 'rm -rf "$SRC"' EXIT
fetch_pinned() {
  local dest="$SRC/$(echo "$1-$2" | tr '/' '_')"
  rm -rf "$dest" && mkdir -p "$dest" &&
    git -C "$dest" init -q &&
    git -C "$dest" remote add origin "https://github.com/$1.git" &&
    git -C "$dest" fetch -q --depth 1 origin "$2" &&
    git -C "$dest" -c advice.detachedHead=false checkout -q FETCH_HEAD &&
    echo "$dest"
}

FAILED=""
export DISABLE_TELEMETRY="${DISABLE_TELEMETRY:-1}"
while read -r key skills; do
  repo="${key%%|*}"; sha="${key#*|}"
  SKILL_FLAGS=()
  for s in $skills; do SKILL_FLAGS+=(--skill "$s"); done
  echo "→ $repo${sha:+ @ ${sha:0:7}}: $skills"
  if [ "$LATEST" = 1 ] || [ -z "$sha" ]; then
    source="$repo"
  elif ! source="$(fetch_pinned "$repo" "$sha")"; then
    echo "✗ Could not fetch $repo at $sha"
    FAILED="$FAILED $repo"
    continue
  fi
  if ! npx -y skills@1.7.4 add "$source" "${SKILL_FLAGS[@]}" "${AGENT_FLAGS[@]}" -g -y < /dev/null; then
    FAILED="$FAILED $repo"
  fi
done <<< "$PLAN"

echo
if [ -z "$FAILED" ]; then
  echo "Done. Restart Claude Code or Codex so they load the skills and the rules."
else
  echo "Finished with errors in:$FAILED"
  echo "Run bash install.sh again to retry."
  exit 1
fi
