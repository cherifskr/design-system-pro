# `/ds rules` — Exporter la spec des règles

> Sort la liste structurée des règles de lint utilisées par `/ds audit` — injectable dans n'importe quel autre prompt d'agent (Cursor, Copilot, Codex…) ou commitable au repo comme contrat partagé.

## Objectif

Faire de **tes règles d'audit un artefact portable**. Aujourd'hui elles
vivent dans `commands/audit.md` et sont implicites pour les outils
externes. Avec `/ds rules`, l'utilisateur peut :

- les coller dans le prompt système d'un autre agent
- les commiter à la racine de son projet (`DS-RULES.md`) pour que
  toute revue de code les applique
- les diffuser à son équipe comme charte

## Input

```
/ds rules                       # markdown, toutes les règles
/ds rules --format json         # JSON structuré
/ds rules --severity error      # filtre par sévérité
/ds rules --rule a11y-contrast  # détail d'une règle précise
```

| Option | Type | Default | Description |
|:--|:--|:--|:--|
| `--format` | `markdown` \| `json` | `markdown` | Format de sortie |
| `--severity` | `error` \| `warning` \| `info` | — | Filtre par sévérité |
| `--rule` | `<rule-name>` | — | Sort le détail d'une seule règle |

## Process

### 1. Source de vérité

Les règles vivent dans [commands/audit.md](audit.md), section "Format des
findings". Lis cette table comme source unique. **Ne dupliques pas la
liste** dans la sortie — réfère-la.

### 2. Sortie markdown (défaut)

```markdown
# Design System Lint Rules

> Règles appliquées par `design-system-pro` v0.4. Référence partageable.

## Sévérité

- **error** — bloquant, casse utilisateur ou écart WCAG AA.
- **warning** — dette, à planifier dans le mois.
- **info** — polish, à traiter quand on a de la marge.

## Règles

### `a11y-contrast` (error)
Ratio de contraste calculé entre `color` et `background-color` d'un même
sélecteur (formule WCAG relative-luminance). Échec si < 4.5:1 (texte
normal) ou < 3:1 (texte large ≥ 18pt ou ≥ 14pt bold).

**Override** : autorisé si l'élément est purement décoratif
(`aria-hidden="true"`) — ajouter `reason: "decorative"`.

### `a11y-label-missing` (error)
Élément interactif sans label accessible : `<button>` icon-only sans
`aria-label`, `<input>` sans `<label>` ni `aria-labelledby`, custom
control sans rôle ARIA et label.

### `a11y-focus-removed` (error)
`outline: none` ou `outline-none` (Tailwind) sans focus ring de
remplacement (`focus-visible:ring`, `focus:outline`). Casse la
navigation au clavier.

### `a11y-semantic` (warning)
Élément interactif construit avec `<div>`/`<span>` au lieu de `<button>`
ou `<a>`. Acceptable pour les composants Radix qui forwardent leur
sémantique correcte.

### `hardcoded-color` (warning)
Couleur hex (`#xxx`, `#xxxxxx`) ou rgb/rgba en dur dans le code, hors
des fichiers de tokens (`tailwind.config.*`, `globals.css` `@theme`,
`tokens.json`).

**Override** : légitime dans un export PDF (CSS vars non supportées),
dans un fichier `data/*.ts` de presets, ou dans un fallback défensif
(`color ?? "#525252"`). Ajouter `reason`.

### `hardcoded-spacing` (warning)
Pixel value qui ne matche pas l'échelle de spacing détectée (typique :
4/8/12/16/24/32/48/64). Suggère un token sémantique à la place.

### `hardcoded-typography` (warning)
`font-family` ou `font-size` en valeur littérale dans un composant, hors
config Tailwind / CSS `@theme`.

### `orphan-variant` (warning)
Variant `cva(…)` ou `tv(…)` défini mais aucun usage trouvé via
`variant="<name>"` ou `size="<name>"` dans le scope.

