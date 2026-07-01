#!/usr/bin/env bash
set -euo pipefail

apply=false
if [[ "${1:-}" == "--apply" ]]; then
  apply=true
  shift
fi

if (( $# < 2 )); then
  echo "Usage: $0 [--apply] PROJECT_ROOT SKILL [SKILL ...]" >&2
  exit 2
fi

project_root=$1
shift
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
library_root=$(cd "$script_dir/../../.." && pwd -P)
skills_root="$library_root/skills"

if [[ ! -d "$project_root" ]]; then
  echo "Project directory does not exist: $project_root" >&2
  exit 1
fi
project_root=$(cd "$project_root" && pwd -P)

for skill in "$@"; do
  if [[ ! "$skill" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    echo "Invalid Skill name: $skill" >&2
    exit 1
  fi
  if [[ ! -f "$skills_root/$skill/SKILL.md" ]]; then
    echo "Missing Skill manifest: $skills_root/$skill/SKILL.md" >&2
    exit 1
  fi
  destination="$project_root/.agents/skills/$skill"
  if [[ -e "$destination" || -L "$destination" ]]; then
    echo "Refusing to overwrite existing entry: $destination" >&2
    exit 1
  fi
done

claude_entry="$project_root/.claude/skills"
if [[ -e "$claude_entry" || -L "$claude_entry" ]]; then
  if [[ ! -L "$claude_entry" || "$(readlink "$claude_entry")" != "../.agents/skills" ]]; then
    echo "Conflicting Claude Skills entry: $claude_entry" >&2
    exit 1
  fi
fi

if ! $apply; then
  echo "Dry run; no files changed."
  for skill in "$@"; do
    echo "LINK $project_root/.agents/skills/$skill -> $skills_root/$skill"
  done
  if [[ ! -L "$claude_entry" ]]; then
    echo "LINK $claude_entry -> ../.agents/skills"
  fi
  echo "Re-run with --apply after reviewing the approved plan."
  exit 0
fi

mkdir -p "$project_root/.agents/skills" "$project_root/.claude"
for skill in "$@"; do
  ln -s "$skills_root/$skill" "$project_root/.agents/skills/$skill"
  test -f "$project_root/.agents/skills/$skill/SKILL.md"
  echo "Linked $skill"
done
if [[ ! -L "$claude_entry" ]]; then
  ln -s ../.agents/skills "$claude_entry"
  echo "Linked .claude/skills"
fi
