# `/ds document <component>` — Documentation composant

> Génère une doc complète d'un composant, prête à partager.

## Objectif

Produire une documentation markdown **autonome** pour un composant donné, utilisable telle quelle dans Notion, Storybook MDX, ou un site de doc DS. Elle doit répondre à 4 questions :

1. **Quand** l'utiliser (et quand ne pas)
2. **Comment** l'utiliser (API, exemples)
3. **Comment** il se comporte (variants, états, accessibilité)
4. **Pourquoi** il existe (décisions de design)

## Input

- **Nom** : `/ds document Button` → cherche `Button.tsx` / `button.vue` / `Button.svelte` dans le projet
- **Chemin** : `/ds document src/components/ui/Button.tsx` → lit direct
- **Sans argument** : demande à l'utilisateur quel composant documenter, ou propose les 5 plus utilisés

## Process

### 1. Localisation

- Si input = nom → Glob `**/${name}.{tsx,jsx,vue,svelte,astro}` exclude `node_modules`, tests, stories
- Si plusieurs matches, propose le choix à l'utilisateur (ne devine pas)
- Si 0 match, demande s'il veut `/ds extend` (créer le composant)

### 2. Extraction (lecture obligatoire)

Lis le fichier et ses voisins (barrel `index.ts`, styles associés). Extrais :

- **Nom exporté** + alias éventuels
- **Props** : chaque prop, son type, sa valeur par défaut, sa description (JSDoc)
- **Variants** : via `cva`, `tailwind-variants`, props discriminées, switch interne
- **États** : hover, focus, active, disabled, loading, error (via classes, pseudo-sélecteurs)
- **Tokens consommés** : couleurs, spacings, typos référencés
- **Dépendances** : autres composants du DS utilisés (composition)
- **Accessibilité** : aria-*, role, tabIndex, gestion focus, keyboard handlers
- **Dark mode** : classes `dark:`, conditional rendering

### 3. Production

Utilise [templates/component-doc.md](../templates/component-doc.md).

Sections obligatoires :

#### Description
Une phrase. « Le `Button` est un élément d'action primaire ou secondaire, avec 4 variants et 3 tailles. »

#### Quand l'utiliser
- 3 à 5 cas d'usage concrets
- **Alternatives** : quand prendre un `Link`, `IconButton`, `MenuItem` à la place

#### API
Tableau markdown :

| Prop | Type | Default | Description |
|---|---|---|---|
| `variant` | `"primary" \| "secondary" \| "ghost" \| "danger"` | `"primary"` | Style visuel du bouton |

- Une ligne par prop
- Valeurs typées **précisément** (union, pas `string`)
- Description 1 phrase

#### Variants & états
- Tableau ou grille visuelle
- Un aperçu code pour chaque variant majeur

#### Accessibilité
Checklist concrète :
- ✅ Bouton sémantique `<button>`
- ✅ `aria-label` obligatoire si icon-only
- ✅ `focus-visible` avec ring 2px
- ✅ État `disabled` gère `aria-disabled` et bloque l'event
- ✅ Loading state annonce via `aria-busy`
- Keyboard : `Space`, `Enter` → click. `Tab` → focus, `Shift+Tab` → reverse

#### Exemples de code
- **Usage basique** : 3-5 lignes
- **Composition** : avec icône, avec loading state, avec variant custom
- **Intégration form** : avec `form`, `type="submit"`

#### Do's / Don'ts
- ✅ « Utilise `variant="danger"` pour les actions destructives (delete, logout) »
- ❌ « N'imbrique pas un `<Button>` dans un autre `<Button>` »
- Minimum 3 Do + 3 Don't

#### Tokens consommés
Liste les tokens utilisés (référence [references/tokens-schema.md](../references/tokens-schema.md)) :
- `color.primary.500` (background)
- `color.primary.700` (hover)
- `spacing.3` (padding-y)

#### Décisions de design (optionnel mais recommandé)
Notes sur pourquoi certains choix ont été faits. Exemple :
> On a choisi `rounded-full` pour les boutons primaires pour cohérence avec le CTA principal du site. Les boutons secondaires restent `rounded-lg` pour créer une hiérarchie visuelle.

## Règles d'output

1. **Une doc par composant, une seule.** Si le fichier exporte plusieurs composants (Card + Card.Header + Card.Body), documente le **parent** et liste les sous-composants dans une section dédiée.

2. **Pas de bullshit.** Si tu ne peux pas inférer une prop (pas de JSDoc, nom obscur), **demande à l'utilisateur** plutôt que d'inventer.

3. **Extraits de code authentiques.** Copie les bons extraits depuis le code lu, ne génère pas d'exemples fantaisistes.

4. **Prévoir l'export.** Ajoute à la fin un bloc `---` avec date + auteur (par défaut « Généré via /ds document ») pour traçabilité.

5. **Dark mode ignoré → mentionne-le.** Si le composant n'a aucune classe `dark:`, indique dans la section a11y/decisions : « Ce composant ne supporte pas le dark mode — à considérer si le produit le propose. »

## Ce qu'il NE faut PAS faire

- ❌ Inventer des props qui n'existent pas dans le code
- ❌ Documenter les détails d'implémentation (nom de variable interne) — doc = contrat public
- ❌ Omettre la section a11y, même si tu n'as rien trouvé d'exceptionnel
- ❌ Faire 20 sections verbeuses : un dev doit pouvoir **scanner en 30 secondes**
