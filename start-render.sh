#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Render injects PORT. Use 10000 as a fallback for local smoke runs.
PORT_VALUE="${PORT:-10000}"

source "$ROOT_DIR/.venv/bin/activate"

# Bind to all interfaces so Render's health checks can reach the process.
exec libretranslate \
  --host 0.0.0.0 \
  --port "$PORT_VALUE" \
  --load-only en,hi \
  --threads 2
