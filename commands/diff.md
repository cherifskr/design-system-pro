# `/ds diff` — Compare deux états du design system

> Détecte les évolutions et les régressions entre deux versions d'un DS — tokens ajoutés/supprimés/modifiés, sévérité globale, breaking changes pour les composants consommateurs.

## Objectif

Donner à l'utilisateur la **réponse à la question #1 quand il itère sur
un DS** : "qu'est-ce que j'ai changé, et est-ce que j'ai cassé quelque
chose ?" Sans `/ds diff`, on doit ouvrir deux audits côte à côte et
chercher visuellement.

## Input

`/ds diff` accepte deux arguments (dans cet ordre) :

- `before` — le `DESIGN.md` ou le rapport d'audit JSON **de référence**
  (état souhaité, snapshot précédent, version mainline)
- `after` — le `DESIGN.md` ou le rapport JSON **à valider** (PR en
  cours, nouvelle version, état actuel)

Modes acceptés :

| Mode | Input A | Input B | Détecte |
|:--|:--|:--|:--|
| `tokens` | `DESIGN.md` v1 | `DESIGN.md` v2 | Tokens ajoutés/supprimés/modifiés |
| `findings` | rapport JSON v1 | rapport JSON v2 | Findings résolus, nouveaux, persistants |
| `auto` (défaut) | n'importe lequel | n'importe lequel | Détecte le type par contenu |

Exemples d'invocation :

```
/ds diff DESIGN.md DESIGN-v2.md
/ds diff audit-2026-04-01.json audit-2026-04-23.json
/ds diff main:DESIGN.md HEAD:DESIGN.md     # via git stash
```

## Process

### 1. Détection du mode

Lis les 5 premières lignes des deux fichiers :

- Commencent par `---` → DESIGN.md (mode `tokens`)
- Commencent par `{` et contiennent `"findings":` → rapport audit JSON (mode `findings`)
- Mix → erreur explicite, demande à l'utilisateur de clarifier

### 2. Mode `tokens` — diff de DESIGN.md

Parse les deux YAML front matter et compare **par section** :

**Pour chaque section** (`colors`, `typography`, `spacing`, `rounded`, `components`) :

```json
{
  "added": ["<token-name>"],
  "removed": ["<token-name>"],
  "modified": [
    {
      "path": "<token-name>",
      "before": "<value>",
      "after": "<value>"
    }
  ]
}
```

**Détecte les breaking changes** :

| Type | Breaking ? | Pourquoi |
|:--|:--|:--|
| Token ajouté | ❌ non | Additif, sans impact |
| Token supprimé | ✅ **oui** | Tout consommateur casse |
| Couleur modifiée | ⚠️ visual-breaking | Pas un crash, mais identité altérée |
| Typography size modifiée | ⚠️ layout-breaking | Peut décaler les conteneurs |
| Spacing modifié | ⚠️ layout-breaking | Casse l'alignement existant |
| Composant supprimé | ✅ **oui** | Tout usage casse |
| Référence cassée (`{colors.X}` pointe vers rien) | ✅ **oui** | Lint error |

**Pour chaque breaking change** : si possible, grep dans le scope
courant pour identifier les fichiers consommateurs et les lister
explicitement.

### 3. Mode `findings` — diff d'audits

Parse les deux blocs `findings[]` et catégorise chaque finding :

| Catégorie | Définition |
|:--|:--|
| **Resolved** ✅ | Présent dans `before`, absent dans `after` (corrigé) |
| **New** 🆕 | Absent dans `before`, présent dans `after` (introduit) |
| **Persistent** ➖ | Présent dans les deux (non traité) |

Calcule la **régression globale** :

```
regression = (errors_after > errors_before)
          OR (warnings_after > warnings_before AND errors_after >= errors_before)
```

Rappelle aussi le **delta de score** entre les deux audits si présent.

### 4. Production du rapport

Structure markdown obligatoire :

```markdown
# /ds diff — {{before-name}} → {{after-name}}

> Mode : {{tokens|findings}} · Comparé le {{date}}

## Verdict

{{✅ Compatible | ⚠️ Visual change | 🔴 Breaking}}
{{1 phrase qui explique le verdict}}

## Tokens (mode tokens uniquement)

### ➕ Ajoutés ({{n}})
- `colors.accent` = `#FF5733`

