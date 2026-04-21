# Design System Pro — Claude Code Skill

> Audit, document, extend and export your design system like a senior product designer — straight from Claude Code.

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](./LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-ff6b35.svg)](https://docs.claude.com/claude-code)
[![Version](https://img.shields.io/badge/version-0.3.0-blue.svg)](./CHANGELOG.md)

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

<details>
<summary>📸 See an example output</summary>

```markdown
# 📊 Audit Design System — my_landing

> Scanné le 2026-04-19 · 89 fichiers analysés
> Stack : Next 16 + Tailwind v4 + shadcn/ui + Radix + cva

## Score global : **74 / 100**

| Dimension | État | Score |
|---|---|---|
| Accessibilité (WCAG AA) | ✅ Excellent — 0 écart bloquant | 30 / 30 |
| Tokens & valeurs | 🟡 Quelques hardcodes à tokeniser | 20 / 25 |
| Consistance naming | 🟡 Drift kebab vs PascalCase | 10 / 15 |
| ...

## 🔴 Bloquant — 0 item

## 🟡 Dette — 4 items

### 🟡 1. Naming drift dans `src/components/ui/` — effort S

**Problème** : deux conventions coexistent dans le même dossier.
- shadcn : button.tsx, card.tsx, dialog.tsx (13 fichiers kebab-case)
- Custom : SectionLabel.tsx, GlassCard.tsx (7 fichiers PascalCase)

**Correction proposée** :
```diff
- src/components/ui/SectionLabel.tsx
+ src/components/ui/section-label.tsx
```

## 🎯 Ce que je ferais cette semaine

1. Supprimer 2 orphelins (XS, 5 min)
2. Tokeniser 6 avatar colors Testimonials (XS, 10 min)
3. Aligner ui/ en kebab-case (S, 20 min)

Total : ~35 min pour passer de 74 à 84/100.
```

</details>

### `/ds document Component`

A full markdown spec with:

- When to use (and when not)
- API table (props, types, defaults, description)
- Variants + states
- Accessibility checklist + keyboard shortcuts
- Code examples (basic, composition, integration)
- Do's & Don'ts
- Tokens consumed

<details>
<summary>📸 See an example output</summary>

```markdown
# Button

> Primary action trigger — 4 variants, 3 sizes, full a11y out of the box.

## Quand l'utiliser
- Actions principales (submit, confirm, open modal)
- Quand l'interaction change l'état de l'app

## Quand utiliser autre chose
- Navigation → utiliser `<Link>`
- Action icône-seule → utiliser `<IconButton>`

## API

| Prop | Type | Default | Description |
|---|---|---|---|
| `variant` | `"primary" \| "secondary" \| "ghost" \| "danger"` | `"primary"` | Style visuel |
| `size` | `"sm" \| "md" \| "lg"` | `"md"` | Taille du bouton |
| `loading` | `boolean` | `false` | Affiche un spinner et bloque le click |
| `disabled` | `boolean` | `false` | Désactive (a11y + visuel) |

## Accessibilité
✅ Balise sémantique `<button>`  ✅ type="button" explicite
✅ focus-visible ring 2px  ✅ aria-busy en loading

## Tokens consommés
- `color.primary` (background)
- `color.primary-foreground` (text)
- `radius.full`, `spacing.4` (padding-x), `spacing.3` (padding-y)
```

</details>

### `/ds extend Pattern`

A spec — **not code** — with:

- Problem statement
- 2-3 options compared (pros/cons/when it wins)
- API contract of the recommended option
- Tokens to consume (or create)
- A11y requirements
- Open questions to trigger team discussion

<details>
<summary>📸 See an example output</summary>

```markdown
# /ds extend — Confirmation Dialog

## Problème à résoudre
User a besoin de confirmer une action destructive (delete, archive).
Aujourd'hui pas de pattern, chaque dev improvise avec un `window.confirm()`.

## ⚖️ Options évaluées

### Option A — Étendre <Dialog> avec variant="alert"
**Pros** : Réutilise focus trap existant, 1 composant maintenu
**Cons** : Dialog API grossit, mélange use cases
**Gagne quand** : on veut minimiser le catalog

### Option B — <ConfirmDialog> dédié (RECOMMANDÉ)
**Pros** : API claire (onConfirm/onCancel), aligne sur Radix AlertDialog
**Cons** : 1 composant de plus, duplication légère avec Dialog
**Gagne quand** : on valorise la clarté d'API pour les devs

### Option C — useConfirm() hook
**Pros** : Ergonomie max (`const ok = await confirm(...)`)
**Cons** : Pattern async dans le DS, couplage inhabituel

## 💡 Ma reco : Option B

Le cas "action destructive" est suffisamment fréquent pour mériter son
composant. Radix AlertDialog existe déjà — bon base.

## Questions ouvertes
- [ ] Bouton "Plus tard" (3e option) à supporter ?
- [ ] Input "Tapez DELETE pour confirmer" → v2 ?
```

</details>

### `/ds tokens` *(new in v0.2)*

Scans your code + CSS and extracts used tokens:

- Colors, spacings, radii, font sizes, shadows, motion durations
- Grouped in a 3-layer W3C DTCG hierarchy (primitives / semantics / component)
- Outputs a valid `tokens.json` you can import into Figma Tokens Studio, Style Dictionary, or Terrazzo
- Ships with a migration plan: what to replace hardcode-by-hardcode

<details>
<summary>📸 See an example output</summary>

```json
{
  "$schema": "https://design-tokens.github.io/community-group/format/",
  "color": {
    "palette": {
      "black": { "$type": "color", "$value": "#0A0A0A" },
      "neutral-500": { "$type": "color", "$value": "#737373" }
    },
    "semantic": {
      "background": { "$type": "color", "$value": "{color.palette.white}" },
      "foreground": { "$type": "color", "$value": "{color.palette.black}" }
    }
  },
  "spacing": {
    "1": { "$type": "dimension", "$value": "4px" },
    "2": { "$type": "dimension", "$value": "8px" },
    "4": { "$type": "dimension", "$value": "16px" }
  }
}
```

Plus a migration plan:

```markdown
## Hardcodes à remplacer

| Fichier | Ligne | Valeur | Token |
|---|---|---|---|
| Contact.tsx | 42 | bg-[#1A1A1A] | bg-foreground |
| Hero.tsx | 104 | text-amber-500 | text-warning (à créer) |
```

</details>

## 📚 Step-by-step tutorials

Want to see a full walkthrough? Four tutorials in [`docs/`](./docs/):

- [`docs/first-audit.md`](./docs/first-audit.md) — Your first `/ds audit` from zero to action plan
- [`docs/document-component.md`](./docs/document-component.md) — Generate proper docs for a Button
- [`docs/extend-pattern.md`](./docs/extend-pattern.md) — Reason a new component before coding it
- [`docs/extract-tokens.md`](./docs/extract-tokens.md) — Bootstrap a `tokens.json` from legacy code

## Philosophy

Six principles the skill applies to every output:

1. **Read before you speak.** An audit without scanning files = an opinion, not an audit.
2. **Opinionated but factual.** Every flagged issue comes with a why (rule violated, user impact, maintenance cost).
3. **Prioritize your output.** Everything sorted 🔴 / 🟡 / 🟢. No 2000-line dumps.
4. **Propose, don't decide alone.** For new components or migrations, 2-3 options with tradeoffs — the team trumps the AI.
5. **English for tech.** Token, variant, prop, WCAG, ARIA, focus-visible — these are the industry names.
6. **French for prose, English for tech.** The audience is francophone, the tech world writes in English. Respect both.

## Roadmap

**v0.3.0** ← you are here
- [x] New `/ds help` command — formatted menu with examples
- [x] `docs/` folder — 4 step-by-step tutorials
- [x] Enriched install message — first-step guidance after setup.sh
- [x] README example outputs — see what each command produces

**v0.2.0**
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
