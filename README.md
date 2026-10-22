# Caba's Agent Skillset

A small, tested set of public agent skills for building, designing and shipping software with **Claude Code** and **Codex**, plus routing rules that tell the agent which skill to load for each request, and none for trivial ones. Spanish: [README.es.md](README.es.md).

- **Cheap:** the pack adds about **+3%** to the context of every message in both Claude Code and Codex (measured below): skills are kept out of the always-loaded skill list and a short rules table does the routing.
- **Pinned:** every skill is installed at the exact commit it was tested with. A monthly bot proposes updates only for skills whose files changed.
- **Measured:** routing is checked with a repeatable test suite (`tests/`).
- **Reversible:** `uninstall.sh` removes what it added and nothing else.

## Install

You need [Node.js](https://nodejs.org) 22 or newer (for `npx`) and git.

```bash
git clone https://github.com/cabaflow/cabas-agent-skillset.git
cd cabas-agent-skillset
bash install.sh
```

Then restart Claude Code or Codex. The installer:

1. Copies the 2 own skills.
2. Downloads the 16 core public skills from their original repositories, each at its pinned commit.
3. Adds the routing rules ([routing/rules.md](routing/rules.md), ~420 tokens) to `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`, inside a marked block that reinstalling replaces.
4. Claude Code: sets the pack's skills to `"name-only"` in `skillOverrides` in `~/.claude/settings.json`, and installs the **gate**, a local hook that suggests skills without calling the model.
5. Codex: adds a marked block to `~/.codex/config.toml` that disables the pack's skills in the skill list (`[[skills.config]] enabled = false`); the rules in `AGENTS.md` tell Codex where to read each one.

Your other settings, hooks, overrides and config are left alone.

Options:

```bash
bash install.sh --list                 # show what would be installed
bash install.sh --extra                # also the 13 optional skills and their routing line
bash install.sh --agents claude-code   # only Claude Code (or: codex)
bash install.sh --latest               # latest version of each skill instead of the pinned one
bash install.sh --no-gate              # without the gate hook
bash install.sh --full-descriptions    # list the pack's skills normally, with descriptions (costs more)
```

**Update:** `git pull`, then `bash install.sh`. **Uninstall:** `bash uninstall.sh` (add `--retired` to also remove skills that older versions installed).

## What's included

18 core skills; details, body sizes and the optional and removed ones are in [docs/catalog.md](docs/catalog.md).

| Area | Skills |
|---|---|
| Own | `ui-convergence` (iterate a UI with feedback without losing what was approved), `honest-delivery` (what is shown must be true; check the real experience before "done") |
| Design and UI | `impeccable`, `apple-design`, `/prototype`, `/pick-ui-library` |
| Motion | `animate`, `animation-performance`, `/review-animations` |
| References and cloning | `ui-capture`, `ui-reverse-engineering`, `extract-design-system` |
| Code and data | `vercel-react-best-practices`, `vercel-composition-patterns`, `supabase`, `supabase-postgres-best-practices` |
| Testing and review | `playwright-cli`, `differential-review` (security); plain PR reviews use Claude Code's built-in `/code-review` |

Skills with a `/` start only when you type them; their authors chose that. [docs/prompt-templates.md](docs/prompt-templates.md) has 13 request templates for common tasks.

## How it works

You just ask. "I like how stripe.com looks, I want something like it" loads `ui-capture`, `extract-design-system` and `impeccable`; "the modal opens abruptly" loads only `animate`; "rename this variable" loads nothing.

Claude Code normally puts every installed skill's description in context on every message. The pack instead lists its skills by name only (about 8 tokens each, via the documented [`skillOverrides`](https://code.claude.com/docs/en/skills#override-skill-visibility-from-settings) setting) and the rules table in `CLAUDE.md` says when to use each one. Codex has no name-only mode, so there the pack's skills are disabled in the skill list and the rules say where to read them (`~/.agents/skills/<name>/SKILL.md`); Codex reads the file when a rule matches. A skill's full body is read only when it is used. The trade-off: a pack skill that the rules don't mention will rarely trigger on its own, because the model can't see its description.

**The gate** is a `UserPromptSubmit` hook in Node that matches the request against local patterns ([hooks/triggers.json](hooks/triggers.json)) with no model call. On a match it adds one ~20-token line ("Skill gate: load animate…"); otherwise it adds nothing. It is a weak helper (12/18 on its own on the 18 new requests); the rules do most of the work.

## Cost and accuracy (measured 2026-10-19)

Context per message, from `claude -p "hola"` with Claude Code 2.1.287, project-only settings. The absolute base varies a little between runs (26,179–27,953 tokens), so compare rows from the same run.

| Setup | Context per message | vs. empty |
|---|---:|---:|
| Empty | 26,179 | — |
| **Core pack, name-only + rules (default)** | **27,020** | **+3.2%** |
| Core pack, full descriptions + rules | 29,181 | +11.5% |
| Previous version: 44 skills, full descriptions | 32,919 (base 27,953) | +17.8%, ~+19% with rules |

Most of it is read from the prompt cache. When a skill is used, that request costs more: one extra step plus the skill's body (500–6,200 tokens in the core).

Routing in Claude Code with the default install:

| Test | Exact |
|---|---:|
| `cases.json`, 51 requests | **49/51** (47/51 counting 2 cases that need optional skills not in the core) |
| `cases_holdout2.json`, 18 requests written after the rules | **17/18** |

Misses: "copy airbnb's color palette" also loaded `impeccable`; "add an upload progress bar" loaded `impeccable` instead of `honest-delivery`/`animate`. Average 1.05 skills per request, ~52,000 tokens per test request.

Routing and cost in Codex (codex-cli 0.162.1, default model, isolated `CODEX_HOME` with only your login; `tests/routing/run_codex.py`). A skill counts as loaded when Codex reads its `SKILL.md`. Context from `codex exec "hola"`:

| Codex setup | Context per message | vs. empty | `cases.json` (51) | holdout (18) | Tokens per test request |
|---|---:|---:|---:|---:|---:|
| Empty | 14,333 | — | | | |
| Core, skills listed normally + rules | 16,657 | +16.2% | 47/51 | 15/18 | ~33,800 |
| **Core, hidden from the list + rules (default)** | **14,754** | **+2.9%** | **48/51** | **14/18** | **~30,200** |

Both Codex setups get 62/69 in total, so hiding the skills costs no accuracy within this sample's noise and saves ~1,900 tokens on every message. Codex never missed a required skill on the holdout; its errors are extra loads (`impeccable`, `ui-convergence`, Codex's own `code-review`), plus the same progress-bar miss as Claude.

