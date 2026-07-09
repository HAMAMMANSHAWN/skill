#!/usr/bin/env bash
# Install project-skill-bootstrap as the sole recommended global Skill exception.
# Cursor discovers user-level Skills from ~/.cursor/skills and ~/.agents/skills.
set -euo pipefail

apply=false
if [[ "${1:-}" == "--apply" ]]; then
  apply=true
  shift
fi

if (( $# > 0 )); then
  echo "Usage: $0 [--apply]" >&2
  exit 2
fi

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
skill_root=$(cd "$script_dir/.." && pwd -P)
skill_name=project-skill-bootstrap

if [[ ! -f "$skill_root/SKILL.md" ]]; then
  echo "Missing Skill manifest: $skill_root/SKILL.md" >&2
  exit 1
fi

targets=(
  "$HOME/.cursor/skills/$skill_name"
  "$HOME/.agents/skills/$skill_name"
)

for destination in "${targets[@]}"; do
  if [[ -e "$destination" || -L "$destination" ]]; then
    if [[ -L "$destination" && "$(readlink "$destination")" == "$skill_root" ]]; then
      continue
    fi
    echo "Refusing to overwrite existing entry: $destination" >&2
    echo "Current target: $(readlink "$destination" 2>/dev/null || echo '(not a symlink)')" >&2
    exit 1
  fi
done

if ! $apply; then
  echo "Dry run; no files changed."
  for destination in "${targets[@]}"; do
    if [[ -L "$destination" && "$(readlink "$destination")" == "$skill_root" ]]; then
      echo "OK   $destination -> $skill_root"
    else
      echo "LINK $destination -> $skill_root"
    fi
  done
  echo "Re-run with --apply to create the global links."
  exit 0
fi

for destination in "${targets[@]}"; do
  mkdir -p "$(dirname "$destination")"
  if [[ -L "$destination" && "$(readlink "$destination")" == "$skill_root" ]]; then
    echo "Already linked $destination"
    continue
  fi
  ln -s "$skill_root" "$destination"
  test -f "$destination/SKILL.md"
  echo "Linked $destination"
done

echo "Global bootstrap Skill is ready. Restart Cursor or start a new agent session to discover it."
