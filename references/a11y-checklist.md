# A11y Checklist — WCAG 2.1 AA par composant

> Référence pour les vérifications d'accessibilité. Utilisée par `/ds audit` pour flagger les écarts, et par `/ds extend` pour générer une spec a11y dès la proposition.

## Règles de base (s'appliquent à tout)

### 1. Contraste des couleurs (WCAG 1.4.3)

| Contenu | Ratio minimum AA | Ratio AAA (bonus) |
|---|---|---|
| Texte normal (< 18pt ou < 14pt bold) | **4.5 : 1** | 7 : 1 |
| Texte large (≥ 18pt ou ≥ 14pt bold) | **3 : 1** | 4.5 : 1 |
| Éléments d'interface (borders, icônes) | **3 : 1** | — |
| Texte désactivé | aucune exigence | — |

**Outils** : WebAIM Contrast Checker, extension axe DevTools, `colorjs.io`.

#### Formule WCAG (à appliquer dans `/ds audit` quand possible)

Le contraste entre 2 couleurs se calcule via leur **luminance relative**.

**Étape 1 — Luminance relative de chaque couleur** :

```
Pour une couleur RGB avec r, g, b en [0, 1] :

  R = r ≤ 0.03928 ? r / 12.92 : ((r + 0.055) / 1.055) ^ 2.4
  G = g ≤ 0.03928 ? g / 12.92 : ((g + 0.055) / 1.055) ^ 2.4
  B = b ≤ 0.03928 ? b / 12.92 : ((b + 0.055) / 1.055) ^ 2.4

  L = 0.2126 × R + 0.7152 × G + 0.0722 × B
```

**Étape 2 — Ratio de contraste** :

```
  ratio = (L_clair + 0.05) / (L_sombre + 0.05)
```

Où `L_clair` est la luminance de la couleur la plus claire et `L_sombre` celle de la plus sombre. Le ratio est toujours ≥ 1.

**Exemples** :
- `#1A1A1A` sur `#FFFFFF` → ratio ≈ **15.7:1** ✅ AAA
- `#737373` sur `#FFFFFF` → ratio ≈ **4.54:1** ✅ AA pile-poil
- `#A3A3A3` sur `#FFFFFF` → ratio ≈ **2.86:1** ❌ échec AA
- `#F59E0B` sur `#FFFFFF` → ratio ≈ **2.3:1** ❌ pas suffisant pour du texte

**Quand l'appliquer dans l'audit** :
Dans un scan `/ds audit`, quand tu détectes dans un même fichier/bloc un `color:` et un `background-color:` (ou leur équivalent Tailwind : `text-*` + `bg-*` sur un même composant), résous les hex (via les tokens déclarés si possible), applique la formule, et flag si le ratio est < 4.5 pour du texte normal.

Ne pas inventer de valeur si une des couleurs est dynamique (`var(--x)` non résolue, accent couleur passée en prop) — dans ce cas flag en 🟡 "à vérifier manuellement".

### 2. Focus visible (WCAG 2.4.7)

- Chaque élément focusable **doit** montrer un indicateur de focus clair
- L'outline par défaut est **acceptable**. Le supprimer sans remplacement = violation.
- Préférer `:focus-visible` (seulement au clavier, pas au clic souris)

```css
/* ✅ Bon */
.button:focus-visible {
  outline: 2px solid var(--color-focus);
  outline-offset: 2px;
}

/* ❌ Mauvais */
.button:focus { outline: none; }
```

### 3. Zones tactiles (WCAG 2.5.5 AAA, recommandé en AA)

- Taille minimum **44×44 CSS px** pour les cibles tactiles
- Espacement entre cibles ≥ 8px

### 4. Information pas uniquement par la couleur (WCAG 1.4.1)

- Un champ en erreur → **texte + icône** en plus du rouge
- Un lien dans du texte → **souligné** en plus de la couleur
- Un graphique → **labels directs** ou légende non-colorée

### 5. Taille de texte redimensionnable (WCAG 1.4.4)

