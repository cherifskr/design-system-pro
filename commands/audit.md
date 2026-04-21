# `/ds audit` — Audit complet du design system

> Scanne le code, repère les incohérences, sort un rapport priorisé — adapté à ta stack.

## Objectif

Donner à l'utilisateur une **photo honnête** de la santé de son design system, avec un plan d'action priorisé qui tient en une journée de lecture. Pas 50 pages de théorie — 10 items concrets classés par impact.

## Input

- **Par défaut** : `src/components/` (ou équivalent détecté via `package.json` / structure)
- **Explicite** : chemin passé par l'utilisateur (`/ds audit src/ui/`)
- **Supports** : React (.tsx, .jsx), Vue (.vue), Svelte (.svelte), Astro (.astro), CSS (.css, .scss), Tailwind config, CSS `@theme`

## Process

### 1. Détection de la stack (obligatoire)

Lis [references/stack-detection.md](../references/stack-detection.md) et suis la procédure complète. Résume la stack en 1-2 lignes au début du rapport :

```markdown
**Stack détectée** : Next 16 App Router + Tailwind v4 + shadcn/ui + Radix + cva + framer-motion.
**Convention** : kebab-case pour `src/components/ui/`.
**Tokens** : `src/app/globals.css` via `@theme` + CSS custom properties.
```

Les règles que tu vas appliquer dans les étapes suivantes dépendent de ce qui est détecté — pas de règle générique.

### 2. Scan structuré (adapté à la stack)

Pour chaque zone, utilise Grep/Glob ciblés (pas de lecture exhaustive inutile) :

**A. Tokens hardcodés**
- Couleurs hex en dur : `#[0-9a-fA-F]{3,8}` hors fichiers de config/tokens
- RGB/RGBA en dur : `rgba?\(`
- Pixel values suspectes (non-rationnelles) : `\b\d+px\b` qui ne matchent pas l'échelle (4, 8, 12, 16, 24, 32, 48…)
- Font families hardcodées hors config
- Shadows en dur : `box-shadow:\s*\d`

**Contexte à prendre en compte** :
- Data files (`src/data/*.ts`) avec des presets de gradients → légitime
- Inline styles de PDF / export (ex: `DiagnosticReport.tsx`) → légitime (PDF ne supporte pas CSS vars)
- `theme-color` meta dans `layout.tsx` → légitime (browser UI theming)
- Fallbacks dynamiques (`color ?? "#525252"`) → légitime (defensive coding)

**B. Variants orphelins (si cva ou tv détecté)**
- Parse chaque appel à `cva(` / `tv(` → extrait les keys dans `variants`
- Pour chaque variant, grep sur `variant="<name>"` OU `size="<name>"` dans le reste du code
- Flag ceux qui ont 0 usage → orphans

**C. Naming drift**
- Mix kebab-case et camelCase dans les props d'un même fichier
- Mix BEM (`card__title`) et utility (`flex items-center`) dans un même composant
- Fichiers `ui/` qui ne respectent pas la convention dominante (voir détection étape 1)
- Inconsistances dans les noms : `Btn` vs `Button`, `CardHeader` vs `Card.Header`

