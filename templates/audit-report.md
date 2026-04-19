# Audit Design System — {{project-name}}

> Scan effectué le {{date}} par `/ds audit`
> Scope : `{{scope-path}}` · {{files-count}} fichiers analysés

## Score global : {{score}} / 100

{{score-interpretation}}
*(90+ : excellent · 70-89 : solide, quelques poches de dette · 50-69 : dette installée, action nécessaire · < 50 : refactor structurel à prévoir)*

---

## 📊 Synthèse en une page

| Dimension | État | Score |
|---|---|---|
| Accessibilité (WCAG AA) | {{a11y-status}} | {{a11y-score}} / 30 |
| Tokens & valeurs | {{tokens-status}} | {{tokens-score}} / 25 |
| Consistance naming | {{naming-status}} | {{naming-score}} / 15 |
| Documentation | {{docs-status}} | {{docs-score}} / 10 |
| Orphelins | {{orphans-status}} | {{orphans-score}} / 10 |
| Duplication | {{dup-status}} | {{dup-score}} / 10 |

---

## 🔴 Bloquant — {{blocking-count}} item(s)

*À traiter cette semaine. Impact utilisateur direct ou risque de régression.*

### 🔴 1. {{title}}

**Fichiers concernés** :
- `{{file-path}}:{{line}}` — {{context}}

**Problème** : {{what-is-wrong}}

**Impact** : {{user-impact}}

**Correction proposée** :

```diff
- {{before}}
+ {{after}}
```

**Effort** : {{effort}} (XS < 15min · S < 1h · M < demi-journée · L < journée · XL > 1 jour)

---

## 🟡 Dette — {{debt-count}} item(s)

*À planifier ce mois-ci. Incohérences, duplication, maintenance qui s'accumule.*

### 🟡 1. {{title}}

**Occurrences** : {{count}} hardcodes sur {{scope-count}} fichiers

**Détail** :
| Fichier | Ligne | Valeur actuelle | Token suggéré |
|---|---|---|---|
| `{{file}}` | {{line}} | `{{value}}` | `{{token-name}}` |

**Recommandation** : {{what-to-do}}

**Effort** : {{effort}}

---

## 🟢 Nice-to-have — {{nice-count}} item(s)

*Polish. À traiter quand tu as de la marge.*

### 🟢 1. {{title}}

{{short-description}}

**Effort** : {{effort}}

---

## 📈 Ce que je ferais cette semaine

Les 3 items qui donnent le **maximum de valeur** pour le minimum d'effort :

1. **{{item-1-title}}** ({{item-1-effort}}) — {{item-1-why}}
2. **{{item-2-title}}** ({{item-2-effort}}) — {{item-2-why}}
3. **{{item-3-title}}** ({{item-3-effort}}) — {{item-3-why}}

Total : **{{total-effort-this-week}}** pour passer de {{current-score}} à environ **{{projected-score}} / 100**.

---

## 🔍 Détails méthodologiques

### Ce qui a été scanné
- Composants : `{{components-path}}`
- Config Tailwind / tokens : `{{tokens-config-path}}`
- Globals CSS : `{{globals-path}}`

### Ce qui n'a PAS été scanné (limites)
- Tests (`*.test.*`, `*.spec.*`)
- Stories (`*.stories.*`)
- `node_modules`
- Fichiers > 1000 lignes (flagué séparément)

### Ce qui échappe à l'audit auto
Certaines dimensions nécessitent une revue humaine. Elles sont listées mais non scorées :

- [ ] Qualité des textes alternatifs (`alt`, `aria-label`)
- [ ] Comportement keyboard réel (à tester manuellement)
- [ ] Ordre de focus logique
- [ ] Annonces des screen readers
- [ ] Performance de rendu des animations
- [ ] Responsivité < 320px / > 1920px

---

*Rapport généré par [Design System Pro](https://cherifsikirou.com) · skill Claude Code*
