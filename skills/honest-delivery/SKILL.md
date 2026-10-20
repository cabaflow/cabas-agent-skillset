---
name: honest-delivery
description: Use when product or UI work shows progress, results, metrics or a demo, or before reporting such work as done - ensures what the user sees matches what really happens and that the experience was checked, not just the build. Complements verification-before-completion.
---

# Honest delivery

## What the UI shows must be true

- Progress, coverage, results and errors reflect the real state. No progress bar that moves on a timer, no "done" for partial work.
- Sample or mock data is labeled as such. A demo must match the real app.
- Do not claim savings, completeness, optimality or speed-ups without the data and the comparison behind them. Show unknown values as unknown, not as zero.

## Check the experience, not only the code

A build proves it compiles, a test proves its case, a push proves it uploaded. None proves the experience works. Pick the checks that match the work:

| Work | Check before closing |
|---|---|
| UI or motion change | The real screen in a browser or app: enter, transition, exit, reverse scroll, small and large sizes. A screenshot does not prove an animation. |
| Bug | Reproduced before, confirmed fixed after |
| Integration | The integrated version itself, with mocks kept separate from real runs |
| Packaged app | The current package installs and opens, with its assets and animations. Watch for an old version still running. |

If you cannot see or run the result in this environment, say so instead of describing an inspection you did not do.

## Closing message

Say what changed, what was checked, how to open it and what is still pending:

> Integrated X and Y. Checked A and B in the running app. C is pending because D is missing. Open it at E.

Separate implemented, tested, integrated, published and approved by the user. Never report that the user is satisfied on their behalf.
