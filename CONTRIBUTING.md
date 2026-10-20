# Contributing

## Proposing a skill

A skill is added only if all of these hold:

1. **It changes results** on a real task that the base agent does poorly without it.
2. **It is worth its tokens.** In Claude Code its name costs a few tokens per message and it needs a line in `routing/rules.md`; in Codex its full description is loaded in every message. Its body should be small, with large references loaded on demand. New skills go to the `extra` group first.
3. **It does not overlap** with a skill already in the pack.
4. **It has a license** that allows public use, and a public repository.
5. **It passes review:** no `curl | sh`, no hidden instructions, and no network calls in scripts without a clear reason.

Open an issue with the skill, the task it improves and a before/after example.

## Changing routing

Any change to `routing/rules.md` or `hooks/triggers.json` must keep the test suite green:

```bash
node tests/gate/test.mjs                 # local, free
bash tests/routing/setup.sh              # then run tests/routing/run.py (uses your Claude usage)
```

Add the request that motivated the change to `tests/routing/cases.json`.

## Updating pinned versions

Pins live in `manifest/skills.tsv`. The monthly `update-pins` workflow opens a PR when a pinned skill's files change upstream; you can also run `python3 scripts/check-updates.py` locally. Read the diff links and, for skills that appear in the routing rules, re-run the routing tests before merging.
