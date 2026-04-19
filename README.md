# Design System Pro — Claude Code Skill

> Audit, document and extend your design system like a senior product designer — straight from Claude Code.

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](./LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-ff6b35.svg)](https://docs.claude.com/claude-code)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](./CHANGELOG.md)

---

## What it does

Three commands that turn Claude into a **senior DS partner** on your project:

```bash
/ds audit                       # scan your DS — tokens, variants, a11y, naming drift
/ds document Button             # generate a full component doc
/ds extend confirmation-dialog  # propose a reasoned new component
```

Works on **React / Next / Vue / Svelte** with **Tailwind / CSS-in-JS**. Zero config.

## Why this exists

Every designer I know has a Notion page called « DS audit » they never open. Every engineering team has a `components/ui/` folder that drifts three times a year. The problem isn't the will — it's the **time to look at it seriously**.

This skill does the looking. In 2 minutes instead of 2 days:

- **`/ds audit`** scans your codebase, flags hardcoded tokens, orphan components, WCAG AA gaps, and naming drift. Scores it /100. Gives you a priority list.
- **`/ds document <component>`** extracts API, variants, states, a11y from the file and produces markdown doc ready for Storybook, Notion, or your team Slack.
- **`/ds extend <pattern>`** proposes a new component **before** you write it: 2-3 options with tradeoffs, API contract, tokens consumed, a11y considerations.

Opinionated output. French prose, English for technical terms (token, variant, WCAG, ARIA — the words everyone uses).

## Quick start

### 1. Install

**Global** (available in all your projects — recommended):

```bash
# macOS / Linux
git clone https://github.com/cherifskr/design-system-pro ~/.claude/skills/design-system-pro

# Or download the ZIP release and extract into ~/.claude/skills/
```

**Per project** (committed to Git, team-shared):

```bash
git clone https://github.com/cherifskr/design-system-pro .claude/skills/design-system-pro
git add .claude/skills/design-system-pro
git commit -m "chore(skills): add design-system-pro"
```

### 2. Restart Claude Code

The new skill is detected on startup. No config needed.

### 3. Run it

```bash
/ds audit
/ds document Button
/ds extend "confirmation modal before destructive action"
```

Or just say it in natural language — the skill triggers on keywords like « audite mon design system » or « vérifie la cohérence de mes composants ».

## Structure

```
design-system-pro/
├── SKILL.md                      # entry point read by Claude Code
├── commands/
│   ├── audit.md                  # procedure for /ds audit
│   ├── document.md               # procedure for /ds document
│   └── extend.md                 # procedure for /ds extend
├── references/
│   ├── tokens-schema.md          # W3C DTCG format, 3-layer hierarchy
│   ├── component-anatomy.md      # the 6 dimensions of a pro component
│   └── a11y-checklist.md         # WCAG 2.1 AA per component + ARIA patterns
└── templates/
    ├── audit-report.md           # audit output format
    ├── component-doc.md          # component doc format
    └── tokens.json               # valid W3C DTCG tokens example
```

Read each file — they're legit standalone knowledge even without Claude.

## What you get from each command

### `/ds audit`
A markdown report in three bands:
- 🔴 **Blocking** — a11y gaps, security issues, real user breaks
- 🟡 **Debt** — inconsistencies, duplication, accumulating maintenance
- 🟢 **Nice-to-have** — polish, conventions that could be stricter

Each item has: the problem, the files/lines, why it's a problem, a proposed fix (before/after when possible), and effort estimate (XS to XL).

Ends with « what I'd ship this week » — the 3 items that give maximum value for minimum effort.

### `/ds document Component`
A full markdown spec with:
- When to use (and when not to)
- API table (props, types, defaults, description)
- Variants + states
- Accessibility checklist + keyboard shortcuts
- Code examples (basic, composition, integration)
- Do's & Don'ts
- Tokens consumed

Ready to paste into Notion, Storybook MDX, or your team docs.

### `/ds extend Pattern`
A spec — **not code** — with:
- Problem statement
- 2-3 options compared (pros/cons/when it wins)
- API contract of the recommended option
- Tokens to consume (or create)
- A11y requirements
- Open questions to trigger team discussion

You validate the direction, **then** the next step is implementation.

## Philosophy

Six principles the skill applies to every output:

1. **Read before you speak.** An audit without scanning files = an opinion, not an audit.
2. **Opinionated but factual.** Every flagged issue comes with a why (rule violated, user impact, maintenance cost).
3. **Prioritize your output.** Everything sorted 🔴 / 🟡 / 🟢. No 2000-line dumps.
4. **Propose, don't decide alone.** For new components or migrations, 2-3 options with tradeoffs — the team trumps the AI.
5. **English for tech.** Token, variant, prop, WCAG, ARIA, focus-visible — these are the industry names.
6. **French for prose, English for tech.** The audience is francophone, the tech world writes in English. Respect both.

## Roadmap

**v0.1.0** ← you are here
- [x] `/ds audit` — full DS scan
- [x] `/ds document <component>` — component doc generation
- [x] `/ds extend <pattern>` — reasoned new component spec

**v1.0 (free)**
- [ ] Broader framework support (Solid, Qwik)
- [ ] Integration tests for the audit scanner
- [ ] i18n: English version of the SKILL.md

**v2.0 (paid)**
- [ ] `/ds tokens` — auto-export tokens to W3C DTCG / Tailwind / CSS vars
- [ ] `/ds migrate` — codemod suggestions (v1 → v2, legacy → tokens)
- [ ] `/ds figma-sync` — bidirectional sync with Figma via MCP
- [ ] Automated scripts for deeper repo analysis
- [ ] Token packs ready to use (SaaS, e-commerce, fintech presets)

Want to shape the roadmap? [Open an issue](https://github.com/cherifskr/design-system-pro/issues/new) or DM me on [LinkedIn](https://www.linkedin.com/in/cherifsikirou/).

## Contributing

Contributions welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for the short version.

TL;DR:
- Open an issue before big changes
- Keep the FR/EN split (prose French, tech English)
- Don't add commands for the sake of adding commands — each one should solve a real pain
- Test on your own project before submitting

## License

MIT © 2026 Chérif Sikirou

Use, modify, redistribute — including in commercial projects. A backlink to [cherifsikirou.com](https://cherifsikirou.com) is appreciated but not required.

## Who built this

I'm **Chérif Sikirou**, Sr. Product Designer & Design System Specialist based in Abidjan.

I've spent 8+ years building design systems for SaaS, e-commerce and fintech products — across Europe and West Africa. Somewhere along the way I got tired of writing the same audit spreadsheet over and over. This skill is what I built so I'd never have to do it manually again.

- 🌐 [cherifsikirou.com](https://cherifsikirou.com)
- 💼 [LinkedIn](https://www.linkedin.com/in/cherifsikirou/)
- 📧 [contact@cherifsikirou.com](mailto:contact@cherifsikirou.com)

---