### `god-component` (warning)
Composant avec 15+ props **ou** 5+ props booléennes — signal de
découpage en sous-composants ou union `variant`.

**Override** : composants shadcn/Radix built-in (leur API riche est voulue).

### `duplicated-component` (warning)
Composants quasi-identiques détectés par signature de props (ex : `Card`
vs `Tile` vs `Panel`). À fusionner ou à renommer pour clarifier l'intent.

### `naming-drift` (info)
Mix de conventions dans une même zone : kebab-case ↔ camelCase pour les
props, abréviations incohérentes (`Btn` vs `Button`), structure dot vs
underscore (`Card.Header` vs `CardHeader`).

### `orphan-export` (info)
Composant exporté mais aucun import trouvé dans le projet. Candidat à
suppression ou à inliner.

## Format des findings

Chaque règle produit des findings au format :

\```json
{
  "rule": "<rule-name>",
  "severity": "error" | "warning" | "info",
  "path": "<file>:<line>",
  "message": "<one-line factual description>",
  "reason": "<optional — only when severity was overridden>"
}
\```

## Comment utiliser ce fichier

- **Avec un autre agent** (Cursor, Copilot Chat, Codex) : colle le
  contenu dans le prompt système, l'agent appliquera les mêmes règles
  qu'un audit `/ds audit`.
- **En contrat de PR** : commit ce fichier à `.cursor/rules/ds-rules.md`
  ou `.github/copilot-instructions.md`.
- **En CI** : combine avec `npx @google/design.md lint DESIGN.md` pour
  obtenir un check déterministe sur le YAML front matter.

---

*Généré par `/ds rules` — design-system-pro v0.4*
```

### 3. Sortie JSON (`--format json`)

```json
{
  "version": "0.4",
  "rules": [
    {
      "name": "a11y-contrast",
      "severity": "error",
      "category": "accessibility",
      "description": "Ratio de contraste WCAG entre color et background-color < 4.5:1 (texte normal) ou < 3:1 (texte large).",
      "overridable": true,
      "validReasons": ["decorative"]
    }
  ],
  "findingsSchema": {
    "rule": "string",
    "severity": "error | warning | info",
    "path": "string (file:line OR token-path OR component-name)",
    "message": "string",
    "reason": "string (optional)"
  }
}
```

### 4. Mode `--rule <name>`

Si l'utilisateur demande une règle précise, sors **uniquement** son
bloc complet (description + override + exemples avant/après).
Pas de wrapping markdown.

### 5. Mode `--severity <level>`

Filtre la liste pour ne garder que les règles dont la sévérité par
défaut matche. Garde le wrapping markdown standard.

## Règles d'output

1. **Toujours daté et versionné.** Inclus la version du skill et la
   date — un agent qui consomme cette spec doit pouvoir la stamper.
2. **Pas d'invention.** Si une règle n'est pas dans `commands/audit.md`,
   elle n'apparaît pas dans `/ds rules`. Source unique.
3. **Markdown valide DESIGN.md-friendly.** Si tu sors du markdown, qu'il
   soit lisible par un humain ET par un agent qui le parse.
4. **Mentionne les overrides.** Une règle sans override possible est
   rare — sois explicite quand c'est le cas.

## Exemple de prompt d'invocation (auto-trigger)

L'utilisateur dit :
- « Sort tes règles de lint »
- « Donne-moi la spec des règles `/ds audit` »
- « Je veux configurer Cursor pour qu'il applique tes règles »
- « Exporte les règles en JSON »

→ Lance `/ds rules` avec le format adéquat.

## Ce qu'il NE faut PAS faire

- ❌ Ne ré-écrits pas une nouvelle table de règles à chaque appel —
  utilise la même que `audit.md`.
- ❌ Ne propose pas de règles "potentielles" non implémentées.
- ❌ Ne mélange pas les principes de travail du SKILL.md avec les règles
  de lint — ce sont deux choses différentes.
