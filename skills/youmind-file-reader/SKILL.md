---
name: youmind-file-reader
description: Read YouMind files and board content through the YouMind OpenAPI. Use when the user provides a YouMind board URL, file URL, board ID, file ID, or asks to retrieve/read/summarize/analyze content stored in YouMind, especially documents, text files, videos with transcripts, saved web pages, and board file lists.
---

# YouMind File Reader

Use this skill to retrieve YouMind content directly instead of asking the user to copy text manually.

## Authentication

Use the YouMind OpenAPI key in this priority order:

1. `--api-key`
2. `YOUMIND_API_KEY`
3. `~/.config/youmind/api-key`

If the user wants the key saved for repeated local use, store it only in `~/.config/youmind/api-key` with `600` permissions. Do not write API keys into the skill, scripts, repository files, logs, or committed configuration.

YouMind OpenAPI requests use the `x-api-key` header, not `Authorization: Bearer`.

## Quick Start

Use the bundled script for common file-reading tasks:

```bash
python3 /Users/project/Github/skill/skills/youmind-file-reader/scripts/youmind_read.py list --board-url "https://youmind.com/boards/<board-id>?tab=file"
python3 /Users/project/Github/skill/skills/youmind-file-reader/scripts/youmind_read.py list --board-id "<board-id>" --query "金店老板"
python3 /Users/project/Github/skill/skills/youmind-file-reader/scripts/youmind_read.py read --file-id "<file-id>" --format markdown
python3 /Users/project/Github/skill/skills/youmind-file-reader/scripts/youmind_read.py search --query "金店老板" --top-k 5
```

To configure the local key file:

```bash
mkdir -p ~/.config/youmind
chmod 700 ~/.config/youmind
printf '%s' "$YOUMIND_API_KEY" > ~/.config/youmind/api-key
chmod 600 ~/.config/youmind/api-key
```

## Workflow

1. If the user provides a board URL, extract the board ID from `/boards/<id>` and list files.
2. If the user describes a target file by title, run `list --query "<title terms>"` to locate likely matches.
3. If the target is a video, call `read --file-id <id> --format markdown`; prefer transcript content when available.
4. If the target is a document or text file, read `content` from `getFile`.
5. If the user asks for analysis or rewriting, first retrieve the content, then perform the requested work from the retrieved text.
6. If no board is provided, use `search --query "<terms>"` across the library to find likely files, then read the best match.

## Direct API Reference

When not using the script, call these endpoints:

```bash
curl -sS https://youmind.com/openapi/v1/listFiles \
  -H "x-api-key: $YOUMIND_API_KEY" \
  -H "content-type: application/json" \
  -d '{"boardId":"<board-id>"}'

curl -sS https://youmind.com/openapi/v1/getFile \
  -H "x-api-key: $YOUMIND_API_KEY" \
  -H "content-type: application/json" \
  -d '{"id":"<file-id>"}'

curl -sS https://youmind.com/openapi/v1/search \
  -H "x-api-key: $YOUMIND_API_KEY" \
  -H "content-type: application/json" \
  -d '{"query":"<query>","scope":"library","topK":5}'
```

## Output Handling

For `getFile` responses:

- Prefer `.content` for documents and text files.
- Prefer `.transcript.contents[]` for videos with transcripts.
- Preserve timestamps when the user asks for close reading, trading rules, lecture notes, or quotes.
- Summarize instead of dumping long raw transcripts unless the user explicitly asks for the full text.

If YouMind returns metadata but no content, report that the file is visible but no readable body/transcript was returned. If the task requires spoken content and a video has no transcript, consider whether YouMind transcript APIs are appropriate before proceeding.
