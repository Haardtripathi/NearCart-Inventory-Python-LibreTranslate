#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/.venv/bin/activate"
exec libretranslate --host 127.0.0.1 --port 5000 --load-only en,hi,gu
