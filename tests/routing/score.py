import json, sys, os
E = os.path.dirname(os.path.abspath(__file__))
WORK = os.environ.get("ABS_TEST_DIR", "/tmp/abs-routing-test")
cases = {c["id"]: c for c in json.load(open(os.path.join(E, os.environ.get("ABS_CASES", "cases.json"))))}
# Cases that need an optional skill carry a "core" expectation for runs without --extra.
if os.environ.get("ABS_EXTRA") != "1":
    for c in cases.values():
        c.update(c.pop("core", {}))
for path in sys.argv[1:]:
    res = json.load(open(os.path.join(WORK, path)))
    exact = 0; extras_t = miss_t = loads = 0; tok = []; bad = []
    for r in sorted(res, key=lambda r: r["id"]):
        c = cases[r["id"]]; got = list(dict.fromkeys(r["loaded"]))
        req = set(c["req"]); ok = req | set(c["ok"]) | set(c.get("anyof", []))
        miss = req - set(got)
        if c.get("anyof") and not set(c["anyof"]) & set(got): miss |= {"(" + "|".join(c["anyof"]) + ")"}
        if c.get("says") and c["says"] not in (r.get("text") or ""): miss |= {"says " + c["says"]}
        extra = [s for s in got if s not in ok]
        if not miss and not extra: exact += 1
        else: bad.append(f"  {r['id']:2d} loaded={got}" + (f" missing={sorted(miss)}" if miss else "") + (f" extra={extra}" if extra else ""))
        extras_t += len(extra); miss_t += len(miss); loads += len(got)
        if r["tokens"]: tok.append(r["tokens"][0])
    n = len(res)
    print(f"== {path}: exact {exact}/{n} | missing {miss_t} | extra {extras_t} | skills/prompt {loads/n:.2f} | tokens {sum(tok)/max(1,len(tok)):.0f}")
    print("\n".join(bad))
