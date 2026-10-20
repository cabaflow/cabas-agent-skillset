# Prompt templates

Templates for the most common requests. Replace the fields in braces and use only the block you need. You don't have to paste them whole: they also work as a checklist of what is worth saying. Spanish version: [prompt-templates.es.md](prompt-templates.es.md).

## 1. Compact product brief

```text
I want to solve {problem} for {user}, in {screen/flow}.
The result must let them {concrete action} and will be reviewed in {app/browser/package}.

Read {sources and context} first. Keep {approved decisions}.
What fails today is {observable behavior}. The scope is {included};
{excluded} is out of scope.

Turn it into a usable result with clear code. Before asking me again,
look for the answers in what was delivered. Go ahead with the reversible
decisions you are allowed to make and state any relevant assumption.

Check {main path and critical cases}. Close by saying what changed,
what you verified, how to open it and what is still pending.
```

**Acceptance:** the flow answers the problem and the delivery can be checked where stated. **Avoid:** "make it premium / Apple-level" as the only requirement.

## 2. Explore visual directions

```text
I have not chosen a direction for {surface} yet.
Design {agreed number} working options that solve the same tasks with
the same data.

Vary composition, hierarchy and interaction, not just colors. For each one,
say briefly which usage decision it improves and what it gives up.
Use {references}, naming the concrete elements you adapt.

Keep {approved base, if any}. Let me compare the real flow, motion and
states included. Recommend one option with evidence, without claiming a
preference I have not stated.
```

**Acceptance:** observable, comparable differences; complete alternatives at the agreed level. **Avoid:** cosmetic galleries, choosing for the user, or installing many libraries to show variety.

## 3. Refine after choosing

```text
Keep {approved elements} from {identified version}.
Fix {list of notes}. From {other version}, adapt only {chosen property
or behavior}.

Build a single coherent candidate. Do not reopen closed decisions without
a concrete reason. Turn each note into a check and keep a short list:
keep, fix, pending and out of scope.

Show me the result in {surface} and separate what was tested from what
still needs my visual judgment.
```

**Acceptance:** the base is preserved and every fix is verifiable. **Avoid:** reading "I like the bar" as approval of the whole page, or keeping six versions after being asked to converge.

## 4. Extract and adapt a reference

```text
From {reference} I care about {element}, because of {concrete property}.
Analyze its structure, typography, proportions, states and behavior.
Separate what you observed from what you infer and what you need to measure.

Adapt it to {brand/product}; keep our task, content and real data.
Do not pile up every idea from the reference.

Compare reference and candidate under equal conditions: scale, viewport
and flow. Explain what is kept, what changes and why.
```

**Acceptance:** a recognizable adaptation of observed properties, with no invented measurements or product promises. **Avoid:** copying a whole brand out of enthusiasm for one component, or claiming fidelity without inspection.

## 5. Motion that explains and can be appreciated

```text
In {scene}, the user must understand {idea/function}.
Today {jump, disappearance, speed, lack of coordination} happens.
Keep {approved effect} and fix {unwanted effect}.

Describe the enter, transition and exit phases, and how they respond to
scroll/hover. If I suggest a speed percentage, first define whether it
affects duration, distance or the relation to the gesture.

Implement it and play the scene at normal, slow, fast and reverse speed
when relevant. Check legibility, sharpness, continuity and reduced motion.
A static screenshot is not enough to close this change.
```

**Acceptance:** the story is understood and enjoyable without jumps or loss of legibility. **Avoid:** animating everything, applying "30%" without defining the quantity, or inventing a visual check.

## 6. Dashboard tied to decisions

```text
The screen is {operational home / planning / results review}.
Its user comes back to decide {decisions}, using {available data}.

Propose a hierarchy that shows status, problem and next action.
Do not duplicate another flow. Use verifiable data; flag fixtures,
assumptions and metrics that cannot be computed yet.

If you compare alternatives, define the baseline and use equal conditions.
Do not show savings, feasibility or optimality without support.
Keep logs and internals reachable only when they help.

Check empty, partial, failed and valid states with the current contract.
```

**Acceptance:** it is clear what to do and why, with honest metrics. **Avoid:** decorative KPIs, mixing up the home with another screen, invented savings, or logs as the main content.

## 7. Progress and first usefulness

```text
I want to shorten the wait before {product} becomes useful.
Rebuild the real flow and its sources of truth: what is downloaded,
prepared, processed and actually ready.

Find waits, duplication and confusing states. Assess what work can keep
running in the background without losing data or pretending it finished.
Measure {expected benefit} before deciding on big changes.

Make progress explain what is happening, and make pause, retry and reopen
consistent. Test the relevant interruptions.
```