Earlier comparison (22 requests): no routing 17/22, a router skill 18/22 at ~30,000 more tokens per request, rules in `CLAUDE.md` 22/22.

**Limits, honestly:**
- In Codex, `$name` no longer injects a disabled skill, but Codex still reads it through the rules (checked once with `$animate`). Codex is a bit less precise than Claude Code here (14–15/18 vs. 17/18 on new requests), mostly by loading one skill too many.
- The gate together with the model was not re-measured for this version (gate alone: 12/18).
- The test cases were written by the author; the 20 holdout requests are the best signal of how it generalizes, and 20 is a small sample.
- The gain over plain Claude is modest (17/22 → 22/22 in the earlier comparison). This pack is most useful if you don't already know which skills exist.

## Pinned versions and the update bot

[`manifest/skills.tsv`](manifest/skills.tsv) pins each skill to a commit. Once a month, [`update-pins.yml`](.github/workflows/update-pins.yml) runs [`scripts/check-updates.py`](scripts/check-updates.py), which compares each skill's own folder between the pinned commit and upstream HEAD (commits that touch other parts of a repository are ignored), then opens one PR with only the changed skills, diff links, and the cheap checks (syntax, gate test, clean install). The routing test is not run in CI because it needs a Claude account; run it before merging a PR that changes routing-relevant skills. For the bot to open PRs, enable *Settings → Actions → General → Allow GitHub Actions to create and approve pull requests*.

## Licenses and safety

This repository doesn't copy third-party code: the installer downloads each skill from its original repository with the [`skills`](https://github.com/vercel-labs/skills) CLI (telemetry off). Each skill keeps its author's license (MIT, Apache-2.0, CC-BY-SA-4.0 or as stated in its repository). The own skills, rules, scripts and docs are MIT.

Skills run with your agent's permissions. Read a skill before relying on it; see [SECURITY.md](SECURITY.md).
