# Automatically keep submodules updated when switching branches or pulling changes
# Typically invoked by post-checkout and post-merge hooks

$ErrorActionPreference = 'Stop'
$repoName = Split-Path (git rev-parse --show-toplevel) -Leaf
$submodule = '.agx'
if ($repoName -eq $submodule) { exit 0 }

# Check if automatic synchronization is explicitly disabled
$autoSync = git config --local --get agx.autosync
if ($autoSync -eq 'false') { exit 0 }

git submodule sync --init $submodule
git agx-update
