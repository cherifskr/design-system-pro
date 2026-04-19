# {{ComponentName}}

> {{one-line-description}}

## Quand l'utiliser

- {{use-case-1}}
- {{use-case-2}}
- {{use-case-3}}

### Quand utiliser autre chose

- Pour {{alternative-case-1}} → utiliser [`{{alternative-component-1}}`]({{link}})
- Pour {{alternative-case-2}} → utiliser [`{{alternative-component-2}}`]({{link}})

---

## API

| Prop | Type | Default | Description |
|---|---|---|---|
| `{{prop}}` | `{{type}}` | `{{default}}` | {{description}} |
| `{{prop}}` | `{{type}}` | `{{default}}` | {{description}} |

### Types exportés

```typescript
{{typescript-types}}
```

---

## Variants

### `variant="{{variant-1}}"`

{{variant-1-description}}

```tsx
<{{ComponentName}} variant="{{variant-1}}">
  {{example-content}}
</{{ComponentName}}>
```

### `variant="{{variant-2}}"`

{{variant-2-description}}

```tsx
<{{ComponentName}} variant="{{variant-2}}">
  {{example-content}}
</{{ComponentName}}>
```

---

## États

| État | Trigger | Comportement |
|---|---|---|
| `default` | — | {{default-behavior}} |
| `hover` | pointer over | {{hover-behavior}} |
| `focus` | keyboard focus | {{focus-behavior}} |
| `disabled` | prop `disabled` | {{disabled-behavior}} |
| `loading` | prop `loading` | {{loading-behavior}} |

---

## Accessibilité

### Checklist

- ✅ {{a11y-check-1}}
- ✅ {{a11y-check-2}}
- ✅ {{a11y-check-3}}

### Keyboard

| Touche | Action |
|---|---|
| {{Key}} | {{action}} |
| {{Key}} | {{action}} |

### ARIA

- `role="{{role}}"` (si applicable)
- `aria-{{attr}}={{value}}` (si {{condition}})

---

## Exemples

### Usage basique

```tsx
import { {{ComponentName}} } from "@/components/ui/{{component-name}}";

export function Example() {
  return (
    <{{ComponentName}} {{minimal-props}}>
      {{content}}
    </{{ComponentName}}>
  );
}
```

### Avec icône

```tsx
{{example-with-icon}}
```

### Dans un formulaire

```tsx
{{example-in-form}}
```

### Composition avancée

```tsx
{{example-composition}}
```

---

## Do's & Don'ts

### ✅ À faire

- ✅ {{do-1}}
- ✅ {{do-2}}
- ✅ {{do-3}}

### ❌ À éviter

- ❌ {{dont-1}}
- ❌ {{dont-2}}
- ❌ {{dont-3}}

---

## Tokens consommés

Référence : [tokens-schema.md](../references/tokens-schema.md)

- `{{token-path}}` — {{role}}
- `{{token-path}}` — {{role}}
- `{{token-path}}` — {{role}}

---

## Sous-composants

*(Si compound — sinon supprimer cette section)*

- [`{{ComponentName}}.Header`](#header) — {{subcomponent-description}}
- [`{{ComponentName}}.Body`](#body) — {{subcomponent-description}}
- [`{{ComponentName}}.Footer`](#footer) — {{subcomponent-description}}

---

## Décisions de design

{{design-notes}}

---

## Évolution future

{{future-considerations}}

---

*Documentation générée par `/ds document` · [Design System Pro](https://cherifsikirou.com)*
*Dernière mise à jour : {{date}}*
