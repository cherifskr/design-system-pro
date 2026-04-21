# Design System Pro — Claude Code Skill

> Audit, document, extend and export your design system like a senior product designer — straight from Claude Code.

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](./LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-ff6b35.svg)](https://docs.claude.com/claude-code)
[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](./CHANGELOG.md)

---

## What it does

Four commands that turn Claude into a **senior DS partner** on your project:

```bash
/ds audit                       # scan your DS — stack-aware, tokens, a11y, naming drift
/ds document Button             # generate a full component doc
/ds extend confirmation-dialog  # propose a reasoned new component
/ds tokens                      # extract used tokens as W3C DTCG JSON
```

Works on **React / Next / Vue / Svelte** with **Tailwind v3/v4 / CSS-in-JS / shadcn / Radix**. Zero config.

## Why this exists

Every designer I know has a Notion page called « DS audit » they never open. Every engineering team has a `components/ui/` folder that drifts three times a year. The problem isn't the will — it's the **time to look at it seriously**.

This skill does the looking. In 2 minutes instead of 2 days.

- **`/ds audit`** detects your stack (Next/Tailwind/shadcn/Radix/cva) and applies relevant checks: hardcoded tokens, orphan components, WCAG AA gaps, naming drift, god-mode components, unused cva variants. Scores it /100 with a 3-band priority list.
- **`/ds document <component>`** extracts API, variants, states, a11y from the file and produces markdown doc ready for Storybook, Notion, or your team Slack.
- **`/ds extend <pattern>`** proposes a new component **before** you write it: 2-3 options with tradeoffs, API contract, tokens consumed, a11y considerations.
- **`/ds tokens`** scans your code + CSS and extracts every color, spacing, radius, typography value actually used — outputs a valid W3C DTCG `tokens.json` you can import into Figma Tokens Studio, Style Dictionary or Terrazzo.

Opinionated output. French prose, English for technical terms (token, variant, WCAG, ARIA — the industry words).

## Quick start

### Option 1 — One-line install (recommended)

Installs the skill **and** registers the `/ds` slash command shortcut in one command:

```bash
curl -fsSL https://raw.githubusercontent.com/cherifskr/design-system-pro/main/setup.sh | bash
```

Then restart Claude Code.

### Option 2 — Manual install

Skill only (no `/ds` shortcut — you'll invoke by natural language):

```bash
git clone https://github.com/cherifskr/design-system-pro ~/.claude/skills/design-system-pro
```

If you want the `/ds` shortcut too:

```bash
# Also register the slash command globally
mkdir -p ~/.claude/commands
cp ~/.claude/skills/design-system-pro/slash/ds.md ~/.claude/commands/ds.md
```

### Option 3 — Per-project install

Skill committed into a specific repo so your team shares it via Git:

```bash
# Inside your project root
git clone https://github.com/cherifskr/design-system-pro .claude/skills/design-system-pro
git add .claude/skills/design-system-pro
git commit -m "chore(skills): add design-system-pro"
```

Then optionally register the slash command at project level:

```bash
mkdir -p .claude/commands
cp .claude/skills/design-system-pro/slash/ds.md .claude/commands/ds.md
```

### Two ways to invoke it

Either way works the same:

| | Method | Example |
|---|---|---|
| 1. | Slash command | `/ds audit` |
| 2. | Natural language | « audite mon design system », « review mes composants » |

Claude Code auto-triggers the skill on keyword match in either case.

## Structure

```
design-system-pro/
├── SKILL.md                      # entry point read by Claude Code
├── commands/                     # internal procedures (referenced by SKILL.md)
│   ├── audit.md
│   ├── document.md
│   ├── extend.md
│   └── tokens.md                 # ← new in v0.2
├── references/
│   ├── tokens-schema.md
│   ├── component-anatomy.md
│   ├── a11y-checklist.md
│   └── stack-detection.md        # ← new in v0.2
├── templates/
│   ├── audit-report.md
│   ├── component-doc.md
│   └── tokens.json
├── slash/
│   └── ds.md                     # ← new in v0.2 — Claude Code slash command
└── setup.sh                      # ← new in v0.2 — one-line installer
```

Each file is legit standalone reading — a compact DS handbook even without Claude.

## What you get from each command

### `/ds audit`

A markdown report with:

- **Stack detected** (Next.js 16, Tailwind v4, shadcn, Radix primitives, cva…) — drives the rules applied
- **Score /100** across 6 axes (a11y, tokens, naming, docs, orphans, duplication)
- **Issues sorted 🔴 / 🟡 / 🟢** — blocking / debt / nice-to-have
- For each issue: rule violated, user impact, proposed fix (before/after), effort estimate (XS–XL)
- "What I'd ship this week" — the 3 highest-ROI items

### `/ds document Component`

A full markdown spec with:

- When to use (and when not)
- API table (props, types, defaults, description)
- Variants + states
- Accessibility checklist + keyboard shortcuts
- Code examples (basic, composition, integration)
- Do's & Don'ts
- Tokens consumed

### `/ds extend Pattern`

A spec — **not code** — with:

- Problem statement
- 2-3 options compared (pros/cons/when it wins)
- API contract of the recommended option
- Tokens to consume (or create)
- A11y requirements
- Open questions to trigger team discussion

### `/ds tokens` *(new in v0.2)*

Scans your code + CSS and extracts used tokens:

- Colors, spacings, radii, font sizes, shadows, motion durations
- Grouped in a 3-layer W3C DTCG hierarchy (primitives / semantics / component)
- Outputs a valid `tokens.json` you can import into Figma Tokens Studio, Style Dictionary, or Terrazzo
- Ships with a migration plan: what to replace hardcode-by-hardcode

## Philosophy

Six principles the skill applies to every output:

1. **Read before you speak.** An audit without scanning files = an opinion, not an audit.
2. **Opinionated but factual.** Every flagged issue comes with a why (rule violated, user impact, maintenance cost).
3. **Prioritize your output.** Everything sorted 🔴 / 🟡 / 🟢. No 2000-line dumps.
4. **Propose, don't decide alone.** For new components or migrations, 2-3 options with tradeoffs — the team trumps the AI.
5. **English for tech.** Token, variant, prop, WCAG, ARIA, focus-visible — these are the industry names.
6. **French for prose, English for tech.** The audience is francophone, the tech world writes in English. Respect both.

## Roadmap

**v0.2.0** ← you are here
- [x] Stack-aware audit (Next / Tailwind v4 / shadcn / Radix / cva)
- [x] New `/ds tokens` command — W3C DTCG extraction
- [x] Bundled `/ds` slash command + one-line installer
- [x] Enriched a11y checklist (contrast formula, keyboard nav)

**v0.1.0**
- [x] `/ds audit` — full DS scan
- [x] `/ds document <component>` — component doc generation
- [x] `/ds extend <pattern>` — reasoned new component spec

**v1.0 (free)**
- [ ] Broader framework support (Solid, Qwik, Astro)
- [ ] Storybook-aware documentation (read `.stories.tsx` to enrich doc)
- [ ] JSON output for CI integration
- [ ] English version of the SKILL.md

**v2.0 (paid)**
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

I'm **Chérif Sikirou**, Sr. Product Designer & Design System Specialist.

I've spent 8+ years building design systems for SaaS, e-commerce and fintech products — across Europe and West Africa. Somewhere along the way I got tired of writing the same audit spreadsheet over and over. This skill is what I built so I'd never have to do it manually again.

- 🌐 [cherifsikirou.com](https://cherifsikirou.com)
- 💼 [LinkedIn](https://www.linkedin.com/in/cherifsikirou/)
- 📧 [contact@cherifsikirou.com](mailto:contact@cherifsikirou.com)
