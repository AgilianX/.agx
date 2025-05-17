# Typically invoked by git agx-revert-update
$ErrorActionPreference = 'Stop'
$repoRoot = git rev-parse --show-toplevel
$repoName = Split-Path $repoRoot -Leaf
$submodule = '.agx'
if ($repoName -eq $submodule) { exit 1 }
Set-Location $repoRoot

$previousCommitHash = git config --local --get "$submodule.previousCommitHash"
if (-not $previousCommitHash) {
    Write-Error "No previous commit hash found in '$submodule.previousCommitHash'"
    exit 1
}

git config --local "$submodule.autosync" false
git agx-update $previousCommitHash

Write-Host "✅ $submodule submodule reverted to previous commit: $previousCommitHash"
Write-Host 'To save this change, commit the updated submodule reference:'
Write-Host "  git add $submodule .gitmodules"
Write-Host '  git commit -m \'chore($submodule): revert $submodule submodule to $previousCommitHash\""