### ➖ Supprimés ({{n}}) 🔴
- `colors.legacy-blue` (utilisé dans **3 fichiers** — voir ci-dessous)

### 🔄 Modifiés ({{n}})
| Token | Avant | Après | Type |
|---|---|---|---|
| `colors.primary` | `#1A1C1E` | `#0D0E0F` | visual-breaking |
| `spacing.md` | `16px` | `12px` | layout-breaking |

## Findings (mode findings uniquement)

| Catégorie | Errors | Warnings | Info |
|---|---|---|---|
| ✅ Resolved | {{n}} | {{n}} | {{n}} |
| 🆕 New | {{n}} | {{n}} | {{n}} |
| ➖ Persistent | {{n}} | {{n}} | {{n}} |

### 🆕 Nouvelles régressions
- `hardcoded-color` · `Button.tsx:42` — `#FFF` introduit
- ...

### ✅ Corrigés (à fêter)
- `a11y-contrast` · `Toast.tsx:18` — contraste 3.1:1 → 5.4:1

## Impact sur les consommateurs (breaking changes uniquement)

Pour chaque token supprimé ou breaking-modifié, liste les fichiers à mettre à jour :

- `colors.legacy-blue` :
  - `src/components/Header.tsx:12`
  - `src/app/page.tsx:34`
  - `src/styles/legacy.css:8`

## Migration suggérée

{{Si applicable, propose un patch/diff de migration : remplacer
`legacy-blue` par `primary`, ajuster les paddings impactés…}}
```

### 5. Bloc JSON machine-readable

À la fin du rapport, inclus systématiquement :

```json
{
  "version": "0.4",
  "mode": "tokens" | "findings",
  "regression": true | false,
  "verdict": "compatible" | "visual-change" | "breaking",
  "tokens": {
    "colors": { "added": [], "removed": [], "modified": [] },
    "typography": { "added": [], "removed": [], "modified": [] },
    "spacing": { "added": [], "removed": [], "modified": [] },
    "rounded": { "added": [], "removed": [], "modified": [] },
    "components": { "added": [], "removed": [], "modified": [] }
  },
  "findings": {
    "resolved": [],
    "new": [],
    "persistent": []
  },
  "consumers": [
    { "token": "<name>", "files": ["<path:line>"] }
  ]
}
```

C'est la même forme que `design.md diff` de Google — interopérable
si l'utilisateur veut chaîner avec leur CLI.

## Règles d'output

1. **Verdict en premier**, avant tous les détails. L'utilisateur veut savoir s'il peut merger ou pas.
2. **Breaking changes en rouge, en haut.** Ne les noie pas dans une liste de "modifications".
3. **Toujours lister les consommateurs** d'un breaking change si tu as accès au codebase. Sinon, le dis (« scope non scanné, impact non évalué »).
4. **Pas d'opinion sur les changements de couleur** au-delà du flag `visual-breaking` — c'est un choix de marque, pas un bug.
5. **Si zéro changement → réponds en 1 ligne** : « Aucun changement détecté entre {{before}} et {{after}}. » Pas de rapport vide.

## Exemple de prompt d'invocation (auto-trigger)

L'utilisateur dit :
- « Compare mon ancien et mon nouveau DS »
- « Qu'est-ce qui a changé entre v1 et v2 ? »
- « Est-ce que ma PR casse le DS ? »
- « Diff entre DESIGN.md et DESIGN-v2.md »

→ Lance `/ds diff` sur les deux fichiers détectés.

## Ce qu'il NE faut PAS faire

- ❌ Ne suggère pas de **réécrire** un token modifié — l'utilisateur l'a fait exprès, ton rôle est de **rapporter**.
- ❌ Ne flag pas les ajouts comme « risqués » — ils sont additifs.
- ❌ Ne fusionne pas tokens + findings dans le même mode — l'utilisateur passe l'un OU l'autre, pas les deux.
- ❌ Ne fais pas un diff ligne-à-ligne du markdown — la prose est commentée par le YAML, pas l'inverse. Concentre-toi sur les **tokens** et les **findings**.
