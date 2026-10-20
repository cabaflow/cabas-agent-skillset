#!/usr/bin/env node
// Caba's Agent Skillset skill gate (UserPromptSubmit hook).
// Matches the prompt locally against triggers.json, with no model call. When a rule matches,
// it adds one short line telling the agent which installed skills to load. Otherwise it
// prints nothing, so unmatched prompts cost zero tokens.
import { readFileSync, existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { homedir } from "node:os";

const here = dirname(fileURLToPath(import.meta.url));
const MAX = 3;

function normalize(text) {
  return text.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
}

function matches(list, text) {
  return (list || []).some((p) => new RegExp(p, "i").test(text));
}

function installed(skill) {
  const dirs = [
    join(process.cwd(), ".claude", "skills"),
    join(homedir(), ".claude", "skills"),
    join(homedir(), ".agents", "skills"),
  ];
  return dirs.some((d) => existsSync(join(d, skill, "SKILL.md")));
}

export function route(prompt, config, isInstalled = installed) {
  const text = normalize(prompt);
  const skills = [];
  for (const rule of config.rules) {
    if (!matches(rule.any, text) || matches(rule.not, text)) continue;
    if (rule.needs && !matches(rule.needs, text)) continue;
    for (const s of rule.skills) {
      if (skills.length < MAX && !skills.includes(s) && isInstalled(s)) skills.push(s);
    }
    if (rule.stop || skills.length >= MAX) break;
  }
  const slash = (config.slash || []).filter((r) => matches(r.any, text)).map((r) => r.command);
  return { skills, slash };
}

function message({ skills, slash }) {
  const parts = [];
  if (skills.length) parts.push(`Skill gate: load ${skills.join(", ")} with the Skill tool before answering; skip any that does not fit.`);
  if (slash.length) parts.push(`Tell the user this starts only by command: ${slash.join(", ")}.`);
  return parts.join(" ");
}

if (import.meta.url === `file://${process.argv[1]}`) {
  try {
    const input = JSON.parse(readFileSync(0, "utf8") || "{}");
    const config = JSON.parse(readFileSync(join(here, "triggers.json"), "utf8"));
    const text = message(route(input.prompt || "", config));
    if (text) {
      process.stdout.write(JSON.stringify({
        hookSpecificOutput: { hookEventName: "UserPromptSubmit", additionalContext: text },
      }));
    }
  } catch {
    // Never block the user's prompt because of the gate.
  }
  process.exit(0);
}
