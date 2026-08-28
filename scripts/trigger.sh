#!/usr/bin/env bash
#
# Fires the session-anchor routine once, by hand. Use it to check your URL and
# token work before trusting them to the daily GitHub Actions run.
#
#   cp .env.example .env   # paste in your two values
#   ./scripts/trigger.sh
#
set -euo pipefail

cd "$(dirname "$0")/.."

# Load .env if it's there, so you don't have to export anything yourself.
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

if [[ -z "${CLAUDE_ROUTINE_URL:-}" || -z "${CLAUDE_ROUTINE_TOKEN:-}" ]]; then
  echo "Missing CLAUDE_ROUTINE_URL or CLAUDE_ROUTINE_TOKEN." >&2
  echo "Copy .env.example to .env and fill in both values from claude.ai/code/routines." >&2
  exit 1
fi

curl --fail-with-body -sS -X POST "$CLAUDE_ROUTINE_URL" \
  -H "Authorization: Bearer $CLAUDE_ROUTINE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text": "say hi"}'

echo
echo "Fired. Check claude.ai/code/routines for the new session."
