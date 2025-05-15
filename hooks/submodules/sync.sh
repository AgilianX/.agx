#!/bin/bash
# Automatically keep submodules updated when switching branches or pulling changes

# Check if automatic synchronization is explicitly disabled
if [ "$(git config --get agx.autosync)" = "false" ]; then
    echo "ℹ️ Automatic AgX submodule sync disabled by config. Skipping."
    exit 0
fi

# Check if we're running from inside the .agx repository itself
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
if [ "$REPO_NAME" = ".agx" ]; then
    exit 0
fi

git submodule sync
git agx-update

echo "✅ AgX Submodule updated successfully!"
