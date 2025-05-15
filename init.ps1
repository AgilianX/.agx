# Repository Initialization Script for Windows
#
# This script sets up your local development environment after cloning this repository.
# It configures Git aliases, hooks, and other tools necessary for consistent development workflows.

# Determine repository root and name
try {
    $script:repoRoot = git rev-parse --show-toplevel
    $script:repoName = Split-Path -Leaf $repoRoot
    if ($LASTEXITCODE -ne 0) { throw 'Not in a Git repository' }
}
catch {
    Write-Host '❌ Error: Not in a Git repository' -ForegroundColor Red
    exit 1
}

Write-Host "📦 Initializing repository setup for '$repoName'..." -ForegroundColor Cyan


# Determine if we're in the .agx repository itself or a repository with .agx as a submodule
$script:isAgxRepo = ($repoName -eq '.agx')
$script:basePath = if ($isAgxRepo) { $repoRoot } else { Join-Path $repoRoot '.agx' }
$script:hooksDir = Join-Path $basePath 'hooks'
$script:aliasesDir = Join-Path $basePath 'aliases'
$script:readmePath = Join-Path $basePath 'README.md'

# 1. Install Git hooks
Write-Host '🔧 Installing Git hooks...' -ForegroundColor Cyan
& $(Join-Path $hooksDir 'install-hooks.ps1')

# 2. Install Git aliases
Write-Host '🔧 Installing Git aliases...' -ForegroundColor Cyan
& $(Join-Path $aliasesDir 'install-aliases.ps1')

# Verify aliases were configured properly
Write-Host '🔍 Verifying Git aliases...' -ForegroundColor Cyan
$script:aliasCheck = git config --local --get alias.agx-setup-test
if (-not $aliasCheck) { Write-Host "⚠️ Warning: Git aliases don't appear to be configured correctly" -ForegroundColor Yellow }
else { Write-Host '✅ Git aliases configured successfully' -ForegroundColor Green }

Write-Host '🎉 Repository initialization complete!' -ForegroundColor Green

Write-Host "📚 See $readmePath for more information on repository configuration" -ForegroundColor Cyan

# If this is a consuming repo (not .agx itself), also run init.ps1 in the .agx submodule
if (-not $isAgxRepo) {
    # Only run init.ps1 in the submodule if the current working directory is not inside .agx
    $currentLocation = Get-Location
    $isInAgx = $currentLocation.Path -like '*\.agx'
    if (-not $isInAgx) {
        $agxInitScript = Join-Path $basePath 'init.ps1'
        Write-Host '    Also running .agx submodule initialization script...' -ForegroundColor DarkGray
        Push-Location $basePath
        & $agxInitScript
    }
}
