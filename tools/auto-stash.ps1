# Auto-stash script for .agx submodule
# Usage:
#   auto-stash.ps1                # Stash changes (returns timestamp if stashed, else empty string)
#   auto-stash.ps1 -Timestamp ts  # Pop stash with matching timestamp

param([Parameter(Mandatory = $false)][datetime]$Timestamp)
$ErrorActionPreference = 'Stop'
$submodule = '.agx'

if (-not $Timestamp) {
    $status = git -C $submodule status --porcelain
    if ($status) {
        $stashTimestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
        $stashMsg = "Auto-stash before submodule update [$stashTimestamp]"
        Write-Host "└─▶📝 Uncommitted changes detected in '$submodule'. Stashing before update..." -ForegroundColor Yellow
        git -C $submodule stash push -u -m "$stashMsg"
        return $stashTimestamp
    }
}

$stashMsg = "Auto-stash before submodule update [$Timestamp]"
$stashList = git -C $submodule stash list
$autoStash = $stashList -split "`n" | Where-Object { $_.Contains($stashMsg) } | Select-Object -First 1
Write-Host "└─▶🔎 Matching stash entry: $autoStash" -ForegroundColor Cyan
if ($autoStash -and ($autoStash -match 'stash@\{(\d+)\}')) {
    $stashRef = "stash@{$($matches[1])}"
    git -C $submodule stash pop $stashRef
    Write-Host '└─▶✅ Changes restored from stash. Please review your working tree.' -ForegroundColor Green
}
else {
    Write-Host "└─▶⚠️ No matching stash found for timestamp $Timestamp." -ForegroundColor Yellow
}
