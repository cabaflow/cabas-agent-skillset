# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Repository layout: `manifest/`, `routing/`, `hooks/`, `skills/`, `scripts/`, `tests/`, `docs/`, CI.
- Name-only listing in Claude Code: the installer sets the pack's skills to `"name-only"` in `skillOverrides`, so each one costs ~8 tokens per message instead of its full description. `--full-descriptions` turns it off. Measured fixed cost: +3.2% per message (was ~+19%).
- `routing/rules-extra.md`, added to the rules only with `--extra`.
- `scripts/check-updates.py` and the monthly `update-pins.yml` workflow: compare each skill's folder between its pin and upstream HEAD and open one PR with only the changed skills.
- `manifest/retired.txt` and `uninstall.sh --retired`.
- Codex: the pack's skills are disabled in the skill list through a marked block in `~/.codex/config.toml` (`hooks/codex-config.mjs`), and the rules tell Codex where to read them. Measured: +2.9% context per message (was +16.2%), routing 62/69 either way.
- Codex routing test: `tests/routing/setup_codex.sh` and `run_codex.py`.
- English docs: README, catalog, prompt templates, routing test README. Spanish versions kept as `.es.md`.

### Changed
- The installer fetches each pinned commit with git and passes the folder to the `skills` CLI, now pinned to 1.7.4. The CLI's own clone-by-SHA failed on GitHub Actions runners.
- Node.js 22 or newer is required (the `skills` CLI uses `fs/promises` `glob`); the installer checks it. CI uses Node 22.
- Core pack cut from 42 to 16 public skills (plus 2 own). 9 moved to the optional `extra` group (13 optional in total), 17 removed (see `docs/catalog.md`).
- Script options and messages in English (`--list`, `--agents`, `--latest`, `--no-gate`); the old Spanish options still work.
- Test cases updated for the new core; `ABS_CASES` selects the case file; cases that need an optional skill carry a `core` expectation.

### Removed
- `brainstorming` and `systematic-debugging` (the `method` group): current models plan and debug well without a process skill. They moved to `manifest/retired.txt`, and their gate patterns, routing rules and catalog sections went away. Test cases that required them were dropped or adjusted, so the measured scores now run over 51 + 18 requests.

### Migrated
- From the prototype `Agent-Basic-Skillset` (v0): pinned public skills, 2 own skills (`ui-convergence`, `honest-delivery`), routing rules for CLAUDE.md/AGENTS.md, the local skill gate hook, install/uninstall scripts and the routing test suite.
