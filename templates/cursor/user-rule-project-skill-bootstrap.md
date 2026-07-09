# Project Skill Bootstrap

When I open or start a project that has no project-specific Skill selection yet, first use the central Skill library at `/Users/project/Github/skill`.

If the project contains `.cursor/rules/project-skill-bootstrap.mdc`, `.cursor/rules/project-skill-bootstrap/RULE.md`, or `.agents/skills/project-skill-bootstrap/SKILL.md`, follow that local rule/Skill.

If the project does not contain those files, ask whether to run:

```bash
/Users/project/Github/skill/scripts/sync-cursor-project-skill-bootstrap.sh --apply "$PWD"
```

Do not globally install every Skill. Prefer project-local links under `.agents/skills/<name>` and use `.agents/skill-plan.md` as the cross-session handoff.
