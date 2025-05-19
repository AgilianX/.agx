param([string]$TrackRef)

# typically invoked by git agx-update
$ErrorActionPreference = 'Stop'
$repoRoot = git rev-parse --show-toplevel
$repoName = Split-Path $repoRoot -Leaf
$submodule = '.agx'
if ($repoName -eq $submodule) { exit 0 }
$submoduleRoot = Join-Path $repoRoot $submodule
Set-Location $repoRoot

# Check if the submodule is already initialized
$currentCommitHash = (git submodule status $submodule) -replace '^-', '' -split ' ' | Select-Object -First 1
if ($currentCommitHash) {
    git config --local "$submodule.previousCommitHash" $currentCommitHash
}

# Determine track value: argument takes precedence, fallback to .gitmodules
if ($TrackRef) {
    $track = $TrackRef
    git config -f .gitmodules "submodule.$submodule.track" $track
}
else {
    $track = git config -f .gitmodules --get "submodule.$submodule.track"
    if (-not $track) { $track = 'master' }
}

git -C $submodule fetch origin $track
git -C $submodule checkout $track

# Run initialization script
& $(Join-Path $submoduleRoot 'init.ps1')
