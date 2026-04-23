# Changelog

All notable changes to this skill are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] — 2026-04-23

### Added

- **New command `/ds diff <before> <after>`.** Compares two `DESIGN.md`
  files (or two audit JSON reports) and surfaces tokens added/removed/
  modified, breaking changes with the list of consumer files, and
  resolved/new/persistent findings. Verdict in one line —
  ✅ Compatible / ⚠️ Visual change / 🔴 Breaking — followed by the
  detail and a machine-readable JSON block aligned with
  [`@google/design.md diff`](https://github.com/google-labs-code/design.md).
  Closes the "did my PR break the DS?" gap.
- **New command `/ds rules`.** Exports the 12 named lint rules
  (`a11y-contrast`, `hardcoded-color`, …) used by `/ds audit` as
  markdown or JSON. Drop-in for another agent's system prompt
  (Cursor, Copilot, Codex), commitable as `DS-RULES.md` or
  `.cursor/rules/ds.md`. Filterable by `--severity` or `--rule`.
- **`DESIGN.md` as a first-class output of `/ds audit`.** Each audit
  now produces a `DESIGN.md` at the root of the scanned scope, on top
  of the markdown report. The format is compatible with
  [`@google/design.md`](https://github.com/google-labs-code/design.md):
  YAML front matter for tokens (colors, typography, spacing, rounded,
  components) + canonical markdown sections for prose. It's the
  single artefact a downstream agent (Claude, Cursor, Copilot) needs
  to respect the design system without re-scanning the codebase. New
  template: `templates/design.md`.
- **9 named lint rules.** Each finding produced by `/ds audit` now
  carries a `rule` name with a fixed default severity:
  `hardcoded-color`, `hardcoded-spacing`, `hardcoded-typography`,
  `orphan-variant`, `orphan-export`, `god-component`,
  `duplicated-component`, `naming-drift`, `a11y-contrast`,
  `a11y-label-missing`, `a11y-focus-removed`, `a11y-semantic`.
  Severity overrides require an explicit `reason` — judgment becomes
  auditable instead of implicit.
- **Structured findings JSON block** appended to every audit report
  (`{ rule, severity, path, message, reason? }`). Machine-readable,
  diff-able across runs, exportable to a tracker.
- **Per-rule summary table** at the top of the report — counts of
  errors / warnings / info per rule, lets the reader spot patterns
  before reading the detail.

### Changed

- **Audit report sections now follow the canonical order** inspired
  by the DESIGN.md spec: `Overview → Colors → Typography → Layout →
  Elevation & Depth → Shapes → Components → Do's and Don'ts`. Reports
  become comparable across projects, and the markdown body of the
  generated `DESIGN.md` follows the same order.
- **Three-band priority is now derived from severity**, not the other
  way around. 🔴 = `error`, 🟡 = `warning`, 🟢 = `info`. No more
  contextual band assignment that drifts run-to-run.

### Upgrade from v0.3.x

Run `setup.sh` again. No breaking change in invocation — `/ds audit`
still works the same. The new `DESIGN.md` artefact is generated
automatically; the markdown report gains a per-rule summary table and
a JSON findings block at the bottom.

## [0.3.2] — 2026-04-21

### Changed

- **README — punchier opening.** The `Why this exists` hook is promoted
  to the top, a `Before → With /ds` comparison table makes the ROI
  visible at a glance, and the install command appears in the first
  screenful. No features changed — pure documentation polish.
- **Install options restructured.** The curl one-liner is now front
  and center; manual and per-project alternatives moved to an
  `Other install methods` section for power users.

### Upgrade from v0.3.1

Pure README / documentation patch. Re-run `setup.sh` if you want the
bumped version badge; skip otherwise — nothing functional changed.

## [0.3.1] — 2026-04-20

### Added

- **Version-aware `setup.sh`** — the installer now reads the existing
  `CHANGELOG.md` before clobbering, prints `"Upgrading v0.2.0 → v0.3.1"`
  when an older install is detected. Clear signal to the user that
  something *changed*, instead of a silent rewrite.
- **"Upgrading from a previous version" section in README** — explicit
  upgrade paths for both `setup.sh` users and people who cloned via
  `git clone` directly.
- **`setup.sh` now copies `docs/` and `slash/`** when running from a
  local clone (missed in v0.3.0 — upgrades from a local clone didn't
  get the tutorials or the bundled slash command).

### Upgrade from v0.3.0

Run `setup.sh` again. No breaking changes, no config to touch.

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

### Upgrade from v0.2.x

Run `setup.sh` again — it overwrites both the skill and the `/ds`
slash command. Your previous `/ds` shortcut will now default to the
new `/ds help` menu when called without arguments. No config to edit.

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

### Upgrade from v0.1.x

The recommended path is to run the new `setup.sh` — it installs both
the skill and the `/ds` shortcut in one go:

```bash
curl -fsSL https://raw.githubusercontent.com/cherifskr/design-system-pro/main/setup.sh | bash
```

If you prefer manual: `cd ~/.claude/skills/design-system-pro && git pull`
will update the skill files but won't install `/ds` — copy it by hand
with `cp slash/ds.md ~/.claude/commands/ds.md` afterward.

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

[0.4.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.4.0
[0.3.2]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.3.2
[0.3.1]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.3.1
[0.3.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.3.0
[0.2.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.2.0
[0.1.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.1.0