**D. A11y gaps** (critique — lis [references/a11y-checklist.md](../references/a11y-checklist.md))
- `<button>` sans `type="button"` explicite hors d'un `<form>`
- `<img>` sans `alt` (rare avec Next Image qui l'enforce)
- Icon-only buttons sans `aria-label`
- Inputs sans `<label>` ou `aria-labelledby`
- `outline: none` / `outline-none` non compensé par un focus ring
- **Contraste à calculer** : si un même selector a `color:` + `background-color:`, calcule le ratio via la formule WCAG (voir a11y-checklist)
- Interactive elements avec `div`/`span` au lieu de `button`/`a`
- Manque de `role` sur les composants custom (dialog, tooltip, tabs)
- Composants Radix utilisés sans leur Portal approprié

**E. Composants orphelins**
- Composants exportés mais jamais importés (candidats à suppression)
- Composants utilisés une seule fois (candidats à inliner ou flagger pour réusage futur)
- Check à faire via grep sur le nom du composant dans tout le `src/`

**F. God-mode components**
- Composants dont l'interface a **15+ props** → signal de découpage nécessaire
- **Exception** : respecte les composants shadcn/Radix built-in, leur API riche est voulue
- Composants avec 5+ props boolean → union `variant: "a" | "b"` serait mieux

**G. Duplication fonctionnelle**
- Composants quasi-identiques (Card vs Tile vs Panel)
- Props qui font la même chose sous des noms différents dans deux composants
- Custom components qui dupliquent un composant shadcn existant

**H. Documentation**
- Présence de Storybook (`*.stories.tsx`) → bonus de score
- Présence de JSDoc sur les exports principaux → bonus
- Absence totale de commentaires sur composants complexes (> 200 lignes) → malus

### 3. Score sur 100

Applique cette grille :

| Zone | Poids | Bonus/Malus |
|---|---|---|
| A11y (pas d'écart bloquant) | 30 | -10 par écart bloquant |
| Tokens (aucun hardcode hors légitime) | 25 | -2 par hardcode non-légitime |
| Consistance naming | 15 | -5 par drift majeur |
| Documentation (JSDoc, comments) | 10 | +5 si Storybook présent, +5 si JSDoc systématique |
| Pas d'orphelins | 10 | -3 par orphelin |
| Pas de duplication | 10 | -5 par duplication majeure |

Plancher à 0, plafond à 100.

### 4. Production du rapport

Utilise le template [templates/audit-report.md](../templates/audit-report.md).

Structure en 3 bandes **obligatoires** :

- 🔴 **Bloquant** — a11y, sécurité, casses utilisateur réelles
- 🟡 **Dette** — incohérences, duplication, maintenance qui s'accumule
- 🟢 **Nice-to-have** — polish, conventions qui pourraient être plus strictes

Pour chaque item :
- Le problème (1 phrase)
- Les fichiers/lignes concernés
- Pourquoi c'est un problème (impact concret)
- La correction proposée (extrait de code avant/après si possible)
- L'effort estimé (XS = 15min, S = 1h, M = demi-journée, L = journée, XL = plusieurs jours)

## Règles d'output

1. **Jamais d'audit en aveugle.** Si le dossier scanné fait < 5 fichiers, le dis-tu à l'utilisateur et propose un scope plus large.
2. **Toujours une conclusion.** Termine par « Ce que je ferais cette semaine » : les 3 items à tacler en premier, pas plus.
3. **Chiffres concrets.** « 12 hardcodes sur 47 fichiers » bat « beaucoup de hardcodes ».
4. **Contexte avant jugement.** Ne flagge pas comme bug ce qui est idiomatic de la stack (Radix, shadcn, Next Image…).
5. **Ton chaleureux mais honnête.** Tu rends service, pas un verdict. Mais ne sucre pas : la dette qu'on ne nomme pas reste.

## Exemple de prompt d'invocation (auto-trigger)

L'utilisateur dit :
- « Audite mon design system »
- « Vérifie la cohérence de mes composants »
- « Est-ce que mon code respecte WCAG ? »
- « Review mon dossier ui/ »

→ Lance `/ds audit` sur le dossier détecté.

## Ce qu'il NE faut PAS faire

- ❌ Ne renomme/refactor rien **sans demander** — tu audites, tu ne corriges pas
- ❌ Ne juge pas les choix stylistiques personnels (camelCase vs snake_case) si **cohérents**
- ❌ Ne flag pas comme « a11y » ce qui est en vrai du polish visuel
- ❌ Ne produis pas un rapport de 2000 lignes : **synthétise, priorise**
- ❌ Ne flagge pas les composants shadcn built-in comme god-mode (leur API riche est voulue)
- ❌ Ne mélange pas les règles Tailwind v3 et v4 — une seule version par projet
