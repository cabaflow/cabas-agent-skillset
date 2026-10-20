// Unit test of the local skill gate (no model). Usage: node tests/gate/test.mjs [cases.json]
import { readFileSync } from "node:fs";
import { route } from "../../hooks/skill-gate.mjs";
const cfg = JSON.parse(readFileSync(new URL("../../hooks/triggers.json", import.meta.url)));
const file = process.argv[2] || new URL("../routing/cases.json", import.meta.url);
const cases = JSON.parse(readFileSync(file));
let exact = 0; const bad = [];
for (const c of cases) {
  const r = route(c.q, cfg, () => true); const got = r.skills;
  const req = new Set(c.req), ok = new Set([...c.req, ...c.ok, ...(c.anyof || [])]);
  const miss = [...req].filter((s) => !got.includes(s));
  if (c.anyof && !c.anyof.some((s) => got.includes(s))) miss.push("(" + c.anyof.join("|") + ")");
  if (c.says && !r.slash.includes(c.says)) miss.push("says " + c.says);
  const extra = got.filter((s) => !ok.has(s));
  if (!miss.length && !extra.length) exact++;
  else bad.push(`  ${c.id} got=[${got}]` + (miss.length ? ` missing=${miss}` : "") + (extra.length ? ` extra=${extra}` : ""));
}
console.log(`gate (no model): ${exact}/${cases.length}`); if (bad.length) console.log(bad.join("\n"));
process.exit(bad.length ? 1 : 0);
