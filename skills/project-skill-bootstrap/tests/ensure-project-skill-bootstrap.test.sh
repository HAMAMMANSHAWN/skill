#!/usr/bin/env bash
set -euo pipefail

library_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd -P)"
script="$library_root/skills/project-skill-bootstrap/scripts/ensure-project-skill-bootstrap.sh"
project_root="$(mktemp -d)"
trap 'rm -rf "$project_root"' EXIT

printf '# Existing project instructions\n' > "$project_root/AGENTS.md"

"$script" "$project_root"
test ! -e "$project_root/.agents"
test ! -e "$project_root/.codex"
test ! -e "$project_root/.claude"

"$script" --apply "$project_root"
test -L "$project_root/.agents/skills/project-skill-bootstrap"
test -L "$project_root/.codex/skills"
test -L "$project_root/.claude/skills"
test -L "$project_root/.cursor/skills/project-skill-bootstrap"
test -L "$project_root/.cursor/rules/project-skill-bootstrap.mdc"
test -L "$project_root/.cursor/rules/project-skill-bootstrap"
test -f "$project_root/.agents/skills/project-skill-bootstrap/SKILL.md"
test -f "$project_root/.cursor/rules/project-skill-bootstrap/RULE.md"
rg -F '# Existing project instructions' "$project_root/AGENTS.md" >/dev/null
test "$(rg -c '<!-- project-skill-bootstrap:begin -->' "$project_root/AGENTS.md")" -eq 1
test "$(rg -c '<!-- project-skill-bootstrap:end -->' "$project_root/AGENTS.md")" -eq 1

"$script" --apply "$project_root"
test "$(rg -c '<!-- project-skill-bootstrap:begin -->' "$project_root/AGENTS.md")" -eq 1

cursor_sync="$library_root/scripts/sync-cursor-project-skill-bootstrap.sh"
cursor_project="$(mktemp -d)"
trap 'rm -rf "$project_root" "$cursor_project"' EXIT
"$cursor_sync" --apply "$cursor_project"
test "$(rg -c '<!-- project-skill-bootstrap:begin -->' "$cursor_project/AGENTS.md")" -eq 1

echo 'PASS: bootstrap continuity setup is safe and idempotent.'
