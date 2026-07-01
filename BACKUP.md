# Migration Backup

迁移前的用户 Skill 已归档到仓库外，避免把重复压缩包提交进 Git：

- 时间：2026-07-01 14:19:38（Asia/Shanghai）
- 文件：`/Users/project/Github/skill-backups/user-skills-before-project-migration-20260701-141938.tar.gz`
- 大小：5.3 MB
- SHA-256：`4dc39767341a6390110a627335d397820d2534cc0328c77b6eda1b445f50ec33`
- 内容：关闭 CC Switch 后剩余的 `~/.codex/skills` 用户目录，以及 `~/.cc-switch/skills` 原件
- 排除：`~/.codex/skills/.system` 与 `codex-primary-runtime`

验证：

```bash
shasum -a 256 /Users/project/Github/skill-backups/user-skills-before-project-migration-20260701-141938.tar.gz
tar -tzf /Users/project/Github/skill-backups/user-skills-before-project-migration-20260701-141938.tar.gz | less
```
