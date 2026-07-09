#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  sync-cursor-project-skill-bootstrap.sh [--apply] [PROJECT_ROOT]

Installs project-local Cursor, Codex, and Claude entrypoints for the central
project-skill-bootstrap Skill. Without --apply, prints the planned changes.

Creates:
  PROJECT_ROOT/.cursor/rules/project-skill-bootstrap.mdc
  PROJECT_ROOT/.cursor/rules/project-skill-bootstrap -> central RULE.md folder
  PROJECT_ROOT/.cursor/skills/project-skill-bootstrap -> central Skill source
  PROJECT_ROOT/.agents/skills/project-skill-bootstrap -> central Skill source
  PROJECT_ROOT/.codex/skills -> ../.agents/skills
  PROJECT_ROOT/.claude/skills -> ../.agents/skills
USAGE
}

apply=false
project_root=""

while (($#)); do
  case "$1" in
    --apply)
      apply=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -n "$project_root" ]]; then
        echo "Only one PROJECT_ROOT is allowed." >&2
        exit 2
      fi
      project_root="$1"
      shift
      ;;
  esac
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
library_root="$(cd -- "$script_dir/.." && pwd)"
project_root="${project_root:-$PWD}"
project_root="$(cd -- "$project_root" && pwd)"

skill_source="$library_root/skills/project-skill-bootstrap"
cursor_mdc_source="$library_root/templates/cursor/project-skill-bootstrap.mdc"
cursor_rule_source="$library_root/templates/cursor/project-skill-bootstrap"

require_path() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    echo "Missing required path: $path" >&2
    exit 1
  fi
}

require_path "$skill_source/SKILL.md"
require_path "$cursor_mdc_source"
require_path "$cursor_rule_source/RULE.md"

ensure_symlink() {
  local target="$1"
  local link="$2"

  if [[ -L "$link" ]]; then
    local current
    current="$(readlink "$link")"
    local link_dir current_abs target_abs
    link_dir="$(cd -- "$(dirname -- "$link")" && pwd)"
    if [[ "$current" = /* ]]; then
      current_abs="$current"
    else
      current_abs="$(cd -- "$link_dir" && cd -- "$(dirname -- "$current")" && pwd)/$(basename -- "$current")"
    fi
    if [[ "$target" = /* ]]; then
      target_abs="$(cd -- "$(dirname -- "$target")" && pwd)/$(basename -- "$target")"
    else
      target_abs="$(cd -- "$link_dir" && cd -- "$(dirname -- "$target")" && pwd)/$(basename -- "$target")"
    fi

    if [[ "$current" == "$target" || "$current_abs" == "$target_abs" ]]; then
      echo "OK existing symlink: $link -> $target"
      return
    fi
    echo "Refusing to overwrite different symlink: $link -> $current" >&2
    exit 1
  fi

  if [[ -e "$link" ]]; then
    echo "Refusing to overwrite existing non-symlink: $link" >&2
    exit 1
  fi

  if [[ "$apply" == true ]]; then
    ln -s "$target" "$link"
    echo "Created symlink: $link -> $target"
  else
    echo "Would create symlink: $link -> $target"
  fi
}

if [[ "$apply" == true ]]; then
  mkdir -p "$project_root/.cursor/rules" "$project_root/.cursor/skills" "$project_root/.agents/skills" "$project_root/.codex" "$project_root/.claude"
else
  echo "Dry run for project: $project_root"
  echo "Use --apply to create links."
fi

ensure_symlink "$cursor_mdc_source" "$project_root/.cursor/rules/project-skill-bootstrap.mdc"
ensure_symlink "$cursor_rule_source" "$project_root/.cursor/rules/project-skill-bootstrap"
ensure_symlink "$skill_source" "$project_root/.cursor/skills/project-skill-bootstrap"
ensure_symlink "$skill_source" "$project_root/.agents/skills/project-skill-bootstrap"
ensure_symlink "../.agents/skills" "$project_root/.codex/skills"
ensure_symlink "../.agents/skills" "$project_root/.claude/skills"

if [[ "$apply" == true ]]; then
  test -f "$project_root/.cursor/rules/project-skill-bootstrap.mdc"
  test -f "$project_root/.cursor/rules/project-skill-bootstrap/RULE.md"
  test -f "$project_root/.cursor/skills/project-skill-bootstrap/SKILL.md"
  test -f "$project_root/.agents/skills/project-skill-bootstrap/SKILL.md"
  test -f "$project_root/.codex/skills/project-skill-bootstrap/SKILL.md"
  echo "Project Skill bootstrap sync complete."
fi
