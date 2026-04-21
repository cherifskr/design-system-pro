# `/ds tokens` — Extraction des tokens utilisés vers W3C DTCG

> Scanne ton code et extrait **tous les tokens effectivement utilisés**. Sortie `tokens.json` valide, prête à importer dans Figma Tokens Studio, Style Dictionary ou Terrazzo.

## Objectif

Tu as du code qui tourne — des couleurs, des spacings, des radii — mais pas de vrai fichier de tokens centralisé. Cette commande **extrait** ce qui est déjà utilisé et produit un JSON structuré. Point de départ ou migration vers un DS formalisé.

**Deux cas d'usage principaux** :
1. **Bootstrap** : projet sans système de tokens → cette commande te donne un fichier de départ propre
2. **Migration** : tu veux passer d'un legacy hardcoded à un vrai token system → cette commande te dit quoi mettre dans quoi

## Input

- **Par défaut** : scan `src/` entier (code + CSS + config Tailwind)
- **Explicite** : `/ds tokens src/components/` pour limiter le scope
- **Supports** :
  - `globals.css` / `app.css` (Tailwind v4 `@theme` + CSS variables dans `:root`)
  - `tailwind.config.js/ts` (Tailwind v3 `theme.extend`)
  - Code React/Vue/Svelte avec classes Tailwind
  - Inline styles (hex, rgb, rgba)
  - CSS-in-JS (styled-components, emotion)

## Process

### 1. Détection de stack (obligatoire)

Lis [references/stack-detection.md](../references/stack-detection.md) pour identifier où les tokens vivent actuellement :

- **Tailwind v4** → lis `@theme` dans `globals.css`
- **Tailwind v3** → lis `theme.extend` dans `tailwind.config.*`
- **CSS variables** → lis `:root { --* }` dans les CSS globaux
- **Aucun** → extraction uniquement depuis les hardcodes dans le code

Note ce qui est **déclaré** vs ce qui est **utilisé**. Les deux sets peuvent différer.

### 2. Collecte des valeurs

Pour chaque dimension, scanne le code et collecte TOUTES les valeurs uniques :

**Couleurs**
- Hex : `#[0-9a-fA-F]{3,8}` dans TSX/JSX + CSS
- RGB/RGBA : `rgba?\([^)]+\)`
- HSL : `hsla?\([^)]+\)`
- CSS custom properties référencées : `var(--color-*)`
- Classes Tailwind utilisées : `text-{name}`, `bg-{name}`, `border-{name}`

**Spacings**
- Pixel values : `\b\d+px\b` (ne garde que celles qui sont dans des props de spacing : padding, margin, gap, top/left/right/bottom)
- REM / EM : `\b\d+(\.\d+)?(rem|em)\b`
- Classes Tailwind : `p-{n}`, `m-{n}`, `gap-{n}`, `space-{x|y}-{n}`, etc.

**Radii**
- `border-radius: \d+(px|rem)`
- Classes Tailwind : `rounded-{none|sm|md|lg|xl|2xl|3xl|full}`
- CSS custom properties : `var(--radius-*)`

**Typography**
- `font-size`, `font-weight`, `line-height`, `letter-spacing`
- Classes Tailwind : `text-{xs|sm|base|lg|xl|...}`, `font-{normal|medium|semibold|bold}`, `leading-*`, `tracking-*`
- Font family declarations

**Shadows**
- `box-shadow:` ou Tailwind `shadow-{sm|md|lg|xl|2xl}`
- Shadow custom `shadow-[...]`

**Motion (durations & easings)**
- `transition-duration`, `animation-duration`
- Classes Tailwind : `duration-{n}`, `ease-{linear|in|out|in-out}`
- Custom bezier `cubic-bezier(...)`

### 3. Dédupliquage et groupage

Pour chaque dimension, dédoublonne et **groupe en 3 couches** W3C DTCG :

