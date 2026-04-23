---
description: Invoke the design-system-pro skill — audit, document, extend, extract tokens, diff or export rules from a design system. Type /ds help for the full menu.
argument-hint: "[help | audit | document <component> | extend <pattern> | tokens | diff <before> <after> | rules]"
---

Charge et exécute le skill **design-system-pro** installé dans `~/.claude/skills/design-system-pro/`.

Instructions :

1. Lis d'abord `~/.claude/skills/design-system-pro/SKILL.md` pour charger le contexte du skill et ses principes de travail.

2. Interprète le premier mot de `$ARGUMENTS` comme commande :
   - `help` **ou sans argument** → lis `~/.claude/skills/design-system-pro/commands/help.md` et affiche le menu d'aide formaté
   - `audit` → lis `~/.claude/skills/design-system-pro/commands/audit.md` et applique la procédure d'audit sur le projet courant
   - `document <component>` → lis `~/.claude/skills/design-system-pro/commands/document.md` et produis la documentation du composant demandé
   - `extend <pattern>` → lis `~/.claude/skills/design-system-pro/commands/extend.md` et propose un nouveau composant raisonné
   - `tokens` → lis `~/.claude/skills/design-system-pro/commands/tokens.md` et extrais les tokens utilisés sous forme de JSON W3C DTCG
   - `diff <before> <after>` → lis `~/.claude/skills/design-system-pro/commands/diff.md` et compare deux DESIGN.md ou deux rapports d'audit (détecte tokens added/removed/modified, breaking changes, régressions)
   - `rules` → lis `~/.claude/skills/design-system-pro/commands/rules.md` et exporte la spec des règles de lint (markdown ou JSON, injectable dans un autre prompt d'agent)

3. Si la procédure référence les guides (`references/*.md`), les templates (`templates/*.md`) ou les tutoriels (`docs/*.md`), **lis-les à la demande** — ne charge pas tout d'un coup.

4. Respecte les 7 principes de travail définis dans SKILL.md :
   - Lis avant de parler
   - Détecte le contexte (stack) en premier
   - Sois opinioné mais factuel
   - Priorise en 3 bandes (🔴 bloquant / 🟡 dette / 🟢 nice-to-have)
   - Propose, ne décide pas seul
   - Termes tech en anglais
   - FR pour la prose, EN pour le tech

Argument passé par l'utilisateur : `$ARGUMENTS`