**Acceptance:** useful sooner, truthful progress and tested recovery. **Avoid:** hiding errors behind a spinner or marking something done without evidence.

## 8. Debug without piling up patches

```text
The observable failure is {symptom}; it happens in {steps/version/environment}.
Reproduce it and separate symptom, cause and scope.

Review existing decisions and tests before adding layers. Apply the simplest
fix that solves the cause within the task. Add or run checks that can catch
a real regression.

If independent problems show up, split them and explain how they relate.
Do not grow the product to avoid understanding this failure. Deliver
before/after evidence and what could not be reproduced yet.
```

**Acceptance:** a supported cause and, when feasible, a case that fails before and passes after. **Avoid:** blindly raising limits, hiding messages, refactoring everything, or adding tests that only copy the implementation.

## 9. Integrate work from several branches

```text
Bring {candidates} onto {current base} within the authorized scope.
Identify what each one adds, what overlaps and which contract must be kept.

Integrate into one identifiable candidate and verify that combined state.
Do not treat an earlier branch's results as automatic proof for the merge.
Connect UI and real engine; separate mocks, synthetic data and real runs.

Check {flow} and leave the delivery ready to open in {surface}.
I do not want scattered working branches with a broken main app.
Publish or push only if this task authorizes it.
```

**Acceptance:** one unified candidate, an identifiable version and a tested combined flow. **Avoid:** reporting each subagent's "done" as the product being finished.

## 10. Coordinate helpers with clear roles

```text
You may use agents for {authorized scope}.
Split only work that gains from independence or useful parallelism.
Define one integration owner, one checkable deliverable per agent and the
file/decision boundaries that avoid conflicts.

Independent review must look for defects and evidence, not confirm the
author out of courtesy. Coordinate authorized handoffs without using me
as the messenger. Keep decisions and open items in a short handoff.

The stopping criterion is {observable result}, not a number of agents,
messages or tokens.
```

**Acceptance:** clear roles and consolidation; findings resolved or stated. **Avoid:** a swarm without an integrator, sessions repeating the same work, or an audit that only rereads the author's summary.

## 11. Memory and research that don't overflow

```text
Research {question} using {available material} first.
Save verified conclusions, uncertainties and decisions that affect the work.
Include sources and an index to recover the details.

The entry point must hold only what is needed to get oriented.
Separate facts, requirements and proposals. Do not turn early hypotheses
into permanent decisions.

Before asking me, check whether the answer is in the data.
If it is not, leave it to confirm and ask the precise question.
```

**Acceptance:** useful, traceable context; details recoverable without loading everything. **Avoid:** an encyclopedic skill, summaries without provenance, or premature conclusions about datasets.

## 12. Close a usable version

```text
I want to close {scope} in {version/environment}.
Review what was asked and what is pending, integrate what works and prepare
the delivery I will use. Check that you are opening the current version.

Validate first use and the relevant flows; if there is a package, check the
assets, animations and configuration inside it. Use tests proportional to
the change and real UI/engine evidence when relevant.

Deliver access to the result, the checks you ran and the limits.
Do not call "published" what is only prepared, or "accepted" what only
passed tests.
{Add specific publishing permissions here, if they are part of the task.}
```

**Acceptance:** an accessible delivery and an honest status; nothing in scope hidden in another branch. **Avoid:** an old app left open, an installer different from the tested one, or closing by test count.

## 13. Visual presentation of a technical idea

```text
The audience must understand {idea}, remember {message} and be able to see
{evidence/demo}. The agreed format is {PPTX/HTML/other}.

Explain the process with a simple composition consistent with {product}.
Use equations, text, diagrams or motion when they help understanding.
Do not overload; more information is not more clarity.

Review the presentation at its real scale and way of use. Check opening,
legibility, flow and narrative. Separate the technical check from pending
visual feedback. Do not change the format without permission.
```

**Acceptance:** it opens, it is understood and it was reviewed in its presentation form. **Avoid:** "37 rendered slides = good design", switching to HTML as a quality guarantee, or using motion to hide a confusing explanation.

## Short handoff that keeps what matters

```text
Goal and current scope:
Version/environment checked:
Keep — approved decisions and where they were approved:
Fix — pending feedback:
Done — changes and evidence:
Not verified / blocked:
Next concrete action:
Sources to recover detail:
Current permissions and limits:
```

The template must not contain credentials or carry old instructions over as new permissions. It does not need whole conversations either.