- Le texte doit rester lisible jusqu'à **200%** de zoom sans perte de contenu
- Utiliser `rem` / `em` plutôt que `px` figés

### 6. Landmarks & structure (WCAG 1.3.1)

- Un seul `<h1>` par page
- Hiérarchie de headings **sans sauter** (pas de h2 → h4)
- Landmarks sémantiques : `<header>`, `<nav>`, `<main>`, `<aside>`, `<footer>`

## Par composant

### Button

- ✅ Élément `<button>` (pas `<div onClick>`)
- ✅ `type="button"` explicite si pas dans un form (sinon submit par défaut)
- ✅ `aria-label` si icon-only
- ✅ `aria-busy="true"` en loading
- ✅ `disabled` natif → non-focusable, non-clickable
- ✅ Focus visible (ring 2px au minimum)
- Keyboard : `Enter`, `Space` → click
- Contraste texte / fond ≥ 4.5 : 1

### Link

- ✅ Élément `<a href>` (pas `<span onClick>`)
- ✅ Liens externes → `target="_blank"` + `rel="noopener noreferrer"`
- ✅ Liens externes annoncés (icône + `aria-label` complet, ou texte `(external)`)
- ✅ Pas deux liens différents avec le **même texte** (« En savoir plus » → précise quoi)
- Couleur **et** soulignement (pas uniquement la couleur)

### Input / Textarea

- ✅ `<label>` associé via `htmlFor` (pas juste un placeholder)
- ✅ `placeholder` **en plus** du label, jamais en remplacement
- ✅ `required` → `aria-required="true"` + indicateur visuel (`*`)
- ✅ `invalid` → `aria-invalid="true"` + message d'erreur via `aria-describedby`
- ✅ Autocomplete renseigné (`autocomplete="email"`, `"name"`, `"tel"`)
- ✅ Type HTML correct (`email`, `tel`, `url`, `number`)
- Keyboard : curseur visible, sélection native fonctionnelle

### Select / Combobox

- ✅ Si `<select>` natif → OK automatiquement
- ✅ Si custom → pattern ARIA Combobox (complexe, utiliser Radix/Headless UI)
- ✅ Navigation : flèches haut/bas, `Enter` pour sélectionner, `Escape` pour fermer
- ✅ Label associé
- ✅ Option sélectionnée annoncée

### Checkbox / Radio

- ✅ `<input type="checkbox">` / `<input type="radio">` natif
- ✅ `<label>` cliquable (toute la zone)
- ✅ État indéterminé (`indeterminate`) géré si applicable (via JS)
- ✅ Groupes radio → `<fieldset>` + `<legend>`
- Keyboard : `Space` pour checkbox, flèches pour radio group

### Dialog / Modal

