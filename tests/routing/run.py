import json, subprocess, sys, os, time, concurrent.futures as cf
E = os.path.dirname(os.path.abspath(__file__))
WORK = os.environ.get("ABS_TEST_DIR", "/tmp/abs-routing-test")
COND, OUT = sys.argv[1], sys.argv[2]
SUFFIX = " (Test: do not edit files, run commands or open websites. Load the skills you would use, then answer in one line what you would do.)"
cases = json.load(open(os.path.join(E, os.environ.get("ABS_CASES", "cases.json"))))
def norm(n): return n.split(":")[-1]
def once(c):
    cmd = ["claude", "-p", c["q"] + SUFFIX, "--allowedTools", "Skill", "--max-turns", "8",
           "--setting-sources", "project,local", "--output-format", "stream-json", "--verbose"]
    p = subprocess.run(cmd, cwd=os.path.join(WORK, COND), capture_output=True, text=True, timeout=400)
    loaded, tokens, text = [], None, ""
    for line in p.stdout.splitlines():
        try: e = json.loads(line)
        except Exception: continue
        if e.get("type") == "assistant":
            for b in e["message"].get("content", []):
                if b.get("type") == "tool_use" and b.get("name") == "Skill":
                    loaded.append(norm(b["input"].get("skill", "")))
        if e.get("type") == "result":
            u = e.get("usage") or {}
            tokens = (u.get("input_tokens", 0) + u.get("cache_read_input_tokens", 0) + u.get("cache_creation_input_tokens", 0), u.get("output_tokens", 0))
            text = e.get("result") or ""
    return {"id": c["id"], "loaded": loaded, "tokens": tokens, "text": text}
LIMIT = "limit"
def run(c):
    for a in range(3):
        r = once(c)
        if r["tokens"] and r["tokens"][0] > 0: return r
        if LIMIT in (r.get("text") or "").lower():
            sys.exit("Claude usage limit reached: " + r["text"])
        time.sleep(15 * (a + 1))
    return r
with cf.ThreadPoolExecutor(3) as ex: res = list(ex.map(run, cases))
json.dump(res, open(os.path.join(WORK, OUT), "w"), ensure_ascii=False, indent=1)
print("done", COND, sum(1 for r in res if r["tokens"] and r["tokens"][0] > 0), "/", len(res), "answered")
