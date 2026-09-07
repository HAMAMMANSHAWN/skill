#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  ensure-project-skill-bootstrap.sh [--apply] PROJECT_ROOT

Ensures a project can discover project-skill-bootstrap from Codex, Claude,
and Cursor. Without --apply, prints the planned changes only.
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

if [[ -z "$project_root" || ! -d "$project_root" ]]; then
  echo "Project directory does not exist: ${project_root:-<missing>}" >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
library_root="$(cd -- "$script_dir/../../.." && pwd -P)"
project_root="$(cd -- "$project_root" && pwd -P)"

skill_source="$library_root/skills/project-skill-bootstrap"
cursor_mdc_source="$library_root/templates/cursor/project-skill-bootstrap.mdc"
cursor_rule_source="$library_root/templates/cursor/project-skill-bootstrap"

for required in "$skill_source/SKILL.md" "$cursor_mdc_source" "$cursor_rule_source/RULE.md"; do
  if [[ ! -e "$required" ]]; then
    echo "Missing required source: $required" >&2
    exit 1
  fi
done

same_target() {
  local link_path="$1"
  local expected_target="$2"
  local current link_dir current_abs expected_abs

  current="$(readlink "$link_path")"
  link_dir="$(cd -- "$(dirname -- "$link_path")" && pwd -P)"

  if [[ "$current" = /* ]]; then
    current_abs="$(cd -- "$(dirname -- "$current")" && pwd -P)/$(basename -- "$current")"
  else
    current_abs="$(cd -- "$link_dir/$(dirname -- "$current")" && pwd -P)/$(basename -- "$current")"
  fi
  if [[ "$expected_target" = /* ]]; then
    expected_abs="$(cd -- "$(dirname -- "$expected_target")" && pwd -P)/$(basename -- "$expected_target")"
  else
    expected_abs="$(cd -- "$link_dir/$(dirname -- "$expected_target")" && pwd -P)/$(basename -- "$expected_target")"
  fi
  [[ "$current_abs" == "$expected_abs" ]]
}

ensure_symlink() {
  local target="$1"
  local link="$2"

  if [[ -L "$link" ]]; then
    if same_target "$link" "$target"; then
      echo "OK existing symlink: $link -> $target"
      return
    fi
    echo "Refusing to overwrite different symlink: $link -> $(readlink "$link")" >&2
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

agent_file="$project_root/AGENTS.md"
begin_marker='<!-- project-skill-bootstrap:begin -->'
end_marker='<!-- project-skill-bootstrap:end -->'
begin_count=0
end_count=0
if [[ -e "$agent_file" ]]; then
  begin_count="$(grep -Fxc "$begin_marker" "$agent_file" || true)"
  end_count="$(grep -Fxc "$end_marker" "$agent_file" || true)"
fi

if [[ "$begin_count" != "$end_count" || "$begin_count" -gt 1 ]]; then
  echo "Conflicting project-skill-bootstrap block in $agent_file" >&2
  exit 1
fi

if [[ "$apply" == true ]]; then
  mkdir -p "$project_root/.agents/skills" "$project_root/.codex" "$project_root/.claude" \
    "$project_root/.cursor/skills" "$project_root/.cursor/rules"
fi

ensure_symlink "$skill_source" "$project_root/.agents/skills/project-skill-bootstrap"
ensure_symlink "../.agents/skills" "$project_root/.codex/skills"
ensure_symlink "../.agents/skills" "$project_root/.claude/skills"
ensure_symlink "$skill_source" "$project_root/.cursor/skills/project-skill-bootstrap"
ensure_symlink "$cursor_mdc_source" "$project_root/.cursor/rules/project-skill-bootstrap.mdc"
ensure_symlink "$cursor_rule_source" "$project_root/.cursor/rules/project-skill-bootstrap"

if [[ "$begin_count" -eq 1 ]]; then
  echo "OK existing project-skill-bootstrap reminder: $agent_file"
elif [[ "$apply" == true ]]; then
  if [[ -e "$agent_file" ]] && [[ -s "$agent_file" ]]; then
    printf '\n' >> "$agent_file"
  fi
  cat >> "$agent_file" <<'INSTRUCTIONS'
<!-- project-skill-bootstrap:begin -->
## Project Skill Bootstrap

For new or resumed work that needs Skills, project planning, Skill selection, Skill migration, or a cross-conversation handoff, read `.agents/skills/project-skill-bootstrap/SKILL.md` first. Keep Skill consultation in `.agents/skill-consultation.md` and only install explicitly approved Skills.
<!-- project-skill-bootstrap:end -->
INSTRUCTIONS
  echo "Added project-skill-bootstrap reminder: $agent_file"
else
  echo "Would add project-skill-bootstrap reminder: $agent_file"
fi

if [[ "$apply" == true ]]; then
  test -f "$project_root/.agents/skills/project-skill-bootstrap/SKILL.md"
  test -f "$project_root/.cursor/skills/project-skill-bootstrap/SKILL.md"
  test -f "$project_root/.cursor/rules/project-skill-bootstrap/RULE.md"
fi
