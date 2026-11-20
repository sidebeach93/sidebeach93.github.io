#!/bin/bash
# Autosave: after each Claude response, commit any changes in this project and push them to GitHub.
# Runs from the Stop hook in .claude/settings.json. Never blocks Claude: every failure just exits 0.
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}" || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -z "$(git status --porcelain)" ] && exit 0
git add -A
git -c core.safecrlf=false commit -qm "autosave $(date '+%Y-%m-%d %H:%M')"
git pull -q --rebase --autostash || { git rebase --abort 2>/dev/null; echo "autosave: pull conflict, not pushed" >&2; exit 0; }
git push -q -u origin HEAD
exit 0
