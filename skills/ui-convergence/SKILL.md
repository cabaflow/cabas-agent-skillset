---
name: ui-convergence
description: Use when iterating on a UI, landing or animation with the user's visual feedback - choosing between variants, refining an approved base, or adapting a reference - so approved parts are kept and the work converges instead of reopening decisions.
---

# UI convergence

## Track decisions

Keep a short list and update it after every round of feedback:

- **Keep:** approved pieces, and where each was approved
- **Fix:** open feedback
- **Pending:** waiting on the user
- **Out of scope:** explicitly excluded

An approval covers only what it names. "I like this bar" protects that bar, not the page. A technical go-ahead ("approved, implement it") is not a visual approval. Praise of one piece does not cancel a correction to it.

## Three phases

1. **Explore** (direction open): offer options that differ in composition, navigation or interaction, not in color alone. Same tasks and data in each, so they can be compared.
2. **Refine** (a base is chosen): keep the base and change one dimension at a time.
3. **Converge** (decisions made): deliver one coherent version. Do not generate new variants or reopen choices unless the user asks or a concrete problem forces it.

Picking parts from several options is normal ("hero from A, navigation from C"). Build that combination; do not insist one option wins everywhere.

## Turn feedback into checks

Translate every comment into something observable: "two lines of text must not change the card height", "the bar must stay visible while scrolling". When a request has an ambiguous magnitude ("slower", "bigger"), state what will change (duration, distance or speed relative to the gesture) before applying a number.

## Using references

Name the part and why it is liked: **element → property → behavior → adaptation**. For example, "the top bar: height, blur on scroll, how it appears; adapted to our nav". A brand name alone is not a spec. Compare motion over time (enter, transition, exit, reverse scroll), not just the final frame.
