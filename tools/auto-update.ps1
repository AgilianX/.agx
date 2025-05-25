# Automatically keep submodules updated when switching branches or pulling changes
# Typically invoked by post-checkout and post-merge hooks

$ErrorActionPreference = 'Stop'
$repoName = Split-Path (git rev-parse --show-toplevel) -Leaf
$submodule = '.agx'
if ($repoName -eq $submodule) { exit 0 }

# Check if automatic synchronization is explicitly disabled
$autoSync = git config --local --get "$submodule.autosync"
if ($autoSync -eq 'false') { exit 0 }

# Check if .agx submodule working tree is clean
$status = git -C $submodule status --porcelain
$stashed = $false
# Prepare a unique stash message with timestamp for identification
$stashTimestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$stashMsg = "Auto-stash before submodule update [$stashTimestamp]"
if ($status) {
    Write-Host "└─▶📝 Uncommitted changes detected in '$submodule'. Stashing before update..." -ForegroundColor Yellow
    # Stash changes (including untracked) with a unique message
    git -C $submodule stash push -u -m "$stashMsg"
    $stashed = $true
}

git submodule sync
git agx-update

# Restore stashed changes if any
if ($stashed) {
    # Find the stash with the exact unique message
    $stashList = git -C $submodule stash list
    $autoStash = $stashList -split "`n" | Where-Object { $_.Contains($stashMsg) } | Select-Object -First 1
    Write-Host "└─▶🔎 Matching stash entry: $autoStash" -ForegroundColor Cyan
    # We'll go from here as needed
    if ($autoStash -and ($autoStash -match 'stash@\{(\d+)\}')) {
        $stashRef = "stash@{$($matches[1])}"
        # Pop only the identified stash (does not affect other user stashes)
        git -C $submodule stash pop $stashRef
        Write-Host '└─▶✅ Changes restored from stash. Please review your working tree.' -ForegroundColor Green
    }
}
