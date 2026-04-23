---
version: alpha
name: {{project-name}}
description: {{one-line-description-of-the-brand-personality}}
colors:
  primary: "{{#hex}}"
  secondary: "{{#hex}}"
  tertiary: "{{#hex}}"
  neutral: "{{#hex}}"
  surface: "{{#hex}}"
  on-surface: "{{#hex}}"
  error: "{{#hex}}"
typography:
  headline-lg:
    fontFamily: {{family}}
    fontSize: {{size}}
    fontWeight: {{weight}}
    lineHeight: {{lineHeight}}
    letterSpacing: {{tracking}}
  headline-md:
    fontFamily: {{family}}
    fontSize: {{size}}
    fontWeight: {{weight}}
    lineHeight: {{lineHeight}}
  body-md:
    fontFamily: {{family}}
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.6
  body-sm:
    fontFamily: {{family}}
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
  label-md:
    fontFamily: {{family}}
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1
    letterSpacing: 0.05em
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 32px
  xl: 64px
rounded:
  none: 0px
  sm: 4px
  md: 8px
  lg: 12px
  full: 9999px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.md}"
    padding: 12px
  button-primary-hover:
    backgroundColor: "{colors.tertiary}"
  button-secondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: 12px
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    rounded: "{rounded.sm}"
    padding: 10px
---

# {{project-name}} — Design System

> Auto-généré par `/ds audit`. Format compatible
> [`@google/design.md`](https://github.com/google-labs-code/design.md) —
> lint-able via `npx @google/design.md lint DESIGN.md`.

## Overview

{{2-3 phrases qui décrivent la personnalité de marque, le public cible, et la
réponse émotionnelle visée. Exemple : "Architectural Minimalism meets
Journalistic Gravitas. L'UI évoque un magazine premium — typographie
généreuse, palette restreinte, accents rares mais décisifs."}}

## Colors

{{Phrase d'intro qui explique la stratégie de palette : haute contraste vs
nuancée, rôle de chaque couleur, cohérence avec la marque.}}

- **Primary ({{#hex}}):** {{rôle UI — exemple : "Encre profonde pour les
  titres et le texte principal, garantit lisibilité maximale."}}
- **Secondary ({{#hex}}):** {{rôle utilitaire — bordures, captions,
  metadata}}
- **Tertiary ({{#hex}}):** {{accent unique pour l'interaction — boutons
  primaires, liens actifs}}
- **Neutral ({{#hex}}):** {{fond — chaud ou froid, organique ou clinique}}
- **Surface / On-surface :** {{cartes et conteneurs élevés}}
- **Error :** {{messages d'erreur, validation négative}}

## Typography

{{Stratégie : combien de familles, quelle hiérarchie. Exemple : "Deux
familles — Public Sans pour la narration, Space Grotesk pour les données
techniques."}}

- **Headlines (headline-lg, headline-md) :** {{rôle — titres de page,
  sections}}
- **Body (body-md, body-sm) :** {{rôle — paragraphes, descriptions}}
- **Labels (label-md) :** {{rôle — boutons, badges, metadata UPPERCASE
  letter-spaced}}

## Layout

{{Modèle de grille (fluid, fixed-max-width), unité de base, breakpoints.
Exemple : "Grille fluide mobile, fixed-max 1200px desktop. Échelle 8px
stricte avec demi-pas 4px pour micro-ajustements."}}

## Elevation & Depth

{{Stratégie de hiérarchie visuelle : ombres tonales, bordures, contraste
de couleur. Exemple : "Tonal Layers plutôt qu'ombres lourdes. Surface = 1
niveau au-dessus du background, jamais de double élévation."}}

## Shapes

{{Langage de forme : sharpness, rondeur, mix. Exemple : "Architectural
Sharpness — radius minimal de 4px sur les éléments interactifs, pas de
formes organiques."}}

## Components

{{Pour chaque composant majeur du DS, une phrase qui explique son rôle et
ses contraintes. Les tokens exacts vivent dans le YAML front matter
ci-dessus.}}

- **Buttons :** primaire (action principale, 1 max par écran), secondaire
  (action neutre), tertiaire (action discrète).
- **Inputs :** label au-dessus, helper text dessous, état d'erreur avec
  bordure `colors.error`.
- {{ajouter Cards, Dialogs, Tooltips, etc. selon le scope du DS}}

## Do's and Don'ts

- ✅ **Do** utiliser `colors.tertiary` uniquement pour l'action principale
  d'un écran.
- ✅ **Do** maintenir un contraste WCAG AA (4.5:1 pour le texte normal).
- ❌ **Don't** mélanger `rounded.sm` et `rounded.lg` dans le même
  composant.
- ❌ **Don't** introduire une police hors `headline-*` / `body-*` /
  `label-*` sans valider via le DS.
- ❌ **Don't** hardcoder de couleur hex dans le code — passer par un
  token sémantique.
