#!/usr/bin/env bash
set -euo pipefail

GRAPH_DIR="${1:-}"
if [ -z "$GRAPH_DIR" ]; then
    echo "Usage: $0 <project-dir>"
    exit 1
fi

if [ ! -f "$GRAPH_DIR/.understand-anything/knowledge-graph.json" ]; then
    echo "[ERROR] No knowledge graph found. Run /understand first."
    exit 1
fi

DASHBOARD_DIR="$(cd "$(dirname "$0")" && pwd)"

# Resolve symlinks to real path (Linux/macOS)
REAL_DASHBOARD="$(readlink -f "$DASHBOARD_DIR" 2>/dev/null || realpath "$DASHBOARD_DIR")"

if [ "$REAL_DASHBOARD" != "$DASHBOARD_DIR" ]; then
    echo "[INFO] Symlink resolved to: $REAL_DASHBOARD"
fi

cd "$REAL_DASHBOARD"
echo "[INFO] Starting dashboard for: $GRAPH_DIR"

GRAPH_DIR="$GRAPH_DIR" npx vite --host 127.0.0.1
