#!/usr/bin/env python3
"""Read YouMind board files and file content via OpenAPI."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from typing import Any


DEFAULT_BASE_URL = "https://youmind.com"
DEFAULT_KEY_FILE = "~/.config/youmind/api-key"


def board_id_from_url(value: str) -> str:
    match = re.search(r"/boards/([0-9a-fA-F-]+)", value)
    if match:
        return match.group(1)
    return value


def request_json(base_url: str, api_key: str, name: str, payload: dict[str, Any]) -> Any:
    url = f"{base_url.rstrip('/')}/openapi/v1/{name}"
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "x-api-key": api_key,
            "content-type": "application/json",
            "accept": "application/json",
            "user-agent": "curl/8.0.0",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"YouMind API error {exc.code}: {body}") from exc
    except urllib.error.URLError as exc:
        raise SystemExit(f"YouMind network error: {exc}") from exc


def require_api_key(args: argparse.Namespace) -> str:
    api_key = args.api_key or os.environ.get("YOUMIND_API_KEY")
    if not api_key:
        key_path = os.path.expanduser(args.api_key_file)
        if os.path.exists(key_path):
            with open(key_path, "r", encoding="utf-8") as handle:
                api_key = handle.read().strip()
    if not api_key:
        raise SystemExit(
            "Missing API key. Set YOUMIND_API_KEY, pass --api-key, "
            f"or create {DEFAULT_KEY_FILE}."
        )
    return api_key


def file_title(item: dict[str, Any]) -> str:
    return str(item.get("title") or item.get("name") or "")


def command_list(args: argparse.Namespace) -> None:
    api_key = require_api_key(args)
    board_id = args.board_id or board_id_from_url(args.board_url or "")
    if not board_id:
        raise SystemExit("Provide --board-id or --board-url.")
    data = request_json(args.base_url, api_key, "listFiles", {"boardId": board_id})
    items = data if isinstance(data, list) else data.get("items", [])
    if args.query:
        needle = args.query.lower()
        items = [item for item in items if needle in file_title(item).lower()]
    if args.format == "json":
        print(json.dumps(items, ensure_ascii=False, indent=2))
        return
    for item in items:
        print(f"{item.get('id')}\t{item.get('type')}\t{file_title(item)}")


def extract_readable(data: dict[str, Any]) -> str:
    content = data.get("content")
    if isinstance(content, str) and content.strip():
        return content
    transcript = data.get("transcript")
    if isinstance(transcript, dict):
        contents = transcript.get("contents")
        if isinstance(contents, list):
            parts = [str(part) for part in contents if str(part).strip()]
            if parts:
                return "\n".join(parts)
    metadata = data.get("metadata")
    if isinstance(metadata, dict):
        for key in ("content", "text", "transcript"):
            value = metadata.get(key)
            if isinstance(value, str) and value.strip():
                return value
    return ""


def command_read(args: argparse.Namespace) -> None:
    api_key = require_api_key(args)
    data = request_json(args.base_url, api_key, "getFile", {"id": args.file_id})
    if args.format == "json":
        print(json.dumps(data, ensure_ascii=False, indent=2))
        return
    title = data.get("title") or args.file_id
    readable = extract_readable(data)
    print(f"# {title}\n")
    if readable:
        print(readable)
    else:
        print("> File was retrieved, but no readable content or transcript was returned.")


def command_search(args: argparse.Namespace) -> None:
    api_key = require_api_key(args)
    payload: dict[str, Any] = {
        "query": args.query,
        "scope": args.scope,
        "topK": args.top_k,
    }
    if args.board_id or args.board_url:
        payload["scope"] = "board"
        payload["boardId"] = args.board_id or board_id_from_url(args.board_url or "")
    data = request_json(args.base_url, api_key, "search", payload)
    if args.format == "json":
        print(json.dumps(data, ensure_ascii=False, indent=2))
        return
    results = data.get("results", []) if isinstance(data, dict) else []
    for item in results:
        entity_id = item.get("entity_id") or item.get("entityId")
        entity_type = item.get("entity_type") or item.get("entityType")
        metadata = item.get("metadata") or {}
        title = metadata.get("title") or item.get("text") or ""
        print(f"{entity_id}\t{entity_type}\t{title}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Read YouMind files via OpenAPI.")
    parser.add_argument("--api-key", help="YouMind API key. Prefer YOUMIND_API_KEY.")
    parser.add_argument("--api-key-file", default=DEFAULT_KEY_FILE, help="Local file containing the YouMind API key.")
    parser.add_argument("--base-url", default=os.environ.get("YOUMIND_BASE_URL", DEFAULT_BASE_URL))
    subparsers = parser.add_subparsers(dest="command", required=True)

    list_parser = subparsers.add_parser("list", help="List files in a board.")
    list_parser.add_argument("--board-id")
    list_parser.add_argument("--board-url")
    list_parser.add_argument("--query", help="Case-insensitive title filter.")
    list_parser.add_argument("--format", choices=["text", "json"], default="text")
    list_parser.set_defaults(func=command_list)

    read_parser = subparsers.add_parser("read", help="Read a file by ID.")
    read_parser.add_argument("--file-id", required=True)
    read_parser.add_argument("--format", choices=["markdown", "json"], default="markdown")
    read_parser.set_defaults(func=command_read)

    search_parser = subparsers.add_parser("search", help="Search library or board content.")
    search_parser.add_argument("--query", required=True)
    search_parser.add_argument("--scope", choices=["library", "board"], default="library")
    search_parser.add_argument("--board-id")
    search_parser.add_argument("--board-url")
    search_parser.add_argument("--top-k", type=int, default=5)
    search_parser.add_argument("--format", choices=["text", "json"], default="text")
    search_parser.set_defaults(func=command_search)

    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
