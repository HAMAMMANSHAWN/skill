#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  sync-cursor-project-skill-bootstrap.sh [--apply] [PROJECT_ROOT]

Installs the central project-skill-bootstrap Skill and its Codex, Claude,
Cursor, and AGENTS.md continuity entrypoints. Without --apply, prints the
planned changes.
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

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
helper="$script_dir/../skills/project-skill-bootstrap/scripts/ensure-project-skill-bootstrap.sh"
project_root="${project_root:-$PWD}"

if [[ ! -x "$helper" ]]; then
  echo "Missing executable bootstrap helper: $helper" >&2
  exit 1
fi

if [[ "$apply" == true ]]; then
  exec "$helper" --apply "$project_root"
else
  exec "$helper" "$project_root"
fi
