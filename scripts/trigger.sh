#!/usr/bin/env bash
# Manually fire the session-anchor routine — useful for testing before you
# trust it to GitHub Actions. Requires CLAUDE_ROUTINE_URL and
# CLAUDE_ROUTINE_TOKEN as environment variables (see .env.example).

set -euo pipefail

if [[ -z "${CLAUDE_ROUTINE_URL:-}" || -z "${CLAUDE_ROUTINE_TOKEN:-}" ]]; then
  echo "Missing CLAUDE_ROUTINE_URL or CLAUDE_ROUTINE_TOKEN." >&2
  echo "Copy .env.example to .env, fill it in, then: export \$(cat .env | xargs)" >&2
  exit 1
fi

curl -sS -X POST "$CLAUDE_ROUTINE_URL" \
  -H "Authorization: Bearer $CLAUDE_ROUTINE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text": "say hi"}'

echo
echo "Fired. Check claude.ai/code/routines for the new session."
