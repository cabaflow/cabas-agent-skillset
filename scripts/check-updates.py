#!/usr/bin/env python3
"""Check whether any pinned skill changed upstream.

For every row in manifest/skills.tsv it compares the git tree of the skill's folder at the
pinned commit with the same folder at the repository's default-branch HEAD. Commits that
touch other parts of a repository are ignored: only a skill whose own files changed is
reported.

Usage:
  python3 scripts/check-updates.py              # report only
  python3 scripts/check-updates.py --write      # also move changed rows to the new commit
  python3 scripts/check-updates.py --report out.md

Needs git and network access. Exit code is 0 whether or not something changed; it is 1 only
when a repository or skill could not be checked.
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(ROOT, "manifest", "skills.tsv")


def git(*args, cwd=None):
    return subprocess.run(["git", *args], cwd=cwd, check=True, capture_output=True, text=True).stdout.strip()


def fetch(repo, sha, dest):
    """Blobless clone: trees and commits only, file contents on demand."""
    git("clone", "--quiet", "--filter=blob:none", "--no-checkout", f"https://github.com/{repo}.git", dest)
    git("fetch", "--quiet", "origin", sha, cwd=dest)
    return git("rev-parse", "HEAD", cwd=dest)


def skill_dirs(clone, commit, skill):
    """Folders holding the skill at a commit: every <skill>/SKILL.md, else every SKILL.md whose
    frontmatter says `name: <skill>`. Some repos ship one copy per agent (.claude/, .agents/...),
    so all copies are compared."""
    paths = [p for p in git("ls-tree", "-r", "--name-only", commit, cwd=clone).splitlines()
             if p == "SKILL.md" or p.endswith("/SKILL.md")]
    hits = [p for p in paths if p.endswith(f"/{skill}/SKILL.md") or p == f"{skill}/SKILL.md"]
    if not hits:
        for p in paths:
            head = git("show", f"{commit}:{p}", cwd=clone).split("\n---", 1)[0]
            if re.search(rf"^name:\s*['\"]?{re.escape(skill)}['\"]?\s*$", head, re.M):
                hits.append(p)
    return sorted(p[: -len("SKILL.md")].rstrip("/") or "." for p in hits)


def trees(clone, commit, paths):
    return [git("rev-parse", f"{commit}:{'' if p == '.' else p}", cwd=clone) for p in paths]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--write", action="store_true", help="update changed rows in the manifest")
    ap.add_argument("--report", help="write a Markdown report to this file")
    args = ap.parse_args()

    lines = open(MANIFEST, encoding="utf-8").read().splitlines()
    rows = [(i, l.split("\t")) for i, l in enumerate(lines) if l and not l.startswith("#")]
    changed, errors, same = [], [], 0

    with tempfile.TemporaryDirectory() as tmp:
        clones = {}
        for i, cols in rows:
            group, repo, skill, _license, sha = cols[:5]
            key = (repo, sha)
            if key not in clones:
                dest = os.path.join(tmp, f"{repo.replace('/', '__')}-{sha[:7]}")
                try:
                    clones[key] = (dest, fetch(repo, sha, dest))
                except subprocess.CalledProcessError as e:
                    clones[key] = None
                    errors.append(f"{repo}: could not fetch ({e.stderr.strip().splitlines()[-1:]})")
            if clones[key] is None:
                continue
            clone, head = clones[key]
            old = skill_dirs(clone, sha, skill)
            if not old:
                errors.append(f"{repo} {skill}: not found at pinned commit {sha[:7]}")
                continue
            new = skill_dirs(clone, head, skill)
            if not new:
                errors.append(f"{repo} {skill}: removed or moved upstream (HEAD {head[:7]})")
                continue
            if old == new and trees(clone, sha, old) == trees(clone, head, new):
                same += 1
                continue
            files = git("diff", "--stat=100", sha, head, "--", *sorted(set(old + new)), cwd=clone)
            changed.append((repo, skill, sha, head, files))
            if args.write:
                cols[4] = head
                lines[i] = "\t".join(cols)

    if args.write and changed:
        with open(MANIFEST, "w", encoding="utf-8") as f:
            f.write("\n".join(lines) + "\n")

    out = [f"Checked {len(rows)} skills: {same} unchanged, {len(changed)} changed, {len(errors)} errors.", ""]
    for repo, skill, sha, head, files in changed:
        out += [f"### {skill} ({repo})",
                f"https://github.com/{repo}/compare/{sha[:12]}...{head[:12]}", "", "```", files, "```", ""]
    if errors:
        out += ["### Could not check", ""] + [f"- {e}" for e in errors]
    text = "\n".join(out)
    print(text)
    if args.report:
        open(args.report, "w", encoding="utf-8").write(text + "\n")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
