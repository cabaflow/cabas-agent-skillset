# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Repository layout: `manifest/`, `routing/`, `hooks/`, `skills/`, `scripts/`, `tests/`, `docs/`, CI.
- Name-only listing in Claude Code: the installer sets the pack's skills to `"name-only"` in `skillOverrides`, so each one costs ~8 tokens per message instead of its full description. `--full-descriptions` turns it off. Measured fixed cost: +3.2% per message (was ~+19%).
- `routing/rules-extra.md`, added to the rules only with `--extra`.
- `scripts/check-updates.py` and the monthly `update-pins.yml` workflow: compare each skill's folder between its pin and upstream HEAD and open one PR with only the changed skills.
- `manifest/retired.txt` and `uninstall.sh --retired`.
- English docs: README, catalog, prompt templates, routing test README. Spanish versions kept as `.es.md`.

### Changed
- The installer fetches each pinned commit with git and passes the folder to the `skills` CLI, now pinned to 1.7.4. The CLI's own clone-by-SHA failed on GitHub Actions runners.
- Core pack cut from 42 to 18 public skills (plus 2 own). 9 moved to the optional `extra` group (13 optional in total), 15 removed (see `docs/catalog.md`).
- Script options and messages in English (`--list`, `--agents`, `--latest`, `--no-gate`); the old Spanish options still work.
- Test cases updated for the new core; `ABS_CASES` selects the case file; cases that need an optional skill carry a `core` expectation.

### Migrated
- From the prototype `Agent-Basic-Skillset` (v0): pinned public skills, 2 own skills (`ui-convergence`, `honest-delivery`), routing rules for CLAUDE.md/AGENTS.md, the local skill gate hook, install/uninstall scripts and the routing test suite.
