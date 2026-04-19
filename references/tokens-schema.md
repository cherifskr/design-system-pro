# Tokens Schema — W3C Design Tokens (DTCG)

> Référence de format pour les design tokens. Utilisée par `/ds audit` et `/ds document` pour évaluer la cohérence, et par `/ds extend` pour proposer de nouveaux tokens.

## Pourquoi un format standard

Les tokens sont le **langage partagé** entre design (Figma) et code (CSS/Tailwind/JS). Sans standard, chaque équipe réinvente la roue et les outils ne se parlent pas.

Le **W3C Design Tokens Community Group (DTCG)** a standardisé un format JSON. Figma Tokens, Style Dictionary, et de plus en plus d'outils le supportent nativement.

## Structure d'un token

```json
{
  "color": {
    "primary": {
      "500": {
        "$value": "#1A1A1A",
        "$type": "color",
        "$description": "Couleur d'action principale"
      }
    }
  }
}
```

Règles :

- Chaque token doit avoir **`$value`** (la valeur) et **`$type`** (le type primitif)
- `$description` est optionnel mais fortement recommandé
- La structure imbriquée représente la **hiérarchie sémantique** (ex : `color.primary.500`)
- Les clés avec `$` sont réservées au format ; tout le reste est nom de token

## Les 9 types primitifs officiels

| Type | Exemple de valeur | Usage |
|---|---|---|
| `color` | `"#1A1A1A"`, `"rgb(26, 26, 26)"` | Couleurs solides |
| `dimension` | `"16px"`, `"1rem"` | Tailles, spacings, bordures |
| `fontFamily` | `["Inter", "sans-serif"]` | Pile de polices |
| `fontWeight` | `400`, `"bold"` | Graisse |
| `duration` | `"150ms"` | Durées d'animation |
| `cubicBezier` | `[0.4, 0, 0.2, 1]` | Courbes d'easing |
| `number` | `1.5` | Line-height, ratios |
| `strokeStyle` | `"solid"`, `"dashed"` | Style de bordure |
| `border` | objet composé | Bordure complète (width + style + color) |

## Tokens composites

Pour des valeurs complexes (shadow, typography, gradient), utilise un objet :

```json
{
  "shadow": {
    "md": {
      "$type": "shadow",
      "$value": {
        "color": "{color.black}",
        "offsetX": "0px",
        "offsetY": "4px",
        "blur": "12px",
        "spread": "0px"
      }
    }
  },
  "typography": {
    "heading-lg": {
      "$type": "typography",
      "$value": {
        "fontFamily": "{font.sans}",
        "fontSize": "32px",
        "fontWeight": 700,
        "lineHeight": 1.2,
        "letterSpacing": "-0.02em"
      }
    }
  }
}
```

## Références (aliases)

Un token peut **référencer** un autre via `{chemin.du.token}` :

```json
{
  "color": {
    "base": {
      "black": { "$type": "color", "$value": "#0A0A0A" }
    },
    "text": {
      "primary": { "$type": "color", "$value": "{color.base.black}" }
    }
  }
}
```

**Principe** : sépare les **primitives** (palette brute) des **sémantiques** (rôles utilisés dans l'UI).

## Hiérarchie recommandée (3 couches)

### Couche 1 — Primitives
Valeurs brutes. Jamais utilisées directement dans l'UI.

```
color.palette.blue.100
color.palette.blue.500
color.palette.blue.900
spacing.1 (4px)
spacing.2 (8px)
spacing.4 (16px)
```

### Couche 2 — Sémantiques
Rôles dans l'UI. Référence les primitives.

```
color.background = {color.palette.white}
color.foreground = {color.palette.black}
color.primary = {color.palette.blue.500}
color.primary-hover = {color.palette.blue.600}
color.destructive = {color.palette.red.500}
```

### Couche 3 — Composant (optionnel)
Tokens spécifiques à un composant. Référence les sémantiques.

```
button.primary.background = {color.primary}
button.primary.foreground = {color.background}
button.primary.hover.background = {color.primary-hover}
```

**Règle d'or** : un composant consomme **uniquement** des tokens sémantiques ou composant — **jamais** des primitives directement.

## Conventions de nommage

- **kebab-case** dans les noms, pas camelCase (compatible CSS custom properties)
- **Pluriels proscrits** : `spacing` pas `spacings`
- **Numérotation progressive** : `50, 100, 200, ..., 900` pour les échelles de couleur
- **Pas de valeurs dans le nom** : `color.primary.500` pas `color.primary-blue`

## Export vers différents outils

### CSS custom properties

```css
:root {
  --color-primary: #1a1a1a;
  --color-background: #ffffff;
  --spacing-4: 16px;
}
```

### Tailwind (v4 avec `@theme`)

```css
@theme {
  --color-primary: #1a1a1a;
  --spacing-sm: 0.5rem;
}
```

### JavaScript / TypeScript

```typescript
export const tokens = {
  color: {
    primary: "#1A1A1A",
    background: "#FFFFFF",
  },
  spacing: {
    sm: "8px",
    md: "16px",
  },
} as const;
```

Utilise **Style Dictionary** ou **Terrazzo** pour automatiser la transformation.

## Anti-patterns fréquents

- ❌ `color.darkRed` — on ne sait pas si c'est une primitive ou un rôle
- ❌ `spacing.large` — ambigu, préfère `spacing.lg` (ou chiffre)
- ❌ Un composant qui utilise `color.palette.blue.500` directement
- ❌ Plus de 3 couches de références imbriquées (coût de debug)
- ❌ Tokens hardcodés dans le code (hex, rgb) — **c'est ce que `/ds audit` traque**

## Exemple complet

Voir [templates/tokens.json](../templates/tokens.json) pour un exemple W3C DTCG valide, réutilisable comme point de départ.

## Ressources

- [W3C Design Tokens spec](https://tr.designtokens.org/format/)
- [Style Dictionary](https://amzn.github.io/style-dictionary/)
- [Terrazzo](https://terrazzo.app/)
- [Figma Tokens plugin](https://docs.tokens.studio/)
