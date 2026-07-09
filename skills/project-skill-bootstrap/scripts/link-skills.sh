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

same_target() {
  local link_path="$1"
  local expected_target="$2"
  local current link_dir current_abs expected_abs

  current=$(readlink "$link_path")
  link_dir=$(cd "$(dirname "$link_path")" && pwd -P)

  if [[ "$current" = /* ]]; then
    current_abs=$(cd "$(dirname "$current")" && pwd -P)/$(basename "$current")
  else
    current_abs=$(cd "$link_dir" && cd "$(dirname "$current")" && pwd -P)/$(basename "$current")
  fi

  if [[ "$expected_target" = /* ]]; then
    expected_abs=$(cd "$(dirname "$expected_target")" && pwd -P)/$(basename "$expected_target")
  else
    expected_abs=$(cd "$link_dir" && cd "$(dirname "$expected_target")" && pwd -P)/$(basename "$expected_target")
  fi
  [[ "$current_abs" == "$expected_abs" ]]
}

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
  for destination in "$project_root/.agents/skills/$skill" "$project_root/.cursor/skills/$skill"; do
    if [[ -L "$destination" ]]; then
      current=$(readlink "$destination")
      if same_target "$destination" "$skills_root/$skill"; then
        continue
      fi
      echo "Refusing to overwrite different symlink: $destination -> $current" >&2
      exit 1
    fi
    if [[ -e "$destination" ]]; then
      echo "Refusing to overwrite existing non-symlink: $destination" >&2
      exit 1
    fi
  done
done

codex_entry="$project_root/.codex/skills"
claude_entry="$project_root/.claude/skills"
for entry_name in Codex Claude; do
  if [[ "$entry_name" == "Codex" ]]; then
    entry="$codex_entry"
  else
    entry="$claude_entry"
  fi
  if [[ -e "$entry" || -L "$entry" ]]; then
    if [[ ! -L "$entry" ]] || ! same_target "$entry" "../.agents/skills"; then
      echo "Conflicting $entry_name Skills entry: $entry" >&2
      exit 1
    fi
  fi
done

if ! $apply; then
  echo "Dry run; no files changed."
  for skill in "$@"; do
    if [[ -L "$project_root/.agents/skills/$skill" ]]; then
      echo "OK $project_root/.agents/skills/$skill -> $skills_root/$skill"
    else
      echo "LINK $project_root/.agents/skills/$skill -> $skills_root/$skill"
    fi
    if [[ -L "$project_root/.cursor/skills/$skill" ]]; then
      echo "OK $project_root/.cursor/skills/$skill -> $skills_root/$skill"
    else
      echo "LINK $project_root/.cursor/skills/$skill -> $skills_root/$skill"
    fi
  done
  if [[ ! -L "$codex_entry" ]]; then
    echo "LINK $codex_entry -> ../.agents/skills"
  fi
  if [[ ! -L "$claude_entry" ]]; then
    echo "LINK $claude_entry -> ../.agents/skills"
  fi
  echo "Re-run with --apply after reviewing the approved plan."
  exit 0
fi

mkdir -p "$project_root/.agents/skills" "$project_root/.cursor/skills" "$project_root/.codex" "$project_root/.claude"
for skill in "$@"; do
  if [[ ! -L "$project_root/.agents/skills/$skill" ]]; then
    ln -s "$skills_root/$skill" "$project_root/.agents/skills/$skill"
  fi
  if [[ ! -L "$project_root/.cursor/skills/$skill" ]]; then
    ln -s "$skills_root/$skill" "$project_root/.cursor/skills/$skill"
  fi
  test -f "$project_root/.agents/skills/$skill/SKILL.md"
  test -f "$project_root/.cursor/skills/$skill/SKILL.md"
  echo "Linked $skill"
done
if [[ ! -L "$codex_entry" ]]; then
  ln -s ../.agents/skills "$codex_entry"
  echo "Linked .codex/skills"
fi
if [[ ! -L "$claude_entry" ]]; then
  ln -s ../.agents/skills "$claude_entry"
  echo "Linked .claude/skills"
fi
