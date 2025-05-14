#!/bin/bash
# Automatically keep submodules updated when switching branches or pulling changes

# Check if automatic synchronization is explicitly disabled
if [ "$(git config --get agx.autosync)" = "false" ]; then
    echo "ℹ️ Automatic AgX submodule sync disabled by config. Skipping."
    exit 0
fi

git submodule sync
git submodule update --init --remote .agx

echo "✅ AgX Submodule updated successfully!"
