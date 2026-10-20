# Routing test

Checks that the routing rules make Claude Code load the right skills. Two case files:

- `cases.json`: 57 requests (42 used while writing the rules, 15 that were new when added, ids 101–115).
- `cases_holdout2.json`: 20 requests written after the rules, to check they generalize.

```bash
bash tests/routing/setup.sh                       # installs the pack into /tmp/abs-routing-test
python3 tests/routing/run.py rules r1.json        # conditions: rules, gate (rules + gate hook), empty
python3 tests/routing/score.py r1.json
ABS_CASES=cases_holdout2.json python3 tests/routing/run.py rules h2.json
ABS_CASES=cases_holdout2.json python3 tests/routing/score.py h2.json
```

- Every request is a real `claude -p` call. **It uses your Claude usage limit:** a full run is 57 calls. Run in small batches; `run.py` uses 3 workers and stops when it sees the usage-limit message.
- The test uses `--setting-sources project,local`, so it sees only the pack and Claude Code's bundled skills, not your personal ones. `setup.sh` copies the pack's `skillOverrides` (name-only listing) into the project settings so the test matches a real install.
- A request is **exact** when it loads every required skill (`req`, plus one of `anyof` if present) and nothing outside the accepted ones (`ok`). Cases with an empty `req` check that nothing is loaded.
- `ABS_TEST_DIR` changes the work folder; `ABS_CASES` the case file.

## Codex

```bash
bash tests/routing/setup_codex.sh                       # codex-rules/ and codex-empty/, with your Codex login copied in
python3 tests/routing/run_codex.py codex-rules c1.json  # ABS_WORKERS sets parallelism (default 4)
python3 tests/routing/score.py c1.json
```

Every case is a real `codex exec` and uses your Codex usage. Codex needs a shell command to read a file, so the test suffix allows only reading `SKILL.md`; a skill counts as loaded when Codex reads it.
