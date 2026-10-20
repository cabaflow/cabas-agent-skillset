"""Routing test for Codex. Same output format as run.py, so score.py works on it.

A skill counts as loaded when Codex reads its SKILL.md. Codex needs a shell command to read a
file, so the suffix allows only that. Uses your Codex usage: one `codex exec` per case.
Usage: python3 run_codex.py <condition> <out.json>   (conditions from setup_codex.sh)
"""
import json, subprocess, sys, os, re, time, concurrent.futures as cf
E = os.path.dirname(os.path.abspath(__file__))
WORK = os.environ.get("ABS_TEST_DIR", "/tmp/abs-routing-test")
COND, OUT = sys.argv[1], sys.argv[2]
WORKERS = int(os.environ.get("ABS_WORKERS", "4"))
SUFFIX = (" (Test: do not edit files or open websites. The only commands allowed are reading the"
          " SKILL.md of the skills you would use. Then answer in one line what you would do.)")
cases = json.load(open(os.path.join(E, os.environ.get("ABS_CASES", "cases.json"))))
SKILL_MD = re.compile(r"/([^/\s'\"]+)/SKILL\.md")

def once(c):
    home = os.path.join(WORK, COND, "home")
    env = {**os.environ, "HOME": home, "CODEX_HOME": os.path.join(home, ".codex")}
    cmd = ["codex", "exec", "--json", "--ephemeral", "--skip-git-repo-check", "-s", "read-only",
           "-C", os.path.join(WORK, "codex-project"), c["q"] + SUFFIX]
    p = subprocess.run(cmd, env=env, capture_output=True, text=True, timeout=600, stdin=subprocess.DEVNULL)
    loaded, tokens, text = [], None, ""
    for line in p.stdout.splitlines():
        try: e = json.loads(line)
        except Exception: continue
        item = e.get("item") or {}
        if e.get("type") == "item.completed" and item.get("type") == "command_execution":
            loaded += SKILL_MD.findall(item.get("command", ""))
        if e.get("type") == "item.completed" and item.get("type") == "agent_message":
            text = item.get("text") or ""
        if e.get("type") == "turn.completed":
            u = e.get("usage") or {}
            tokens = (u.get("input_tokens", 0), u.get("output_tokens", 0))
    return {"id": c["id"], "loaded": loaded, "tokens": tokens, "text": text or p.stderr[-300:]}

def run(c):
    for a in range(3):
        r = once(c)
        if r["tokens"] and r["tokens"][0] > 0: return r
        if "limit" in (r.get("text") or "").lower():
            sys.exit("Codex usage limit reached: " + r["text"])
        time.sleep(15 * (a + 1))
    return r

with cf.ThreadPoolExecutor(WORKERS) as ex: res = list(ex.map(run, cases))
json.dump(res, open(os.path.join(WORK, OUT), "w"), ensure_ascii=False, indent=1)
print("done", COND, sum(1 for r in res if r["tokens"] and r["tokens"][0] > 0), "/", len(res), "answered")
