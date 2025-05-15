#!/usr/bin/env bash
# agx-update.sh
# Updates the .agx submodule and runs repository initialization (cross-platform)

set -e

# Determine repo root and name
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")

# Determine .agx base path
if [ "$REPO_NAME" = ".agx" ]; then
    AGX_BASE="$REPO_ROOT"
else
    AGX_BASE="$REPO_ROOT/.agx"
fi

# Update .agx submodule
cd "$REPO_ROOT"
git submodule update --init --remote --merge .agx

# Run initialization script
if command -v pwsh >/dev/null 2>&1; then
    pwsh -NoProfile -ExecutionPolicy Bypass -File "$AGX_BASE/init.ps1"
elif command -v powershell >/dev/null 2>&1; then
    powershell -NoProfile -ExecutionPolicy Bypass -File "$AGX_BASE/init.ps1"
elif [ -f "$AGX_BASE/init.sh" ]; then
    bash "$AGX_BASE/init.sh"
else
    echo "No suitable initialization script found (init.ps1 or init.sh)"
    exit 1
fi
