---
name: design-system-pro
description: Audite, documente, étend et exporte un design system comme un senior product designer. Détecte ta stack (Next, Tailwind, shadcn, Radix, cva), scanne les tokens hardcodés, les variants orphelins, les écarts WCAG AA, et produit de la doc prête à partager. Invoque-le via « audite mon design system » ou via le raccourci /ds (audit, document, extend, tokens).
---

# Design System Pro

Ce skill transforme Claude en **partenaire senior sur ton design system**. Il scanne ton code (React, Next, Vue, Svelte, Tailwind v3/v4, shadcn, CSS-in-JS), repère les incohérences qu'un humain mettrait une journée à trouver, et produit des livrables partageables avec ton équipe.

Quatre commandes, un seul principe : **consistance > créativité**.

## Comment l'invoquer

Deux façons équivalentes :

1. **Raccourci slash command** (si l'alias `/ds` est installé — voir README) :
   ```
   /ds audit
   /ds document Button
   /ds extend confirmation-dialog
   /ds tokens
   ```

2. **Langage naturel** (fonctionne toujours, même sans l'alias) :
   ```
   « Audite mon design system »
   « Documente le composant Button »
   « Propose-moi une confirmation dialog »
   « Extrais les tokens de mon code »
   ```

Claude détecte le skill automatiquement sur les mots-clés de cette description. Le raccourci `/ds` est juste un alias court pour ceux qui l'installent.

## Les 4 commandes

### `/ds audit` — diagnostic complet, stack-aware
Détecte ta stack (framework + UI libs + tokens) puis applique les checks pertinents :
- Tokens hardcodés (hex, rgb, px non-rationalisés)
- Variants cva orphelins (définis mais jamais consommés)
- Écarts WCAG AA (contraste calculé, pas juste flaggé)
- Naming drift (kebab-case vs PascalCase, Btn vs Button)
- Composants orphelins (exportés mais jamais importés)
- God-mode components (15+ props = signal de découpage)
- Duplication fonctionnelle (Card vs Tile vs Panel)
- Score /100 + plan priorisé en 3 bandes (🔴 bloquant / 🟡 dette / 🟢 polish)

→ Voir [commands/audit.md](commands/audit.md)

### `/ds document [component]` — doc prête à partager
Prend un composant en entrée (chemin ou nom), génère une doc markdown complète :
- Description + quand l'utiliser
- API (props, types, defaults)
- Variants et états
- Accessibilité (ARIA, keyboard, focus)
- Do's / Don'ts avec exemples de code
- Tokens consommés

→ Voir [commands/document.md](commands/document.md)

### `/ds extend [pattern]` — nouveau composant raisonné
Tu as un besoin ? Le skill propose un nouveau composant **avant** que tu l'écrives :
- Problème + cas d'usage
- Composants existants à réutiliser/composer
- API proposée + variants + états
- Tokens à consommer (ou à créer)
- Considérations a11y
- Questions ouvertes à trancher

→ Voir [commands/extend.md](commands/extend.md)

### `/ds tokens` — extraction vers W3C DTCG *(nouveau v0.2)*
Scanne ton code + CSS et **extrait** tous les tokens effectivement utilisés :
- Couleurs, spacings, radii, font sizes, shadows, durées d'animation
- Groupés en 3 couches W3C DTCG (primitives / sémantiques / composant)
- Sortie `tokens.json` valide, prête à importer dans Figma Tokens Studio, Style Dictionary ou Terrazzo
- Inclut un plan de migration : quel hardcode remplacer par quel token

→ Voir [commands/tokens.md](commands/tokens.md)

## Références

Le skill s'appuie sur 4 documents de référence — charge-les quand tu en as besoin :

- [references/stack-detection.md](references/stack-detection.md) *(v0.2)* — comment détecter framework, UI libs, conventions
- [references/tokens-schema.md](references/tokens-schema.md) — standard W3C Design Tokens (DTCG), format d'export
- [references/component-anatomy.md](references/component-anatomy.md) — anatomie type d'un composant pro (props, états, composition)
- [references/a11y-checklist.md](references/a11y-checklist.md) — checklist WCAG 2.1 AA par composant + patterns ARIA

## Templates de sortie

- [templates/audit-report.md](templates/audit-report.md) — structure du rapport d'audit
- [templates/component-doc.md](templates/component-doc.md) — format de doc composant
- [templates/tokens.json](templates/tokens.json) — exemple tokens W3C valides

## Principes de travail

Quand l'utilisateur lance une commande, applique ces règles :

1. **Lis avant de parler.** Commence par scanner les fichiers pertinents (Glob/Grep/Read) avant de produire quoi que ce soit. Une audit sans lecture = une opinion, pas un audit.

2. **Détecte le contexte en premier.** Avant toute analyse, identifie la stack (Next/Vue/Svelte) + UI libs (shadcn/Radix/Chakra) + conventions (kebab-case vs PascalCase) + version de Tailwind. Ça conditionne tout le reste. Voir [references/stack-detection.md](references/stack-detection.md).

3. **Sois opinioné mais factuel.** Si tu repères un problème, explique **pourquoi** c'en est un (règle violée, impact utilisateur, coût de maintenance) — pas juste « c'est pas bien ».

4. **Priorise à ta sortie.** Sépare toujours en 3 bandes : 🔴 bloquant (a11y, sécurité), 🟡 dette (incohérence, duplication), 🟢 nice-to-have.

5. **Propose, ne décide pas seul.** Pour un composant à créer ou une migration, propose 2-3 options avec leurs tradeoffs. L'équipe tranche.

6. **Termes techniques en anglais.** `token`, `variant`, `prop`, `WCAG`, `ARIA`, `focus-visible` — ce sont les noms officiels. Garde-les.

7. **Langue : FR pour la prose, EN pour le tech.** Ton lecteur est francophone mais la doc technique du monde entier est en EN. Respecte les deux.

## Quand le skill se déclenche automatiquement

Claude peut invoquer ce skill sans `/ds` explicite quand il détecte :

- L'utilisateur demande d'auditer, documenter, ou étendre un design system
- L'utilisateur mentionne « design tokens », « composants réutilisables », « variants », « theming », « WCAG », « a11y »
- L'utilisateur partage un composant React/Vue/Svelte et demande une review pro
- L'utilisateur veut migrer d'un système à un autre (v1 → v2, legacy → tokens)
- L'utilisateur veut exporter des tokens vers Figma / JSON / CSS variables

Dans le doute, propose `/ds audit` comme point de départ — c'est le plus complet.

---

**Auteur** : Chérif Sikirou — Sr Product Designer & DS Specialist
**Licence** : MIT — utilise, modifie, partage. Un backlink fait plaisir.
**Feedback** : [cherifsikirou.com/contact](https://cherifsikirou.com/#contact)
