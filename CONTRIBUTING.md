# Contributing to Design System Pro

Thanks for considering a contribution. This skill is meant to stay focused
and opinionated — not every suggestion will land, but every thoughtful
issue is welcome.

## Before you open a PR

**Open an issue first** for anything larger than a typo fix. Describe:
- The problem you're trying to solve (real use case, not a hypothetical)
- How it affects people using the skill today
- Your proposed approach (just the gist — don't write the code yet)

Two minutes of alignment saves hours of rework.

## What we accept

- 🟢 **Bug fixes** — if a procedure gives the wrong output, fix + explain
  the reproduction in the PR description.
- 🟢 **Better wording** — especially for the prose in SKILL.md, commands,
  and references. Both French and English are welcome.
- 🟢 **New references** — if there's a DS topic we should document
  (tokens for motion, i18n patterns, RTL support…), open an issue.
- 🟢 **Framework support** — patterns for Solid, Qwik, or any framework
  not covered yet.

## What we don't accept (today)

- 🔴 **New commands** — `audit` / `document` / `extend` cover the 80%.
  New ones risk diluting focus. Open a discussion first if you think
  otherwise.
- 🔴 **Tooling / scripts** — planned for v2.0 (paid). Keep v0.x free and
  dependency-free.
- 🔴 **LLM-specific tuning** — the skill must work on any Claude version
  without tweaks.

## Style guide

- **Prose**: French (primary audience is francophone DS/design people).
- **Tech terms**: English (`token`, `variant`, `WCAG`, `ARIA`, `focus-visible` —
  the industry names).
- **Voice**: warm and senior. The user is a peer, not a newbie.
- **Length**: if you're over 400 lines in one file, you're probably
  covering two topics. Split.
- **Examples**: always concrete. `#1A1A1A` beats "a dark color". Name a
  real file, show a real diff.

## How to test a change

Before submitting:

1. Install your branch as a skill:
   ```bash
   ln -s $(pwd) ~/.claude/skills/design-system-pro
   ```
2. Restart Claude Code.
3. Run `/ds audit` on at least **two different projects** (different
   stacks if possible).
4. Verify the output still matches the principles in SKILL.md.

If the audit gives markedly different results on the same project
before/after your change, flag it explicitly in the PR description.

## Commit messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(commands): add support for Svelte 5 runes in /ds document
fix(audit): detect outline-none without focus-visible compensation
docs(readme): clarify install instructions for Windows
```

## Code of conduct

Be kind, be specific, assume good intent. That's it.

## Questions?

- 📧 [contact@cherifsikirou.com](mailto:contact@cherifsikirou.com)
- 💼 [LinkedIn](https://www.linkedin.com/in/cherifsikirou/)
- 🐛 [Open an issue](https://github.com/cherifskr/design-system-pro/issues/new)
