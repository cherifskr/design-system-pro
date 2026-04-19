# Component Anatomy — Structure type d'un composant pro

> Référence d'architecture. Utilisée par `/ds document` pour structurer la doc et par `/ds extend` pour proposer des APIs cohérentes.

## Les 6 dimensions d'un composant

Tout composant pro se décrit selon 6 dimensions. Si l'une manque dans la doc, c'est un trou.

### 1. **Sémantique** — ce qu'il représente
- Un `Button` déclenche une action. Un `Link` navigue.
- Un `Alert` informe. Un `Dialog` interrompt et demande une réponse.
- **Confusion classique** : `Button` vs `Link`. Règle : si l'action change l'URL, c'est `Link` (balise `<a>`). Sinon, `Button`.

### 2. **Composition** — comment il se compose
- **Atomic** : un seul élément (Button, Input, Badge)
- **Compound** : plusieurs sous-composants coordonnés (`Card.Header`, `Card.Body`, `Card.Footer`)
- **Composite** : haute abstraction par-dessus d'autres composants (`DataTable` = Table + Pagination + Filters)

### 3. **API** — son contrat public
Définit ce que le consommateur peut/doit lui passer.

```typescript
interface ButtonProps {
  // Variations visuelles
  variant?: "primary" | "secondary" | "ghost" | "danger";
  size?: "sm" | "md" | "lg";

  // État
  disabled?: boolean;
  loading?: boolean;

  // Contenu
  children: React.ReactNode;
  icon?: React.ReactNode;
  iconPosition?: "left" | "right";

  // Comportement
  type?: "button" | "submit" | "reset";
  onClick?: (e: MouseEvent<HTMLButtonElement>) => void;

  // Accessibilité
  "aria-label"?: string;

  // Escape hatch (modération)
  className?: string;
}
```

