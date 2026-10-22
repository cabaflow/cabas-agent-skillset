# Skill catalog

This file is for people; the agent does not read it. Every public skill comes from its author's repository, pinned in [`manifest/skills.tsv`](../manifest/skills.tsv). You never need to name a skill: describe the task and the routing rules pick it. "Ask like this" shows a request that triggers it.

Body sizes are approximate tokens loaded only when the skill is used. In Claude Code the pack lists each skill by name only, so an unused skill costs about 8 tokens per message.

## Core (installed by default)

### Own skills

| Skill | What it does | When it loads | Body |
|---|---|---|---:|
| `ui-convergence` | Keeps a keep / fix / pending / out-of-scope list and turns visual feedback into checks: explore → refine → converge | Iterating a UI with feedback | ~480 |
| `honest-delivery` | Makes what the UI shows true and checks the real experience before saying "done" | Showing progress, results or demos, or closing a task | ~430 |

### Design and UI

| Skill | What it does | Ask like this | Body |
|---|---|---|---:|
| `impeccable` (pbakaus) | Designs, critiques, polishes and audits interfaces, new pages included | "Polish this screen" / "Make a landing for X" | ~3,100 |
| `apple-design` (Emil Kowalski) | Apple-style motion and interaction: gestures, springs, sheets | "Make this feel like iOS" | ~6,200 |
| `pick-ui-library` (Emil Kowalski) | Picks the right component library | Type `/pick-ui-library` (manual only) | ~1,200 |
| `prototype` (Emil Kowalski) | Several distinct versions of a UI piece with a live switcher | Type `/prototype` (manual only) | ~2,100 |

### Motion (Emil Kowalski)

| Skill | What it does | Ask like this | Body |
|---|---|---|---:|
| `animate` | Builds an animation in the right order: purpose, properties, curve, duration | "Animate this modal opening" | ~3,100 |
| `animation-performance` | Smooth animations without jank | "This animation stutters" | ~3,600 |
| `review-animations` | Critiques existing motion | Type `/review-animations` (manual only) | ~2,300 |

### Visual references and cloning

| Skill | What it does | Ask like this | Body |
|---|---|---|---:|
| `ui-capture` (voidmatcha) | Captures a live reference: screenshots, scroll states, hover, clicks, transition recordings | "Capture how this site's hero behaves" | ~2,100 |
| `ui-reverse-engineering` (voidmatcha) | Recreates a URL or section in React + Tailwind | "Clone this section of linear.app" | ~4,000 |
| `extract-design-system` (arvindrk) | Pulls colors, fonts and spacing from a site | "Get the design system of this site" | ~530 |

### Code and data

| Skill | What it does | Ask like this | Body |
|---|---|---|---:|
| `vercel-react-best-practices` | React and Next.js performance rules | "Why does this page re-render so much?" | ~1,900 |
| `vercel-composition-patterns` | React component composition | "This component has too many props" | ~700 |
| `supabase` | Supabase auth, database, storage | "Connect this to Supabase" | ~3,700 |
| `supabase-postgres-best-practices` | Schemas, indexes, RLS, migrations | "Design the schema and RLS policies" | ~500 |

### Testing and review

| Skill | What it does | Ask like this | Body |
|---|---|---|---:|
| `playwright-cli` (Microsoft) | Drives a browser from the terminal | "Open the app and test checkout" | ~4,200 |
| `differential-review` (Trail of Bits) | Security review focused on a diff | "Review this PR for security issues" | ~1,900 |

For a plain PR review, Claude Code's built-in `/code-review` is used instead of a pack skill.

## Optional (`bash install.sh --extra`)

Never or almost never needed in the routing tests, heavy, or niche. Installing them also adds their routing line.

| Skill | What it does | Why optional |
|---|---|---|
| `emil-design-eng` (Emil Kowalski) | Component polish philosophy and invisible details | ~7,500-token body; overlaps `impeccable` |
| `break-ui` (Emil Kowalski) | Stress-tests UI with worst-case data | Niche |
| `find-animation-opportunities` (Emil Kowalski) | Finds where motion is missing | Niche; read-only advice |
| `improve-animations` (Emil Kowalski) | Codebase-wide motion audit and plan | Niche |
| `animation-vocabulary` (Emil Kowalski) | Names a vaguely described effect | Rarely asked; ~3,500-token body |
| `motion` (Motion) | Correct Motion / Framer Motion usage | Only for projects using Motion |
| `audit-context-building` (Trail of Bits) | Builds codebase context before an audit | Security specialists |
| `variant-analysis` (Trail of Bits) | Finds variants of a known vulnerability | Security specialists |
| `property-based-testing` (Trail of Bits) | Property-based tests for edge-heavy logic | Niche |
| `true-web-clone` | Faithful site cloning | Overlaps `ui-reverse-engineering` |
| `design-taste-frontend` (Leonxlnx) | Frontend taste rules | ~7,000-token body; overlaps `impeccable` |
| `extract-design` (dembrandt) | W3C design tokens with the Dembrandt CLI | Needs the `dembrandt` CLI |
| `reverse-engineer-anything` (REA) | Reverse engineering of binaries, Electron apps, firmware | For compiled software, ~6,000-token body |

## Removed in this version

Listed in [`manifest/retired.txt`](../manifest/retired.txt). `bash uninstall.sh --retired` removes them from an older install.

| Skill | Why |
|---|---|
| `writing-plans`, `subagent-driven-development`, `dispatching-parallel-agents`, `using-git-worktrees`, `finishing-a-development-branch` | Claude Code already plans, uses subagents and worktrees on its own |
| `test-driven-development`, `receiving-code-review`, `verification-before-completion` | Current models do this well without help; `honest-delivery` covers the final check |
| `brainstorming`, `systematic-debugging` | Current models plan and debug well without a process skill; `honest-delivery` covers the final check |
| `requesting-code-review` | Built-in `/code-review` |
| `frontend-design` | Overlaps `impeccable` |
| `agent-browser` | Duplicate of `playwright-cli` |
| `skill-creator` | Available as the official `skill-creator` plugin |
| `find-skills` | Plugin and skill search are built in |
| `web-design-guidelines` | Overlaps `impeccable` |
| `motion-design` | Overlaps `animate` |
