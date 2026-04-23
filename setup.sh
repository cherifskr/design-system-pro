#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# design-system-pro — one-line installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/cherifskr/design-system-pro/main/setup.sh | bash
#
# Or if you've already cloned the repo somewhere, run:
#   ./setup.sh
#
# What it does:
#   1. Installs the skill into ~/.claude/skills/design-system-pro/
#   2. Registers the /ds slash command at ~/.claude/commands/ds.md
#   3. Prints next steps
#
# Safe to re-run: it clobbers the previous install, preserving only
# files you might have added locally (nothing to preserve by default).
# ─────────────────────────────────────────────────────────────────────

set -euo pipefail

SKILL_NAME="design-system-pro"
REPO_URL="https://github.com/cherifskr/${SKILL_NAME}.git"
SKILL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"
CMD_DIR="${HOME}/.claude/commands"
CMD_FILE="${CMD_DIR}/ds.md"

# ANSI colors (fall back to empty if not supported)
if [ -t 1 ]; then
  BOLD=$'\033[1m'
  DIM=$'\033[2m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  BLUE=$'\033[34m'
  RESET=$'\033[0m'
else
  BOLD="" DIM="" GREEN="" YELLOW="" BLUE="" RESET=""
fi

step() { echo "${BLUE}▸${RESET} ${BOLD}$1${RESET}"; }
ok() { echo "  ${GREEN}✓${RESET} $1"; }
warn() { echo "  ${YELLOW}!${RESET} $1"; }

# Pull the top [x.y.z] entry out of a CHANGELOG.md file. Silent return
# (empty string) if the file is missing or doesn't match the format.
get_version() {
  local file="$1"
  [ -f "$file" ] || { echo ""; return; }
  grep -E '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$file" | head -1 \
    | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/'
}

# Detect an already-installed version BEFORE we clobber it, so the
# banner can say "upgrading from x.y.z" instead of a silent rewrite.
PREVIOUS_VERSION="$(get_version "${SKILL_DIR}/CHANGELOG.md")"

echo ""
echo "${BOLD}design-system-pro — Claude Code skill${RESET}"
echo "${DIM}by Chérif Sikirou · cherifsikirou.com${RESET}"
echo ""

# ── 1. Install the skill ──────────────────────────────────────────
if [ -n "${PREVIOUS_VERSION}" ]; then
  step "Upgrading skill (currently v${PREVIOUS_VERSION})"
else
  step "Installing skill into ${SKILL_DIR/$HOME/~}"
fi

mkdir -p "${HOME}/.claude/skills"

# If the script is run from inside a cloned repo, copy locally.
# Otherwise, clone fresh from GitHub.
if [ -f "./SKILL.md" ] && [ -d "./commands" ] && [ -d "./references" ]; then
  # Running from inside the repo — copy files.
  rm -rf "${SKILL_DIR}"
  mkdir -p "${SKILL_DIR}"
  cp -R ./SKILL.md ./commands ./references ./templates ./LICENSE ./README.md "${SKILL_DIR}/" 2>/dev/null || true
  [ -f ./CHANGELOG.md ] && cp ./CHANGELOG.md "${SKILL_DIR}/"
  [ -d ./docs ] && cp -R ./docs "${SKILL_DIR}/"
  [ -d ./slash ] && cp -R ./slash "${SKILL_DIR}/"
  ok "Skill files copied from local clone"
else
  # Clone fresh from GitHub.
  if [ -d "${SKILL_DIR}" ]; then
    if [ -n "${PREVIOUS_VERSION}" ]; then
      warn "Removing v${PREVIOUS_VERSION} before upgrade"
    else
      warn "Skill already installed — removing old version"
    fi
    rm -rf "${SKILL_DIR}"
  fi
  git clone --depth 1 "${REPO_URL}" "${SKILL_DIR}" > /dev/null 2>&1
  ok "Skill cloned from GitHub"
fi

NEW_VERSION="$(get_version "${SKILL_DIR}/CHANGELOG.md")"
if [ -n "${NEW_VERSION}" ] && [ -n "${PREVIOUS_VERSION}" ] && [ "${NEW_VERSION}" != "${PREVIOUS_VERSION}" ]; then
  ok "Upgraded v${PREVIOUS_VERSION} → v${NEW_VERSION}"
elif [ -n "${NEW_VERSION}" ]; then
  ok "Installed v${NEW_VERSION}"
fi

# ── 2. Register the /ds slash command ─────────────────────────────
step "Registering /ds slash command"

mkdir -p "${CMD_DIR}"

if [ -f "${CMD_FILE}" ]; then
  warn "Existing /ds command detected — overwriting"
fi

# Write the slash command file. Note the heredoc preserves the YAML
# frontmatter and the placeholder for $ARGUMENTS — we intentionally
# quote 'EOF' so Bash doesn't interpolate anything.
cat > "${CMD_FILE}" <<'EOF'
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

4. Respecte les 7 principes de travail définis dans SKILL.md.

Argument passé par l'utilisateur : `$ARGUMENTS`
EOF

ok "/ds command registered at ${CMD_FILE/$HOME/~}"

# ── 3. Done — next steps ──────────────────────────────────────────
echo ""
echo "${GREEN}${BOLD}✓ Installation complete${RESET}"
echo ""
echo "${BOLD}─── Next step — restart Claude Code ────────────────────────${RESET}"
echo ""
echo "  Close and reopen Claude Code so it picks up the new skill"
echo "  and the ${BOLD}/ds${RESET} command."
echo ""
echo "${BOLD}─── Start with one command ─────────────────────────────────${RESET}"
echo ""
echo "  ${GREEN}${BOLD}/ds help${RESET}   ${DIM}# shows the full menu with examples${RESET}"
echo ""
echo "  Or jump straight to:"
echo ""
echo "  ${BOLD}/ds audit${RESET}                          ${DIM}# scan your whole DS${RESET}"
echo "    └─ Detects your stack, finds hardcoded tokens,"
echo "       WCAG AA gaps, orphan variants, naming drift."
echo "       Scores /100 + prioritized 🔴 🟡 🟢 action plan."
echo ""
echo "  ${BOLD}/ds document Button${RESET}                ${DIM}# generate full component doc${RESET}"
echo "    └─ Extracts API, variants, states, a11y. Outputs"
echo "       markdown ready for Notion/Storybook/your team Slack."
echo ""
echo "  ${BOLD}/ds extend confirmation-dialog${RESET}     ${DIM}# reasoned new component spec${RESET}"
echo "    └─ Proposes 2-3 options with tradeoffs before you"
echo "       write a single line of code. You validate the direction."
echo ""
echo "  ${BOLD}/ds tokens${RESET}                         ${DIM}# extract used tokens → tokens.json${RESET}"
echo "    └─ Scans your code + CSS and outputs a valid W3C DTCG"
echo "       tokens.json you can import in Figma Tokens Studio."
echo ""
echo "  ${BOLD}/ds diff DESIGN.md DESIGN-v2.md${RESET}    ${DIM}# detect breaking changes (new in v0.4)${RESET}"
echo "    └─ Compares two DESIGN.md or two audit JSON reports."
echo "       Verdict in 1 line: ✓ Compatible / ⚠ Visual / ✗ Breaking."
echo ""
echo "  ${BOLD}/ds rules${RESET}                          ${DIM}# export the 12 lint rules (new in v0.4)${RESET}"
echo "    └─ Markdown or JSON spec — drop in Cursor / Copilot / CI"
echo "       to enforce the same checks across your team."
echo ""
echo "${BOLD}─── Tip — natural language works too ───────────────────────${RESET}"
echo ""
echo "  The skill auto-triggers on phrases like:"
echo "  ${DIM}• \"audite mon design system\"${RESET}"
echo "  ${DIM}• \"review mes composants\"${RESET}"
echo "  ${DIM}• \"extrais mes tokens\"${RESET}"
echo ""
echo "${BOLD}─── Learn more ─────────────────────────────────────────────${RESET}"
echo ""
echo "  ${BLUE}▸${RESET} Step-by-step tutorials in ${BOLD}~/.claude/skills/design-system-pro/docs/${RESET}"
echo "  ${BLUE}▸${RESET} Full README:     ${DIM}https://github.com/cherifskr/design-system-pro${RESET}"
echo "  ${BLUE}▸${RESET} Questions / feedback: ${DIM}contact@cherifsikirou.com${RESET}"
echo ""
echo "${DIM}Happy auditing —  Chérif${RESET}"
echo ""