**Règles d'API** :
- Une prop = une responsabilité
- Types **précis** (unions > `string`)
- Valeurs par défaut **explicites**
- `children` typé `ReactNode` (pas `string`)
- Autoriser `className` pour composition externe, mais avec `cn()` merge
- **Pas** de `style` inline prop (c'est une porte dérobée à la cohérence)

### 4. **Variants** — ses apparences
Les variants sont des **combinaisons cohérentes de tokens**. Pas des chaînes CSS libres.

```typescript
const buttonVariants = cva("base-classes", {
  variants: {
    variant: {
      primary: "bg-primary text-white hover:bg-primary-hover",
      secondary: "bg-foreground/5 text-foreground hover:bg-foreground/10",
      ghost: "bg-transparent hover:bg-foreground/5",
      danger: "bg-destructive text-white hover:bg-destructive-hover",
    },
    size: {
      sm: "h-8 px-3 text-xs",
      md: "h-10 px-4 text-sm",
      lg: "h-12 px-6 text-base",
    },
  },
  defaultVariants: { variant: "primary", size: "md" },
});
```

**Règles de variants** :
- Chaque variant doit être **documenté et justifié** (quand l'utiliser)
- Jamais plus de 5 variants **majeurs** par composant (au-delà, tu as 2 composants qui se cachent)
- Éviter les variants qui changent **radicalement** le layout (créer un composant séparé)

### 5. **États** — ses comportements dans le temps
Chaque composant interactif passe par un cycle d'états. Documente **tous** ceux qui s'appliquent :

| État | Trigger | Doit gérer |
|---|---|---|
| `default` | — | Rendu de base |
| `hover` | pointer over | Transition de couleur, feedback subtil |
| `focus` | keyboard focus | **Outline visible** (focus-visible) |
| `active` | mouse/tap down | Feedback tactile (scale, opacity) |
| `disabled` | prop | `aria-disabled`, non-focusable, cursor |
| `loading` | prop | `aria-busy`, spinner, bloque click |
| `error` | validation fail | Feedback visuel + texte d'erreur |
| `selected` | toggle / choix | `aria-selected` ou `aria-pressed` |
| `checked` | form | `aria-checked` |
| `readonly` | prop | Visible mais non-éditable (différent de disabled) |

**Anti-pattern** : traiter tous les états avec des classes CSS sans gérer l'ARIA correspondante.

### 6. **Accessibilité** — son contrat avec tous les utilisateurs
Voir [a11y-checklist.md](a11y-checklist.md) pour le détail.

Pour tout composant, minimum vital :
- ✅ Balise sémantique correcte (`button`, pas `div` clickable)
- ✅ Focus management (focus-visible, focus trap si modal)
- ✅ Keyboard nav (Tab, Enter, Space, Escape, flèches pour les listes)
- ✅ ARIA labels pour le contexte manquant au visuel
- ✅ Contraste WCAG AA (4.5:1 texte, 3:1 UI/icônes)
- ✅ Touch targets ≥ 44×44px sur mobile
- ✅ Pas d'info **uniquement** via la couleur (+icône, +texte)

## Les 3 composants types

### A. Composant atomique — `Button`, `Input`, `Badge`

```typescript
// button.tsx
export function Button({
  variant = "primary",
  size = "md",
  loading,
  icon,
  iconPosition = "left",
  children,
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      type={props.type ?? "button"}
      disabled={props.disabled || loading}
      aria-busy={loading}
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    >
      {loading ? <Spinner size={size} /> : null}
      {!loading && icon && iconPosition === "left" ? icon : null}
      {children}
      {!loading && icon && iconPosition === "right" ? icon : null}
    </button>
  );
}
```

Caractéristiques :
- Un seul élément DOM principal
- Props directement appliquées
- Pas d'état interne complexe
- Peut accepter `...props` pour passthrough HTML

### B. Composant compound — `Card.*`, `Tabs.*`, `Accordion.*`

```typescript
// card.tsx
export function Card({ children, className }: CardProps) { /* ... */ }
Card.Header = function CardHeader({ children }: HeaderProps) { /* ... */ };
Card.Body   = function CardBody({ children }: BodyProps) { /* ... */ };
Card.Footer = function CardFooter({ children }: FooterProps) { /* ... */ };
```

Ou avec Context pour la coordination :

```typescript
const TabsContext = createContext<TabsContextValue | null>(null);

export function Tabs({ value, onValueChange, children }: TabsProps) {
  return (
    <TabsContext.Provider value={{ value, onValueChange }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  );
}
```

Caractéristiques :
- Plusieurs sous-composants, partageant un contexte
- Le parent gère l'état, les enfants le consomment
- **Chaque sous-composant est documenté** (ou inclus dans la doc parente)

### C. Composant composite — `DataTable`, `FormField`, `CommandMenu`

Composants à haute valeur ajoutée qui orchestrent plusieurs composants de base.

Caractéristiques :
- API métier (`columns`, `data`, `filters`) plutôt que visuelle
- Coûteux à maintenir → justifier l'abstraction (au moins 3 usages)
- Documentation plus longue, avec exemples d'intégration

**Règle** : ne pas créer de composite **avant** d'avoir au moins **3 usages** concrets. Sinon tu abstrais du vent.

## Conventions de fichier

```
components/ui/
├── button.tsx            ← composant + variants + types
├── button.stories.tsx    ← Storybook (optionnel)
├── button.test.tsx       ← tests (obligatoire si composite)
└── index.ts              ← barrel exports
```

Ou pour un compound :

```
components/ui/card/
├── card.tsx
├── card-header.tsx
├── card-body.tsx
├── card-footer.tsx
├── card.stories.tsx
└── index.ts              ← re-export tout
```

## Smells à traquer (utile pour `/ds audit`)

| Smell | Signe | Correction |
|---|---|---|
| **God component** | 15+ props | Découper en compound |
| **Prop drilling** | `...props` sur plusieurs niveaux | Context ou composition |
| **Variants inflation** | 8+ variants | Deux composants qui se cachent |
| **Boolean overload** | `primary: boolean`, `danger: boolean` | Union `variant: "primary" \| "danger"` |
| **No-op ARIA** | `aria-label` vide | Supprime ou remplis |
| **`any` type** | `props: any` | Typer correctement (effort 1x, gain ∞) |
| **Inline styles** | `style={{ color: ... }}` | Token + classe |
| **Style override via `className`** | consumers overriding des classes core | Fournir des variants/slots |
