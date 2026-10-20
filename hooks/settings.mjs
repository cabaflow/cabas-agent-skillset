#!/usr/bin/env node
// Edits a Claude Code settings.json for Caba's Agent Skillset without touching anything else.
// Usage:
//   node settings.mjs add-gate <settings.json> <gate-command>
//   node settings.mjs remove-gate <settings.json>
//   node settings.mjs name-only <settings.json> <skill>...        list these skills by name only
//   node settings.mjs clear-name-only <settings.json> <skill>...  undo name-only for these skills
// name-only uses the skillOverrides setting: Claude sees the skill's name but not its
// description, so the skill costs a few tokens per message instead of ~100. Entries the user
// already set are left alone, and clear-name-only removes only entries that are "name-only".
import { readFileSync, writeFileSync, existsSync, copyFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";

const [, , action, file, ...rest] = process.argv;
const TAG = "agent-basic-skillset";

let settings = {};
if (existsSync(file)) {
  const raw = readFileSync(file, "utf8").trim();
  if (raw) {
    try {
      settings = JSON.parse(raw);
    } catch {
      console.error(`${file} is not valid JSON; leaving it unchanged.`);
      process.exit(1);
    }
  }
  copyFileSync(file, `${file}.bak-${TAG}`);
}

if (action === "add-gate" || action === "remove-gate") {
  const hooks = (settings.hooks ??= {});
  const groups = (hooks.UserPromptSubmit ?? []).map((g) => ({
    ...g,
    hooks: (g.hooks ?? []).filter((h) => !(h.command ?? "").includes(TAG)),
  })).filter((g) => g.hooks.length);
  if (action === "add-gate") groups.push({ hooks: [{ type: "command", command: rest[0], timeout: 5 }] });
  if (groups.length) hooks.UserPromptSubmit = groups;
  else delete hooks.UserPromptSubmit;
  if (!Object.keys(hooks).length) delete settings.hooks;
} else if (action === "name-only") {
  const o = (settings.skillOverrides ??= {});
  for (const s of rest) if (!(s in o)) o[s] = "name-only";
} else if (action === "clear-name-only") {
  const o = settings.skillOverrides ?? {};
  for (const s of rest) if (o[s] === "name-only") delete o[s];
  if (settings.skillOverrides && !Object.keys(o).length) delete settings.skillOverrides;
} else {
  console.error(`Unknown action: ${action}`);
  process.exit(2);
}

mkdirSync(dirname(file), { recursive: true });
writeFileSync(file, JSON.stringify(settings, null, 2) + "\n");
