---
status: draft
library: /Users/project/Github/skill
planned_at: YYYY-MM-DD
approved_at:
installed_at:
---

# Project Skill Plan

## Project goal

Describe the intended outcome and primary deliverables.

## Required now

- [ ] `skill-name` — why this is necessary now

## Conditional later

- [ ] `skill-name` — install only when this condition occurs

## Rejected candidates

- `skill-name` — why it would add noise or overlap

## Installation command

```bash
/Users/project/Github/skill/skills/project-skill-bootstrap/scripts/link-skills.sh --apply PROJECT_ROOT skill-name
```

## Verification

- [ ] Every selected target contains `SKILL.md`
- [ ] Every `.agents/skills/<name>` entry is a symlink to the central library
- [ ] `.claude/skills` resolves to `.agents/skills`

## Next-conversation prompt

> Read `.agents/skill-plan.md` and the project instructions. If the plan status is `approved`, dry-run and apply exactly the required Skill links, verify them, mark the plan installed, and then execute the project goal using those Skills.
