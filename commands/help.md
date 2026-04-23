# `/ds help` — Menu d'aide

> Affiche un menu formaté avec toutes les commandes, leurs exemples et les prochaines étapes.

## Objectif

Quand l'utilisateur tape `/ds help` (ou juste `/ds` sans argument), afficher une sortie **claire, scannable, utile** — pas une simple liste de commandes.

## Process

Produis **un bloc markdown rich** avec la structure suivante :

### Section 1 — Identité du skill (2-3 lignes)

Nom, pitch, version. Exemple :

```
# design-system-pro — Claude Code skill

> Audit, documente, étend et exporte ton design system comme un senior
> product designer. Version 0.3.0 — par Chérif Sikirou.
```

### Section 2 — Les 6 commandes, avec exemples

Pour chaque commande, produis un bloc :

- **Syntaxe** (ce que l'utilisateur tape)
- **Ce que ça fait** (1 phrase)
- **Quand l'utiliser** (1 phrase, contextualisé)
- **Un exemple concret** (la commande complète)
- **Durée moyenne** d'exécution (2-5 min pour audit, 1-2 min pour document, etc.)

Format :

```markdown
## 🔍 `/ds audit` — scan complet du DS

**Ce que ça fait** : Détecte ta stack, trouve les tokens hardcodés,
les variants cva orphelins, les écarts WCAG AA, le naming drift.
Sort un score /100 et un plan d'action en 3 bandes (🔴🟡🟢).

**Quand l'utiliser** : avant chaque sprint planning, après un gros
refactor, quand tu arrives sur un projet legacy.

**Exemple** :
    /ds audit                        # scan par défaut (src/components/)
    /ds audit src/components/ui/     # scope précis

**Durée** : 2-5 min
**Tutorial** : voir ~/.claude/skills/design-system-pro/docs/first-audit.md
```

Fais-le pour `audit`, `document`, `extend`, `tokens`, `diff`, `rules`.

Pour `diff` et `rules` *(nouveau v0.4)* :

```markdown
## 🔀 `/ds diff` — compare deux états du DS

**Ce que ça fait** : compare deux `DESIGN.md` (ou deux rapports d'audit
JSON) et détecte tokens ajoutés/supprimés/modifiés, breaking changes,
régressions de findings.

**Quand l'utiliser** : avant de merger une PR qui touche le DS, après
une refonte, pour valider qu'une migration ne casse rien.

**Exemple** :
    /ds diff DESIGN.md DESIGN-v2.md
    /ds diff audit-before.json audit-after.json

**Durée** : < 1 min

## 📜 `/ds rules` — exporte la spec des règles

**Ce que ça fait** : sort la liste des règles de lint utilisées par
`/ds audit` (markdown ou JSON), injectable dans le prompt système d'un
autre agent (Cursor, Copilot) ou commitable au repo comme contrat
partagé.

**Quand l'utiliser** : pour partager les règles avec ton équipe, pour
configurer un autre agent, pour générer un fichier `DS-RULES.md`.

**Exemple** :
    /ds rules
    /ds rules --format json
    /ds rules --severity error

**Durée** : instantané
```

### Section 3 — Comment invoquer sans `/ds`

Rappel : le skill se déclenche aussi en langage naturel. Donne 3 exemples de phrases qui activent automatiquement le skill :

- « Audite mon design system »
- « Documente le composant Button »
- « Extrais les tokens utilisés dans mon code »

### Section 4 — Ressources pour aller plus loin

Liste les docs internes :

- **Tutorials pas-à-pas** : `~/.claude/skills/design-system-pro/docs/`
  - `first-audit.md` — ton premier audit
  - `document-component.md` — documenter un composant
  - `extend-pattern.md` — proposer un nouveau pattern
  - `extract-tokens.md` — extraire les tokens
- **Références** : `~/.claude/skills/design-system-pro/references/`
  - `stack-detection.md`, `tokens-schema.md`, `a11y-checklist.md`, `component-anatomy.md`
- **GitHub** : [github.com/cherifskr/design-system-pro](https://github.com/cherifskr/design-system-pro)
- **Feedback** : contact@cherifsikirou.com

### Section 5 — Suggestion de prochaine action

Termine par une suggestion claire. Choisis selon le contexte si tu peux deviner (ex : si l'utilisateur vient d'installer le skill → suggère `/ds audit`) :

```markdown
---

**Première fois ?** Commence par `/ds audit` — 2 min, donne une
photo honnête de la santé de ton DS.

**Déjà l'habitude ?** Dis-moi simplement ce que tu veux faire et
je lance la bonne commande.
```

## Règles d'output

1. **Pas plus de 1 écran de terminal** quand c'est affiché proprement. Scannable, pas exhaustif.
2. **Toujours avec emojis d'ancrage** (🔍 audit, 📝 document, ✨ extend, 🎨 tokens) — aide à la lecture rapide.
3. **Pas de lorem ipsum ni de placeholder.** Les exemples doivent être réalistes.
4. **Une phrase par bénéfice, pas deux.** C'est un menu, pas une doc exhaustive.
5. **Terminer par une action claire** — ne laisse pas l'utilisateur en suspens.

## Ce qu'il NE faut PAS faire

- ❌ Ne produis pas la doc complète de chaque commande ici — renvoie vers `docs/*.md` pour les détails
- ❌ Ne répète pas les règles de travail du SKILL.md — c'est un menu d'aide, pas une charte
- ❌ Ne mets pas de section "principes de travail" ici — l'utilisateur veut savoir **quoi taper**, pas comment toi tu penses
- ❌ Ne force pas l'utilisateur à choisir parmi 12 options — 4 commandes + 1 suggestion d'action
