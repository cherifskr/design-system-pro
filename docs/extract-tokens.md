# Bootstrap a `tokens.json` from legacy code — `/ds tokens`

> **Prerequisites** : skill installed, a codebase that has **no formalized tokens** yet (or partial ones).

## Scenario

Your codebase has been accumulating hex values for 2 years. There's a half-finished CSS variables section in `globals.css`. Half the team uses `text-neutral-500`, the other half writes `text-[#737373]`. You want to centralize, but starting from scratch feels daunting.

`/ds tokens` extracts what's **already there** and hands you a starting point.

## Step 1 — Run it

```
/ds tokens                         # scan entire src/ by default
/ds tokens src/components/         # limit the scope
```

## Step 2 — Watch the extraction

The skill scans :

1. **CSS files** for `@theme`, `:root { --* }`, custom properties
2. **Tailwind config** (v3 `theme.extend` or v4 `@theme` CSS)
3. **Component source files** for :
   - Hex colors in inline styles, className arbitrary values (`bg-[#1A1A1A]`), CSS-in-JS
   - Pixel / rem / em values in spacing contexts (padding, margin, gap)
   - `border-radius` values
   - `box-shadow` declarations
   - Font sizes, weights, line-heights

Each unique value is **deduplicated and counted** — how many times is `#737373` actually used?

## Step 3 — Read the two outputs

### Output A : the `tokens.json`

A valid W3C DTCG file grouped in 3 layers :

```json
{
  "color": {
    "palette": {          // layer 1 — primitives
      "black": { "$type": "color", "$value": "#0A0A0A" },
      "neutral-500": { "$type": "color", "$value": "#737373" }
    },
    "semantic": {         // layer 2 — roles
      "background": { "$type": "color", "$value": "{color.palette.white}" },
      "foreground": { "$type": "color", "$value": "{color.palette.black}" },
      "muted-foreground": { "$type": "color", "$value": "{color.palette.neutral-500}" }
    }
  },
  "spacing": {
    "1": { "$type": "dimension", "$value": "4px" },
    "2": { "$type": "dimension", "$value": "8px" }
  }
}
```

**The 3 layers explained** :
- **Primitives** (`color.palette.*`) : raw values, the actual colors that exist
- **Semantics** (`color.semantic.*`) : roles in the UI (background, foreground, primary, destructive…) — references the primitives
- **Component** (`button.primary.background`) : optional — created when a component has its own tokens

### Output B : the migration plan

A markdown document telling you **what to replace with what** :

```markdown
## Hardcodes à remplacer

| Fichier | Ligne | Valeur actuelle | Token proposé |
|---|---|---|---|
| Contact.tsx | 42 | `bg-[#1A1A1A]` | `bg-foreground` (existe dans v4 @theme) |
| Hero.tsx | 104 | `text-amber-500` | `text-warning` (à créer comme nouveau semantic) |
| Testimonials.tsx | 27-32 | 6 hex pour avatars | `bg-neutral-{500-800}` (échelle Tailwind standard) |

## Ce qui reste à décider

- [ ] Le gradient orange-pink du logo → token `color.brand.accent` ou exception ?
- [ ] `#F77F00` utilisé une seule fois → token ou hardcode légitime ?
```

## Step 4 — What to do with the outputs

1. **Save the JSON** to `design/tokens.json` (or wherever your design team expects)
2. **Import into Figma Tokens Studio** — designers now have the same reference as devs
3. **Or import into Style Dictionary / Terrazzo** — for automated export to CSS vars, Tailwind config, Swift, Android, etc.
4. **Start the migration, PR by PR** — don't try to replace all hardcodes at once. Pick one value, search-and-replace, ship.

## Common next actions

- **Figma handshake** : paste the JSON to your designer, ask them to sync it into Figma Tokens Studio. Suddenly you're speaking the same language.
- **Second pass with `/ds audit`** : after 2-3 PRs of migration, run `/ds audit` — the token score should climb noticeably.
- **Decide on semantic names** : the skill inferred `semantic.foreground` from your usage, but maybe your brand calls it `text.default`. Rename before committing — everything will reference it.

## Tips

- **One hardcode used once is an exception, not a token.** The skill flags these in the "to decide" section — review and decide deliberately.
- **Keep `tokens.json` versioned in Git.** Bump the version on every change, use semver discipline (BREAKING = remove a token, MINOR = add, PATCH = rename).
- **Run the command again after 6 months.** Your codebase evolves — new hardcodes slip in. Re-run, compare with the previous tokens, see drift.

## Pitfalls

- **Don't import 200 tokens at once into Figma.** Start with the top 30 (most used). Add more incrementally as designers ask.
- **The skill can't read your design intent.** If it groups `#EF4444` and `#DC2626` as two distinct tokens but they should be one (with a lighter variant derived), that's your call to make.
- **Avoid over-layering.** 3 layers is enough. Don't create `color.semantic.button.primary.background.hover` — Tailwind already handles hover via modifiers.

## What comes next

Once your tokens are centralized :

- Migrate hardcodes (the audit will quantify progress)
- Document components against the new tokens (`/ds document <Component>`)
- Integrate in your design-to-code workflow (MCP Figma + tokens.json = single source of truth)

See also: [first-audit.md](./first-audit.md) to spot hardcode debt, [document-component.md](./document-component.md) to reference tokens in doc.
