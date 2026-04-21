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

echo ""
echo "${BOLD}design-system-pro — Claude Code skill${RESET}"
echo "${DIM}by Chérif Sikirou · cherifsikirou.com${RESET}"
echo ""

# ── 1. Install the skill ──────────────────────────────────────────
step "Installing skill into ${SKILL_DIR/$HOME/~}"

mkdir -p "${HOME}/.claude/skills"

# If the script is run from inside a cloned repo, copy locally.
# Otherwise, clone fresh from GitHub.
if [ -f "./SKILL.md" ] && [ -d "./commands" ] && [ -d "./references" ]; then
  # Running from inside the repo — copy files.
  rm -rf "${SKILL_DIR}"
  mkdir -p "${SKILL_DIR}"
  cp -R ./SKILL.md ./commands ./references ./templates ./LICENSE ./README.md "${SKILL_DIR}/" 2>/dev/null || true
  [ -f ./CHANGELOG.md ] && cp ./CHANGELOG.md "${SKILL_DIR}/"
  ok "Skill files copied from local clone"
else
  # Clone fresh from GitHub.
  if [ -d "${SKILL_DIR}" ]; then
    warn "Skill already installed — removing old version"
    rm -rf "${SKILL_DIR}"
  fi
  git clone --depth 1 "${REPO_URL}" "${SKILL_DIR}" > /dev/null 2>&1
  ok "Skill cloned from GitHub"
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
description: Invoke the design-system-pro skill — audit, document, extend, or extract tokens from a design system.
argument-hint: "[audit | document <component> | extend <pattern> | tokens]"
---

Charge et exécute le skill **design-system-pro** installé dans `~/.claude/skills/design-system-pro/`.

Instructions :

1. Lis d'abord `~/.claude/skills/design-system-pro/SKILL.md` pour charger le contexte du skill et ses principes de travail.

2. Interprète le premier mot de `$ARGUMENTS` comme commande :
   - `audit` → lis `~/.claude/skills/design-system-pro/commands/audit.md` et applique la procédure d'audit sur le projet courant
   - `document <component>` → lis `~/.claude/skills/design-system-pro/commands/document.md` et produis la documentation du composant demandé
   - `extend <pattern>` → lis `~/.claude/skills/design-system-pro/commands/extend.md` et propose un nouveau composant raisonné
   - `tokens` → lis `~/.claude/skills/design-system-pro/commands/tokens.md` et extrais les tokens utilisés sous forme de JSON W3C DTCG
   - **Sans argument** → demande à l'utilisateur laquelle des 4 commandes il veut lancer

3. Si la procédure référence les guides (`references/*.md`) ou les templates (`templates/*.md`), **lis-les à la demande** — ne charge pas tout d'un coup.

4. Respecte les 6 principes de travail définis dans SKILL.md.

Argument passé par l'utilisateur : `$ARGUMENTS`
EOF

ok "/ds command registered at ${CMD_FILE/$HOME/~}"

# ── 3. Done — next steps ──────────────────────────────────────────
echo ""
echo "${GREEN}${BOLD}✓ Installation complete${RESET}"
echo ""
echo "${BOLD}Next steps:${RESET}"
echo "  1. ${DIM}Restart Claude Code${RESET} so it picks up the new skill and command."
echo "  2. Try it in any project:"
echo ""
echo "     ${BOLD}/ds audit${RESET}        ${DIM}# scan the design system${RESET}"
echo "     ${BOLD}/ds document Button${RESET}"
echo "     ${BOLD}/ds extend confirmation-dialog${RESET}"
echo "     ${BOLD}/ds tokens${RESET}       ${DIM}# extract tokens as W3C DTCG JSON${RESET}"
echo ""
echo "  Or just describe what you want — the skill auto-triggers on"
echo "  phrases like «audite mon design system» or «review mes composants»."
echo ""
echo "${DIM}Questions, feedback, bugs → contact@cherifsikirou.com${RESET}"
echo ""
