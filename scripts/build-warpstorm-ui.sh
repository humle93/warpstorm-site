#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ACTION="${1:---check}"
PLUGIN="$ROOT/wordpress/plugins/warpstorm-ui"

check() {
  test -f "$PLUGIN/warpstorm-ui.php"
  test -f "$PLUGIN/assets/warpstorm-ui.css"
  test -f "$PLUGIN/assets/warpstorm-ui.js"
  python3 -m unittest discover -s "$ROOT/tests" -p 'test_warpstorm_ui.py' -v
  if command -v php >/dev/null 2>&1; then
    php -l "$PLUGIN/warpstorm-ui.php"
  else
    echo "WARN: PHP not installed locally; CI validates syntax."
  fi
}
case "$ACTION" in
  --check)
    check
    ;;
  --package)
    check
    command -v zip >/dev/null 2>&1 || { echo "ERROR: zip is required"; exit 1; }
    mkdir -p "$ROOT/build"
    rm -f "$ROOT/build/warpstorm-ui.zip"
    (cd "$ROOT/wordpress/plugins" && zip -q -r "$ROOT/build/warpstorm-ui.zip" warpstorm-ui)
    echo "Built $ROOT/build/warpstorm-ui.zip"
    ;;
  *)
    echo "Usage: bash scripts/build-warpstorm-ui.sh [--check|--package]"
    exit 2
    ;;
esac