**Couche 1 — Primitives** (valeurs brutes, jamais utilisées directement dans l'UI)
```json
"color": {
  "palette": {
    "black":   { "$type": "color", "$value": "#0A0A0A" },
    "white":   { "$type": "color", "$value": "#FFFFFF" },
    "neutral-50":  { "$type": "color", "$value": "#FAFAFA" },
    "neutral-500": { "$type": "color", "$value": "#737373" }
  }
}
```

**Couche 2 — Sémantiques** (rôles UI, référencent les primitives)
```json
"color": {
  "semantic": {
    "background":        { "$type": "color", "$value": "{color.palette.white}" },
    "foreground":        { "$type": "color", "$value": "{color.palette.black}" },
    "muted-foreground":  { "$type": "color", "$value": "{color.palette.neutral-500}" }
  }
}
```

**Couche 3 — Composant** (si trouvé dans le code — `button.primary.background` etc.)

**Stratégie d'inférence sémantique** :
- `bg-white` / `bg-[#FFF]` utilisé 10+ fois → candidate `semantic.background`
- `text-neutral-900` / `text-[#1a1a1a]` sur des titres → candidate `semantic.foreground`
- `bg-red-500` / `bg-[#EF4444]` sur un destructive button → candidate `semantic.destructive`
- Si le nom d'une CSS variable existe déjà (`--primary`, `--muted`) → garde-le comme token sémantique

### 4. Génération du JSON

Utilise le template [templates/tokens.json](../templates/tokens.json) comme base structurelle.

Règles de sortie :

1. **Convention de nommage** : kebab-case pour les noms W3C (standard DTCG)
2. **Toujours un `$type`** (color, dimension, fontWeight, duration, cubicBezier, shadow, typography)
3. **Description optionnelle** mais recommandée sur les sémantiques : `"$description": "Couleur d'action primaire"`
4. **Références via `{path.to.token}`** pour les sémantiques qui pointent sur primitives
5. **Plancher : 10 couches minimum** (2 primitives + 5 semantiques + 3 composant) pour que ce soit exploitable

### 5. Production du rapport

En plus du JSON, produis un **plan de migration** en markdown :

```markdown
# Plan de migration vers tokens.json

## Ce qui a été extrait

- **24 couleurs** uniques → 8 primitives + 12 sémantiques + 4 composants spécifiques
- **11 spacings** uniques → rationnalisés sur une échelle base-4 (4, 8, 12, 16, 24, 32, 48, 64)
- **6 radii** uniques → none / sm / md / lg / xl / 2xl / full
- **4 shadows** uniques
- **3 durations** (150ms, 200ms, 300ms)

## Hardcodes à remplacer

| Fichier | Ligne | Valeur actuelle | Token proposé |
|---|---|---|---|
| `Contact.tsx` | 42 | `bg-[#1A1A1A]` | `bg-foreground` ou `bg-primary` |
| `Hero.tsx` | 104 | `text-amber-500` | `text-warning` (à créer) |
| `Testimonials.tsx` | 27-32 | 6 hex pour avatars | `bg-neutral-{500-800}` |

## Ce qui reste à décider

- [ ] Le gradient orange-pink du logo est-il un token (`color.brand.accent`) ou une exception ?
- [ ] Faut-il renommer `var(--primary)` en `--color-primary` pour aligner sur v4 ?
- [ ] Le `#F77F00` est-il un token ou une exception liée au "Made in Abidjan" badge ?

## Comment l'utiliser ensuite

1. Sauvegarde le JSON dans `design/tokens.json`
2. Importe dans Figma Tokens Studio ou Style Dictionary
3. Migre progressivement (PR par PR) les hardcodes vers les tokens
```

## Règles d'output

1. **Toujours un JSON valide.** Utilise `$type` et `$value` correctement, valide le fichier produit.
2. **Plan de migration obligatoire** en complément du JSON. Un fichier sans plan est inutile.
3. **Pas d'invention.** Si une couleur est utilisée 1 seule fois, flag-la en "exception" plutôt que la mettre dans les tokens (sinon tu pollues le set).
4. **Respect des conventions détectées.** Si le projet utilise déjà des noms comme `var(--primary)`, garde `semantic.primary` (pas `semantic.brand.primary-color`).
5. **Outputs séparés.** Un bloc de code pour le JSON, un bloc markdown pour le plan. L'utilisateur copie-colle l'un ou l'autre.

## Exemple d'invocation (auto-trigger)

L'utilisateur dit :
- « Extrais les tokens de mon code »
- « Génère mon tokens.json »
- « Je veux un fichier de tokens W3C »
- « Aide-moi à centraliser mes couleurs »

→ Lance `/ds tokens` sur le scope détecté.

## Ce qu'il NE faut PAS faire

- ❌ Inventer des tokens qui ne sont pas dans le code — extraction pas prescription
- ❌ Forcer un nommage exotique si le projet utilise déjà `primary`/`secondary` standards
- ❌ Mélanger couches primitives et sémantiques dans le JSON
- ❌ Produire le JSON sans plan de migration — l'un sans l'autre n'aide pas
- ❌ Utiliser un format autre que W3C DTCG (compatibilité Figma Tokens Studio / Style Dictionary)
