# Changelog

All notable changes to this skill are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.1.0]: https://github.com/cherifskr/design-system-pro/releases/tag/v0.1.0
