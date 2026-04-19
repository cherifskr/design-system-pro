# `/ds extend <pattern>` — Nouveau composant raisonné

> Propose un composant **avant** de le coder. Prévient le chaos.

## Objectif

Quand l'utilisateur a un besoin (« j'ai besoin d'une confirmation modale »), ne **pas** sauter sur le code. D'abord :

1. Vérifier qu'un composant existant ne répond pas déjà au besoin
2. Proposer 2-3 options avec tradeoffs
3. Une fois validé, produire l'API cible + tokens + a11y — pas le code final

Le but est d'**éviter l'explosion de composants quasi-identiques** qui tue les DS à moyen terme.

## Input

- **Pattern nommé** : `/ds extend confirmation-dialog`
- **Besoin en langage naturel** : `/ds extend "je veux afficher un avertissement avant suppression"`
- **Sans argument** : demande la nature du besoin

## Process

### 1. Recherche dans l'existant (obligatoire)

**Ne saute jamais cette étape.** Scanne le projet :

- Liste tous les composants existants (Glob sur `components/` + composants UI)
- Cherche des noms proches du besoin (`Dialog`, `Modal`, `Alert`, `Confirm`, `Warning`)
- Lis ceux qui matchent et évalue s'ils répondent (avec ajustements mineurs) au besoin

Si un composant existe déjà → **propose de l'étendre** plutôt que d'en créer un nouveau. C'est le chemin par défaut.

### 2. Cadrage du besoin

Si le pattern est flou, pose 3-5 questions max à l'utilisateur :

- Quelle action déclenche ce composant ?
- C'est bloquant ou informationnel ?
- Doit-il retourner une valeur (choix binaire, saisie) ?
- Contexte d'usage : desktop, mobile, les deux ?
- Fréquence d'usage attendue (rare, fréquent) ?

### 3. Comparaison des options

Présente **2 ou 3 options** (pas plus), chacune avec :

- **Nom proposé** (suivant les conventions du projet)
- **API** grossière (props principales)
- **Pros** : ce que l'option apporte
- **Cons** : ce qu'elle coûte
- **Cas où elle gagne** : quand la préférer

Exemple pour « confirmation avant suppression » :

| Option | Type | Pros | Cons |
|---|---|---|---|
| A. Étendre `Dialog` avec variant `confirm` | Composition | Réutilise le focus trap existant, 1 seul composant à maintenir | Dialog devient plus complexe |
| B. Nouveau `ConfirmDialog` dédié | Spécialisation | API ultra-simple (`onConfirm`, `onCancel`) | Duplication partielle avec Dialog |
| C. Hook `useConfirm()` + Dialog | Logique + UI séparées | Ergonomie dev maximale (`const ok = await confirm(...)`) | Introduit un pattern async dans le DS |

Annonce ta **recommandation** et attends validation avant de détailler.

### 4. Spécification détaillée (après choix)

Une fois l'option choisie, produis :

#### Nom + emplacement
- `components/ui/ConfirmDialog.tsx` (suivre la convention détectée)

#### API complète

```typescript
interface ConfirmDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  title: string;
  description?: string;
  confirmLabel?: string; // default: "Confirmer"
  cancelLabel?: string;  // default: "Annuler"
  variant?: "default" | "danger"; // default
  onConfirm: () => void | Promise<void>;
  loading?: boolean;
}
```

#### Variants & états

| Variant | Usage | Couleur primaire |
|---|---|---|
| `default` | Confirmations neutres | `color.primary.500` |
| `danger` | Actions destructives | `color.destructive.500` |

États : idle / loading (bloque fermeture) / error (affiche retour)

#### Tokens consommés

Référence [references/tokens-schema.md](../references/tokens-schema.md) :

- `color.background` / `color.foreground`
- `color.destructive.500` (variant danger)
- `spacing.6` (padding intérieur)
- `radius.2xl`
- `shadow.xl`
- `motion.duration.short` (150ms entrée/sortie)

#### Accessibilité (obligatoire)

Référence [references/a11y-checklist.md](../references/a11y-checklist.md) :

- ✅ Focus trap à l'ouverture (via Radix ou headless lib)
- ✅ Focus rendu au trigger à la fermeture
- ✅ `Escape` ferme la dialog
- ✅ `role="alertdialog"` (pas `dialog`) car action importante
- ✅ `aria-labelledby` pointe sur `title`
- ✅ `aria-describedby` pointe sur `description` si présent
- ✅ Focus initial sur le **bouton d'annulation** (prévient accidents)
- ✅ Overlay bloque les interactions arrière (pointer-events)
- ✅ Pas de scroll derrière quand ouvert

#### Composition / dépendances

- Utilise `<Dialog>` existant comme base (Radix)
- Utilise `<Button>` existant avec `variant="danger"` pour le variant danger
- N'ajoute **pas** de dépendance externe

#### Questions ouvertes à trancher

Liste honnête des décisions que tu n'as pas prises :
- Doit-on supporter un 3e bouton « Plus tard » ? (flex : peu de dialogs réels l'utilisent)
- Input de confirmation type « Tapez SUPPRIMER pour confirmer » → Phase 2 ?
- i18n des labels par défaut → extraire vers un `config` du DS ?

## Règles d'output

1. **Pas de code final.** La sortie de `/ds extend` est une **spec**, pas une implémentation. Propose l'écriture comme étape suivante séparée : « Je peux maintenant l'implémenter, tu valides ? »

2. **Comparaison obligatoire.** Même si tu es sûr de la meilleure option, présente toujours 2+ alternatives. Le dev doit comprendre le **pourquoi** du choix.

3. **Chercher avant de créer.** Si l'audit révèle que 80% du besoin est couvert par un composant existant, dis-le franchement et propose l'extension.

4. **Honnêteté sur les questions ouvertes.** Ne pas faire semblant de tout savoir. Un spec qui liste ses incertitudes est plus utile qu'une spec magique.

## Ce qu'il NE faut PAS faire

- ❌ Écrire le composant direct sans valider la direction
- ❌ Proposer une seule option (c'est un diktat, pas une aide)
- ❌ Ignorer l'existant (« je vais créer un nouveau ») sans justification
- ❌ Ajouter des props « au cas où » — YAGNI. On ajoute quand le besoin arrive.
- ❌ Dupliquer un composant pour éviter un refactor (c'est le péché mortel des DS)
