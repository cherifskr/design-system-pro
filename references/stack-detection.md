# Stack Detection — Comment adapter les règles au contexte

> Référence utilisée par `/ds audit`, `/ds document` et `/ds tokens` pour détecter la stack du projet avant d'appliquer quoi que ce soit. Un audit générique sur un repo shadcn produit du bruit. Un audit adapté à shadcn produit de la valeur.

**Règle d'or** : toujours commencer par `package.json` + une poignée de Glob ciblés. Jamais plus de 10 fichiers lus pour la détection — on confirme la stack, on ne l'explore pas.

## Dimensions à détecter

Toute analyse pertinente doit savoir, dans l'ordre :

1. **Framework** (React/Next/Vue/Svelte/Astro/plain)
2. **UI lib** (shadcn, Radix primitives, Chakra, MUI, Mantine, Ant, HeadlessUI, aucun)
3. **Styling** (Tailwind v3, Tailwind v4 avec `@theme`, CSS-in-JS, CSS modules, vanilla)
4. **Variants engine** (cva, tailwind-variants, tv, rien)
5. **Tokens source** (config Tailwind, `@theme` CSS, tokens JSON, CSS variables, aucun)
6. **Composants location** (`src/components/ui/`, `components/`, `lib/components/`, autre)
7. **Naming convention** (kebab-case, PascalCase, BEM, mix)
8. **i18n** (next-intl, react-i18next, aucun)
9. **State management** (zustand, jotai, redux, context only)

## Procédure de détection

### Étape 1 — Lis `package.json`

C'est ta source #1. Cherche dans `dependencies` et `devDependencies` :

```js
// React ecosystem
"react" + "react-dom" → base
"next" → Next.js (check major version)
"react-router" → SPA
"vite" → Vite-based

// Vue
"vue" → Vue 3 (présume 3 si pas de ^2 explicite)
"nuxt" → Nuxt

// Svelte
"svelte" → Svelte ecosystem
"@sveltejs/kit" → SvelteKit

// Tailwind
"tailwindcss" → check version
"@tailwindcss/postcss" → v4
"@tailwindcss/typography" → prose plugin active

// UI libs
"shadcn" OR "shadcn-ui" → shadcn setup
"@radix-ui/react-*" → Radix primitives (liste lesquels)
"@chakra-ui/react" → Chakra
"@mui/material" → MUI
"@mantine/core" → Mantine
"antd" → Ant Design
"@headlessui/react" → HeadlessUI

// Variants
"class-variance-authority" → cva
"tailwind-variants" → tv
"clsx" + "tailwind-merge" → cn() pattern classique

// Animations
"framer-motion" → Framer Motion
"motion" → Motion (le successeur de Framer)

// i18n
"next-intl" → Next.js i18n
"react-i18next" → generic i18n
```

### Étape 2 — Détecte la version de Tailwind

Différence majeure v3 vs v4 → tout le reste change.

- **Présence de `@tailwindcss/postcss`** → v4
- **Présence de `tailwind.config.js/ts`** avec `content: []` → v3 (même si v4 en dépendance)
- **Présence de `@theme` dans `globals.css`** → v4 natif
- **Absence de `tailwind.config.*`** mais `"tailwindcss": "^4"` → v4 pur

**Rules différentes selon la version** :

| | v3 | v4 |
|---|---|---|
| Config source | `tailwind.config.js` | `@theme` in CSS |
| Custom colors | `theme.extend.colors` | `--color-*` in `@theme` |
| Plugins | JS plugins | CSS via `@plugin` |
| Dark mode | `darkMode: "class"` | `@custom-variant dark` |

### Étape 3 — Localise le dossier des composants

Scanne dans l'ordre :

```
src/components/ui/      ← shadcn default (très fréquent)
src/components/         ← générique
components/             ← Next simple layout
app/components/         ← Next App Router
lib/components/         ← SvelteKit
```

Note aussi les sous-dossiers par domaine :
- `components/sections/` (page sections)
- `components/layout/` (nav, footer, …)
- `components/forms/` (inputs spécialisés)

### Étape 4 — Identifie la convention de nommage

Liste les fichiers dans `ui/` (ou équivalent) :

