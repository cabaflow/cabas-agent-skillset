#!/usr/bin/env node
// Keeps the pack's skills out of Codex's skill list, so their descriptions don't cost context
// on every message. The routing rules in AGENTS.md say where to read each skill instead.
// Writes a marked block of [[skills.config]] entries (enabled = false) at the end of config.toml
// and touches nothing else.
// Usage:
//   node codex-config.mjs add <config.toml> <SKILL.md path>...
//   node codex-config.mjs remove <config.toml>
import { readFileSync, writeFileSync, existsSync, copyFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";

const [, , action, file, ...paths] = process.argv;
const START = "# >>> agent-basic-skillset: pack skills hidden from the skill list (managed) >>>";
const END = "# <<< agent-basic-skillset <<<";

let text = existsSync(file) ? readFileSync(file, "utf8") : "";
if (existsSync(file)) copyFileSync(file, `${file}.bak-agent-basic-skillset`);

const lines = text.split("\n");
const out = [];
let skip = false;
for (const line of lines) {
  if (line === START) { skip = true; continue; }
  if (line === END) { skip = false; continue; }
  if (!skip) out.push(line);
}
text = out.join("\n").replace(/\n+$/, "");

if (action === "add") {
  const block = paths.map((p) => `[[skills.config]]\npath = ${JSON.stringify(p)}\nenabled = false\n`).join("\n");
  text = `${text ? text + "\n\n" : ""}${START}\n${block}${END}`;
} else if (action !== "remove") {
  console.error(`Unknown action: ${action}`);
  process.exit(2);
}

mkdirSync(dirname(file), { recursive: true });
writeFileSync(file, text ? text + "\n" : "");
