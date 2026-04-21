# Changelog

All notable changes to this skill are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] — 2026-04-20

### Added

- **New command `/ds help`** — formatted help menu shown on `/ds help`
  or a bare `/ds` without arguments. Explains each command with a
  real example, its typical duration, and when to reach for it. The
  first command new users should run.
- **`docs/` folder with 4 step-by-step tutorials** — each covers one
  command end-to-end (scenario, output, how to interpret, pitfalls):
  - `docs/first-audit.md`
  - `docs/document-component.md`
  - `docs/extend-pattern.md`
  - `docs/extract-tokens.md`
- **Enriched `setup.sh` post-install message** — explains what each
  command does in one line, suggests a first step (`/ds help`),
  and links to the tutorials folder.
- **README "Example outputs" section** — each command now ships with
  a collapsible example showing what a real run produces (audit
  report, component doc, extend proposal, tokens.json).

### Changed

- **Bare `/ds` now shows the help menu** instead of asking the user
  which command to run. Lower friction for first-timers.
- **SKILL.md description** references `/ds help` so Claude proactively
  suggests it when a new user invokes the skill.

### Fixed

- **Embedded slash command in `setup.sh`** updated to match the new
  `slash/ds.md` — previously new installs would get the v0.2 layout
  without the `help` command.

## [0.2.0] — 2026-04-20

### Added

- **New command `/ds tokens`** — scans code and CSS to extract every
  color, spacing, radius, typography value actually used in the
  project, and outputs a valid W3C DTCG `tokens.json` grouped in a
  3-layer hierarchy (primitives / semantics / component). Ships with
  a migration plan mapping each hardcode to its proposed token.
- **Stack detection** — the audit now identifies framework (Next.js,
  Vue, Svelte, Astro), UI libs (shadcn, Radix primitives, Chakra,
  MUI), Tailwind version (v3 vs v4 with `@theme`), tokens config
  location and naming conventions. Rules applied are adapted to the
  detected stack instead of generic.
- **`/ds` slash command shipped with the repo** — a `slash/ds.md`
  file is now included so users can install the shortcut in one step,
  rather than relying on manual configuration. The one-line installer
  `setup.sh` registers both the skill and the command.
- **`setup.sh` one-line installer** — clones/copies the skill into
  `~/.claude/skills/design-system-pro/` and registers `/ds` at
  `~/.claude/commands/ds.md` in a single curl-pipe command.
- **New reference `stack-detection.md`** — the procedure the skill
  follows to identify your stack and adapt rules to it.

### Changed

- **Audit is more actionable** — god-mode components (15+ props) are
  flagged as duplication signals; orphan cva variants are detected
  by grep-based cross-reference; contrast ratios are computed (not
  just estimated) when both `color` and `background-color` are found
  in the same selector.
- **SKILL.md description** — now mentions both the natural-language
  invocation and the `/ds` shortcut so Claude auto-triggers reliably
  regardless of install method.
- **A11y checklist enriched** — adds the WCAG relative-luminance
  contrast formula and per-component keyboard-nav requirements.

### Fixed

- **Install inconsistency** — v0.1 users who cloned from Git didn't
  get the `/ds` shortcut (it only existed on the author's machine).
  Now shipped with the repo and installable via `setup.sh`.

## [0.1.0] — 2026-04-19

### Initial release

The first public version. Three commands, three references, three templates.

**Commands**
- `/ds audit` — scan components for hardcoded tokens, variant orphans,
  WCAG AA gaps, naming drift. Produces a scored markdown report with
  a three-band priority list (🔴 blocking / 🟡 debt / 🟢 nice-to-have).
- `/ds document <component>` — generate a full markdown spec from a
  component file (API, variants, states, accessibility, do/don't).
- `/ds extend <pattern>` — propose a reasoned new component with 2-3
  options compared, proposed API, tokens consumed, a11y considerations.

**References**
- `tokens-schema.md` — W3C DTCG format, 3-layer hierarchy (primitives /
  semantics / component), export to CSS / Tailwind / JS.
- `component-anatomy.md` — the 6 dimensions of a pro component
  (semantics, composition, API, variants, states, a11y).
- `a11y-checklist.md` — WCAG 2.1 AA per component + ARIA patterns.

**Templates**
- `audit-report.md` — structure for the audit output.
- `component-doc.md` — structure for the component doc output.
- `tokens.json` — valid W3C DTCG tokens example, ready to adapt.

### Supported stacks
React (.tsx, .jsx), Vue, Svelte, Astro, Tailwind CSS v3/v4, CSS-in-JS,
vanilla CSS / SCSS.

[0.3.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.3.0
[0.2.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.2.0
[0.1.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.1.0
