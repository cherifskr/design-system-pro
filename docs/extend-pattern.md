# Reason a new component before coding it — `/ds extend`

> **Prerequisites** : skill installed, a project with an existing set of components, and a specific need.

## Scenario

Your PM asks : *"We need a way for users to confirm destructive actions — delete, archive, revoke access."*

You could jump into `Dialog.tsx` and start hacking. But that's how you end up with 8 confirmation patterns, none of them quite the same. `/ds extend` forces the **reasoning step** first.

## Step 1 — Run it

Pass the pattern you're thinking about:

```
/ds extend confirmation-dialog
/ds extend "warning before delete"
/ds extend file-picker
```

You can be specific or vague — the skill will ask for clarification if needed.

## Step 2 — Watch it challenge you

Before proposing anything, the skill :

1. **Scans your existing components** — is there already a `Dialog`, `AlertDialog`, `Confirm` that could be extended?
2. **Asks 2-3 framing questions** :
   - What triggers this component?
   - Is it blocking or informational?
   - Does it return a value (binary yes/no, or input)?
   - Mobile + desktop, or one only?
   - Usage frequency (rare, frequent)?

This is **deliberate**. 80% of the time, the conversation surfaces that you don't actually need a new component — you need to extend one that exists.

## Step 3 — Read the 2-3 options

If a new component is justified, the skill produces **2 or 3 alternatives** (never 1, never 5+) :

```
Option A — Extend existing <Dialog> with variant="confirm"
  Pros: reuses focus trap, one component to maintain
  Cons: Dialog API grows, mixes use cases
  Wins when: you want minimal component catalog

Option B — New <ConfirmDialog> built on Radix AlertDialog (RECOMMENDED)
  Pros: clear API (onConfirm/onCancel), aligns with Radix semantics
  Cons: one more component, slight duplication with Dialog
  Wins when: you value API clarity for devs

Option C — useConfirm() hook
  Pros: ergonomics max (const ok = await confirm(...))
  Cons: introduces async pattern in DS, less predictable
  Wins when: your team is React-advanced and values DX
```

Each option has honest tradeoffs — not a sales pitch. And the skill **declares its recommendation** with the rationale (contextual to your stack / team size / existing patterns).

## Step 4 — Get the spec (not the code)

Once you validate an option, the skill produces a **specification**, not an implementation :

- Exact API (prop names, types, defaults)
- Variants + states
- Tokens consumed (or to be created)
- A11y requirements (with Radix primitive recommendations if applicable)
- Questions still open

**You haven't written a line of code yet.** The spec fits on one page. Take it to your team, align, *then* implement.

## Common next actions

- **Option A or C selected, spec looks good** → hand off to the dev or ask the skill to implement Phase 1.
- **Spec raises questions you can't answer alone** → take those questions to Slack/standup. That's the point.
- **None of the options feel right** → share your constraints again. The skill will propose 2-3 new variations. Iterate.

## Tips

- **Use this BEFORE sprint planning.** Bring the 1-page spec to estimation — everyone sees the same API, estimates are accurate.
- **Kill overthinking.** If the skill proposes "just extend Dialog" and your team agrees, **stop there**. Don't build a new component for the hell of it.
- **Archive the spec** under `docs/rfcs/2026-04-confirm-dialog.md`. Your future self (and your team's PR reviewer) will remember the reasoning.

## Pitfalls

- **Don't skip the existing-scan step.** If you ignore the "hey, you already have a `Dialog`" signal, you'll end up with 2 confirmation patterns in 6 months.
- **Don't let the skill implement immediately.** The spec step IS the value. Implementation is mechanical.
- **Don't proliferate variants.** If the skill proposes 8 variants on a new component, push back. 3-4 max at v1.

## What comes next

Once the spec is validated and the component coded :

- Run **`/ds document <NewComponent>`** to generate its doc — no manual write-up
- Run **`/ds audit`** on the PR branch before merging — catch regressions
- Add the component to your `docs/components/` for the team

See also: [document-component.md](./document-component.md) for post-build docs, [first-audit.md](./first-audit.md) for ongoing health checks.
