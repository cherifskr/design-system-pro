# Your first `/ds audit` — from zero to action plan

> **Prerequisites** : skill installed, Claude Code restarted, a project with components to audit.

## Scenario

You inherited a Next.js codebase. The `src/components/ui/` folder has 20+ files, mixing shadcn defaults and custom work from 3 different devs over 18 months. You *feel* there's drift, but you don't have a day to map it out manually.

That's where `/ds audit` pays off.

## Step 1 — Run it

Open your project in Claude Code and type:

```
/ds audit
```

That's it. No args needed — the skill scans `src/components/` (or the equivalent location it detects) by default.

You can also scope it:

```
/ds audit src/components/ui/     # just the DS folder
/ds audit src/app/resources/     # a feature area
```

## Step 2 — Watch what happens

The skill runs a sequence of targeted scans. You'll see Claude:

1. **Read `package.json`** to identify your stack (React/Next/Vue/Svelte, Tailwind v3/v4, shadcn, Radix, cva, framer-motion…)
2. **Detect your conventions** (kebab-case vs PascalCase file naming, token source location)
3. **Grep for hardcoded values** (hex colors, rgb, non-rational px)
4. **Cross-reference variants** (every `cva()` variant gets grepped across the codebase)
5. **Check a11y signals** (outline-none without focus-visible, icon-only buttons without aria-label)
6. **Scan for god-mode components** and orphan files

Nothing is fabricated — every number in the report comes from an actual `Glob` or `Grep` run.

## Step 3 — Read the output

The report is structured in 3 bands. **Read them in order**:

### 🔴 Bloquant (blocking)
These are things that break users or violate a11y. **Fix this sprint**.

> Example: *"`<div onClick>` on line 42 of `HeroCard.tsx` — Nielsen #4 violated: not keyboard-accessible. Effort: XS."*

### 🟡 Dette (debt)
Inconsistencies that slow the team but don't break users. **Plan for this month**.

> Example: *"Naming drift in `src/components/ui/` — 13 kebab-case files + 7 PascalCase. Align on kebab-case (shadcn default, already dominant). Effort: S."*

### 🟢 Nice-to-have
Polish and future-proofing. **Pick up when you have margin**.

> Example: *"No JSDoc on the Button's exported props — a newcomer needs to read the implementation. 15 min per component."*

## Step 4 — Interpret the score

The `/100` score is not the headline — the **action plan is**. Use the score to:

- Track progress over time (run `/ds audit` after a refactor to see delta)
- Flag a "red line" for your team (e.g., "we don't merge if score drops below 70")

The skill always ends with a **"What I'd ship this week"** section — 3 items max, picked for highest ROI / effort ratio. That's your next PR queue.

## Common next actions

- **Item listed is trivial** (XS/S)? → Fix right now in a quick PR.
- **Item requires decision** (e.g., rename all ui/ files)? → Bring to the team, align, then batch-fix.
- **Item is uncertain** (e.g., "is this really dead code?")? → Ask the skill: `document <ComponentName>` first, see where it's imported.

## Tips

- **Run `/ds audit` before every sprint planning.** Takes 2 min, gives you 2-3 debt items for the backlog.
- **Commit the report.** `docs/audits/2026-04-ds-audit.md` — useful for retro and hiring interviews ("here's how we measure quality").
- **Scope tightly for incremental audits.** After the first global run, scope to one folder per PR.

## Pitfalls

- **Don't let the skill rename files for you.** It audits, it doesn't refactor. You review and apply.
- **The skill can't know your design intent.** If it flags a variant as orphan but you're planning to use it next week, mark it as intentional in a comment.
- **Dev-only files (PDF export inline styles, data presets with gradients, theme-color meta tags) are legitimate hardcodes.** The skill marks them as such — don't let them pollute the priority list.

## What comes next

Once you've knocked out the first wave of items, try:

- `/ds document Button` → generate proper docs for a well-worn component
- `/ds tokens` → extract a `tokens.json` from the hardcodes the audit flagged

See also: [document-component.md](./document-component.md), [extract-tokens.md](./extract-tokens.md).
