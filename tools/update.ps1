param([string]$TrackRef)

# typically invoked by git agx-update
$repoRoot = git rev-parse --show-toplevel
$repoName = Split-Path $repoRoot -Leaf
$submodule = '.agx'
if ($repoName -eq $submodule) { exit 0 }
$submoduleRoot = Join-Path $repoRoot $submodule
Set-Location $repoRoot

# Check if the submodule is already initialized
$currentCommitHash = (git submodule status $submodule) -replace '^-', '' -split ' ' | Select-Object -First 1
if ($currentCommitHash) {
    git config --local agx.previousCommitHash $currentCommitHash
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
$stashedTimestamp = & (Join-Path $PSScriptRoot 'auto-stash.ps1')

# Find local commits in the submodule that are not on the remote tracking branch
$localCommits = git -C $submodule log $track..HEAD --format="%H" | Select-Object -Reverse

try {
    # Check if $track is a branch or commit hash
    if (git -C $submodule show-ref --verify --quiet "refs/heads/$track") {
        git -C $submodule checkout $track
        git -C $submodule reset --hard origin/$track
    }
    else {
        git -C $submodule checkout $track
    }
}
catch {
    Write-Host "└─▶⚠️ Track reference '$track' is not a valid branch or commit hash in submodule '$submodule'.
        Please check your configuration." -ForegroundColor Red
    exit 1
}

# Cherry-pick local commits if there are any
if ($localCommits) {
    git -C $submodule cherry-pick $($localCommits -join ' ')
}

# Run initialization script
& $(Join-Path $submoduleRoot 'tools/init.ps1')

# Restore auto-stashed changes if any
if ($null -ne $stashedTimestamp) {
    & (Join-Path $PSScriptRoot 'auto-stash.ps1') -Timestamp $stashedTimestamp
}
