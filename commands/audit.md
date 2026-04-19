# `/ds audit` — Audit complet du design system

> Scanne le code, repère les incohérences, sort un rapport priorisé.

## Objectif

Donner à l'utilisateur une **photo honnête** de la santé de son design system, avec un plan d'action priorisé qui tient en une journée de lecture.

## Input

- **Par défaut** : `src/components/` (ou équivalent détecté via `package.json` / structure)
- **Explicite** : chemin passé par l'utilisateur (`/ds audit src/ui/`)
- **Supports** : React (.tsx, .jsx), Vue (.vue), Svelte (.svelte), Astro (.astro), CSS (.css, .scss), Tailwind config

## Process

### 1. Détection du contexte (obligatoire)

Avant toute analyse, comprends où tu es :

- Lis `package.json` → framework, UI libs (shadcn, MUI, Chakra, etc.), Tailwind version
- Cherche `tailwind.config.*`, `tokens.*`, `theme.*`, `globals.css`
- Identifie l'emplacement des composants (`src/components/`, `ui/`, `app/components/`...)
- Note la convention de nommage dominante (PascalCase, kebab-case, BEM...)

### 2. Scan structuré

Pour chaque zone, utilise Grep/Glob ciblés (pas de lecture exhaustive inutile) :

**A. Tokens hardcodés**
- Couleurs hex en dur : `#[0-9a-fA-F]{3,8}` hors fichiers de config/tokens
- RGB/RGBA en dur : `rgba?\(`
- Pixel values suspectes (non-rationnelles) : `\b\d+px\b` qui ne matchent pas l'échelle (4, 8, 12, 16, 24, 32, 48…)
- Font families hardcodées hors config
- Shadows en dur : `box-shadow:\s*\d`

**B. Variants orphelins**
- Composants dont les variants sont définis mais jamais consommés
- Utilise `grep` sur le nom de chaque variant dans le reste du code
- Cherche les `className` avec des valeurs qui ressemblent à des variants fantômes

**C. Naming drift**
- Mix kebab-case et camelCase dans les props
- Mix BEM (`card__title`) et utility (`flex items-center`) dans un même composant
- Inconsistances dans les noms : `Btn` vs `Button`, `CardHeader` vs `Card.Header`

**D. A11y gaps** (critique)
- `<button>` sans `type="button"` explicite (sous-entend submit)
- `<img>` sans `alt`
- Icon-only buttons sans `aria-label`
- Inputs sans `<label>` ou `aria-labelledby`
- `outline: none` / `outline: 0` non compensé par un focus-visible custom
- Contrastes suspects (si tu détectes un `color:` avec un `background:` proche, flag)
- Interactive elements avec `div`/`span` au lieu de `button`/`a`
- Manque de `role` sur les composants custom (dialog, tooltip, tabs)

**E. Composants orphelins**
- Composants exportés mais jamais importés (candidats à suppression)
- Composants utilisés une seule fois (candidats à inliner)

**F. Duplication**
- Composants quasi-identiques (Card vs Tile vs Panel)
- Props qui font la même chose sous des noms différents

### 3. Score sur 100

Applique cette grille :

| Zone | Poids | Bonus/Malus |
|---|---|---|
| A11y (pas d'écart bloquant) | 30 | -10 par écart bloquant |
| Tokens (aucun hardcode) | 25 | -2 par hardcode |
| Consistance naming | 15 | -5 par drift majeur |
| Documentation (JSDoc, comments) | 10 | +10 si Storybook/MDX présent |
| Pas d'orphelins | 10 | -3 par orphelin |
| Pas de duplication | 10 | -5 par duplication majeure |

Plancher à 0, plafond à 100.

### 4. Production du rapport

Utilise le template [templates/audit-report.md](../templates/audit-report.md).
Structure en 3 bandes obligatoires :

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
4. **Ton chaleureux mais honnête.** Tu rends service, pas un verdict. Mais ne sucre pas : la dette qu'on ne nomme pas reste.

## Exemple de prompt d'invocation (auto-trigger)

L'utilisateur dit :
- « Audite mon design system »
- « Vérifie la cohérence de mes composants »
- « Est-ce que mon code respecte WCAG ? »

→ Lance `/ds audit` sur le dossier détecté.

## Ce qu'il NE faut PAS faire

- ❌ Ne renomme/refactor rien **sans demander** — tu audites, tu ne corriges pas
- ❌ Ne juge pas les choix stylistiques personnels (camelCase vs snake_case) si **cohérents**
- ❌ Ne flag pas comme « a11y » ce qui est en vrai du polish visuel
- ❌ Ne produis pas un rapport de 2000 lignes : **synthétise, priorise**