- ✅ `role="dialog"` (ou `"alertdialog"` si action importante/destructive)
- ✅ `aria-labelledby` pointe sur le titre
- ✅ `aria-describedby` pointe sur la description (si présente)
- ✅ `aria-modal="true"`
- ✅ **Focus trap** : Tab reste dans le modal
- ✅ **Focus initial** : premier élément focusable, ou le bouton d'annulation pour les alertdialog
- ✅ **Focus retour** : au trigger quand le modal se ferme
- ✅ `Escape` ferme (sauf si l'utilisateur doit absolument choisir)
- ✅ Click overlay ferme (optionnel, désactiver pour alertdialog)
- ✅ Scroll derrière bloqué
- ✅ Contenu derrière `inert` ou `aria-hidden="true"` (les readers ignorent)

**Recommandation forte** : utiliser Radix Dialog ou Headless UI — trop facile de se tromper à la main.

### Tooltip

- ✅ Déclenché au **hover ET focus** (pas que hover)
- ✅ Dismissable : `Escape` ferme
- ✅ Persistant : reste ouvert si la souris entre dedans (pour lire des liens à l'intérieur)
- ✅ `role="tooltip"` + `aria-describedby` depuis le trigger
- ✅ **Jamais** de contenu interactif dans un tooltip (utiliser Popover)
- ✅ Délai d'apparition raisonnable (> 500ms) pour éviter le flicker

### Dropdown / Menu

- ✅ `role="menu"` + `role="menuitem"` sur les items
- ✅ Navigation flèches (haut/bas)
- ✅ `Escape` ferme et retourne le focus au trigger
- ✅ `Enter` / `Space` active l'item focusé
- ✅ `aria-haspopup="menu"` sur le trigger
- ✅ `aria-expanded` reflète l'état ouvert/fermé
- Focus géré automatiquement (premier item à l'ouverture)

### Tabs

- ✅ `role="tablist"` + `role="tab"` + `role="tabpanel"`
- ✅ `aria-selected` sur le tab actif
- ✅ `aria-controls` pointe sur le panel associé
- ✅ Navigation flèches gauche/droite entre tabs
- ✅ `Tab` déplace vers le panel, pas vers le tab suivant
- ✅ Un seul tab dans la tab order (`tabIndex=0`), les autres `tabIndex=-1`

### Accordion

- ✅ `<button>` pour le déclencheur (pas `<div>`)
- ✅ `aria-expanded` sur le bouton
- ✅ `aria-controls` pointe sur le panel
- ✅ Panel visible pour les readers même replié (`hidden` vs `display: none` selon la lib)
- Keyboard : `Enter` / `Space` toggle

### Toast / Notification

- ✅ `role="status"` pour notification neutre (polite)
- ✅ `role="alert"` pour urgence (assertive, interrompt le reader)
- ✅ `aria-live` approprié (polite/assertive)
- ✅ Durée d'affichage **≥ 5 secondes** (ou contrôlée par l'utilisateur)
- ✅ Bouton de fermeture toujours disponible si persistant

### Image

- ✅ `alt` obligatoire sur `<img>`
- ✅ `alt=""` pour images décoratives (vide, mais présent)
- ✅ `alt` descriptif pour images informatives (ce que l'image apporte en info)
- ✅ Icônes SVG inline → `aria-hidden="true"` si décoratives, `<title>` si informatives
- ✅ Charts / diagrammes → texte alternatif ou tableau de données

### Form (global)

- ✅ Chaque input avec label explicite
- ✅ Messages d'erreur associés via `aria-describedby`
- ✅ Résumé d'erreurs en haut du form si long (avec liens vers les champs)
- ✅ Bouton submit clair (texte descriptif, pas juste « Envoyer »)
- ✅ Feedback de succès annoncé via `role="status"`

## Patterns ARIA à connaître (WAI-ARIA Authoring Practices)

Référence : [w3.org/WAI/ARIA/apg/patterns/](https://www.w3.org/WAI/ARIA/apg/patterns/)

Les patterns suivants ont des règles **complexes** — utiliser Radix, Headless UI, Reach, ou React Aria :

- Combobox
- Dialog (Modal) & Alert Dialog
- Disclosure
- Listbox
- Menu & Menubar
- Radio Group
- Slider
- Tabs
- Treeview

## Auto-check dans `/ds audit`

Le skill scanne automatiquement pour :

- `<div>` ou `<span>` avec `onClick` → flag
- `<img>` sans `alt` → flag
- `<button>` sans texte ni `aria-label` → flag
- `outline: none` / `outline: 0` sans compensation → flag
- `<input>` sans label associé → flag
- Contraste texte : analyse les combos `color` + `background-color` proches

Ce qui **ne peut pas** être détecté automatiquement (nécessite une revue manuelle) :

- Qualité des textes alternatifs (`alt="image"` vs `alt="Graphique de revenus mensuels"`)
- Pertinence des labels ARIA
- Comportement keyboard réel (il faut tester)
- Annonces des screen readers en contexte
- Ordre de focus logique

→ `/ds audit` flagge ces zones comme **« à revoir manuellement »**.

## Ressources

- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [WebAIM WCAG Quick Reference](https://webaim.org/standards/wcag/checklist)
- [A11y Project Checklist](https://www.a11yproject.com/checklist/)
- [axe DevTools (extension Chrome)](https://www.deque.com/axe/devtools/)
- [Accessible Components library (react-aria)](https://react-spectrum.adobe.com/react-aria/)