```bash
# via Glob("src/components/ui/*.tsx")
button.tsx, input.tsx, card.tsx        → kebab-case (shadcn)
Button.tsx, Input.tsx, Card.tsx        → PascalCase (legacy / custom)
Mix des deux                           → drift à flagger
```

**Règle** :
- Si 80%+ kebab-case → convention kebab, le reste est drift
- Si 80%+ PascalCase → convention Pascal, le reste est drift
- Si 40–60% de chaque → drift majeur à signaler en 🟡

### Étape 5 — Localise la source des tokens

Dans l'ordre de priorité :

1. **`globals.css` ou `app.css`** contenant `@theme { ... }` → Tailwind v4 tokens
2. **`tailwind.config.*`** avec `theme.extend` → Tailwind v3 tokens
3. **`tokens.json` / `design-tokens.json`** → W3C DTCG natif (rare mais propre)
4. **`styles/tokens.ts` / `src/design/tokens.ts`** → TS export
5. **CSS variables dans `:root`** → bas niveau, moins structuré
6. **Aucun** → tokens hardcodés en inline, audit va trouver bcp de dette

## Matrice des règles adaptées

### Si shadcn/ui détecté

**Check spécifique** :
- Le dossier `ui/` respecte la convention kebab-case (shadcn default)
- Les composants utilisent `cn()` depuis `@/lib/utils` (pattern shadcn standard)
- `cva()` ou `tailwind-variants` utilisé pour les variants (pas des ternaires hardcodés)
- Les composants Radix (Dialog, Popover, Tooltip) sont utilisés avec `asChild` et Portal quand approprié

**Ne flagge PAS** :
- Les composants shadcn built-in ayant 20+ props (c'est leur design) — focus sur les composants custom

### Si Tailwind v4 détecté

**Check spécifique** :
- `@theme` utilisé pour custom tokens (pas `@layer base` avec custom properties)
- Pas de `tailwind.config.*` résiduel inutile
- `@custom-variant dark` si dark mode actif
- Pas de classe `class="dark:xxx"` sans variant custom déclaré

### Si Radix primitives détectés

**Check spécifique** :
- Chaque primitive Radix a son Portal associé (Dialog.Portal, Tooltip.Provider)
- Focus trap géré par Radix, pas custom
- `aria-labelledby` / `aria-describedby` correctement liés

### Si cva détecté

**Check spécifique** :
- Chaque variant défini dans `cva()` est consommé ailleurs (grep sur le nom)
- `defaultVariants` présent pour éviter un état indéterminé
- `compoundVariants` utilisé pour les combos multi-axes (pas un ternaire)

### Si Next.js App Router détecté

**Check spécifique** :
- Composants avec state/effect → `"use client"` explicite
- `next/image` utilisé (pas `<img>`)
- `next/link` utilisé (pas `<a href>` pour navigation interne)
- Metadata API utilisée (pas `<Head>`)

### Si framework non détecté (code brut React)

**Check spécifique** :
- Moins de règles, plus général
- Focus : a11y, tokens, naming, orphelins

## Output de la détection

Avant chaque audit, produis un mini-rapport de contexte **1-2 lignes** :

```markdown
**Stack détectée** : Next 16 (App Router) + Tailwind v4 + shadcn/ui + Radix primitives + cva + framer-motion.
**Convention** : kebab-case pour `src/components/ui/`, PascalCase pour `src/components/sections/`.
**Tokens** : déclarés dans `src/app/globals.css` via `@theme` + CSS custom properties dans `:root`.
```

Ça oriente le reste du rapport et montre à l'utilisateur que tu as compris le terrain.

## Ce qu'il NE faut PAS faire

- ❌ **Auditer sans détection** → tu vas flagger des patterns qui sont en fait idiomatic de la stack
- ❌ **Lire 50 fichiers pour confirmer la stack** → `package.json` + 3 Glob ciblés suffisent
- ❌ **Appliquer des règles Chakra sur du shadcn** — ce sont des écosystèmes différents
- ❌ **Ignorer Tailwind v4 vs v3** — les règles tokens changent radicalement
- ❌ **Flagger des fichiers shadcn built-in comme "god components"** — respecte leur API officielle
