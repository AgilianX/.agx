# Repository Initialization Script for Windows
#
# This script sets up your local development environment after cloning this repository.
# It configures Git aliases, hooks, and other tools necessary for consistent development workflows.

$ErrorActionPreference = 'Stop'
try {
    $repoRoot = git rev-parse --show-toplevel
    $repoName = Split-Path -Leaf $repoRoot
    $isInAgxRoot = ($repoName -eq '.agx')
    $agxRoot = if ($isInAgxRoot) { $repoRoot } else { Join-Path $repoRoot '.agx' }
}
catch {
    Write-Host '❌ Error: Not in a Git repository' -ForegroundColor Red
    exit 1
}

Write-Host "📦 Setting up repository '$repoName'" -ForegroundColor Cyan

# Returns an object with Relative/Absolute paths for a given logical name (e.g. 'hooks'),
# handling .agx root/submodule logic internally.
function Get-AgxPathObj($name) {
    $rel = if ($isInAgxRoot) { $name } else { ".agx/$name" }
    return [PSCustomObject]@{
        Relative = $rel
        Absolute = Join-Path $repoRoot $rel
    }
}

# Returns the value of a setting in local git config, or sets it to a default if not set.
function Get-GitLocalConfig-Setting {
    param([string]$setting, [string]$defaultValue = 'true')
    $value = git config --local --get agx.$setting
    if (-not $value) {
        git config --local agx.$setting $defaultValue
        return $defaultValue
    }
    return $value
}

# Returns the value of a setting in .gitmodules, or sets it to a default if not set.
function Get-GitSubmoduleConfig-Setting {
    param([string]$setting, [string]$defaultValue = 'true')
    $key = "submodule..agx.$setting"
    $value = git config -f .gitmodules --get $key
    if (-not $value) {
        git config -f .gitmodules $key $defaultValue
        return $defaultValue
    }
    return $value
}

# Returns the value of a setting in .gitmodules (if not in .agx root) or local git config (if in .agx root), or sets it to a default if not set.
function Get-GitAgx-Setting {
    param([string]$setting, [string]$defaultValue = 'true')
    if ($isInAgxRoot) { return Get-GitLocalConfig-Setting $setting $defaultValue }
    else {
        $value = git config --local --get agx.$setting # local override
        if (-not $value) {
            $value = Get-GitSubmoduleConfig-Setting $setting $defaultValue
        }
        return $value
    }
}

# Check if the Git aliases are configured correctly
function Test-GitAliasesConfigured {
    $aliasExists = git config --local --get alias.agx-setup-test
    if (-not $aliasExists) {
        Write-Host "|  ⚠️ Warning: Git aliases don't appear to be configured correctly" -ForegroundColor Yellow
    }

    # Try invoking the alias, suppressing output and errors
    try {
        git agx-setup-test *> $null
    }
    catch {
        Write-Host "|  ⚠️ Warning: Git alias 'agx-setup-test' failed to execute" -ForegroundColor Yellow
    }
}

$AgxPaths = [PSCustomObject]@{
    RepoRoot = $repoRoot
    AgxRoot  = $agxRoot
    Readme   = Join-Path $agxRoot 'README.md'
    Ai       = Get-AgxPathObj 'ai'
    Docs     = Get-AgxPathObj 'docs'
    Hooks    = Get-AgxPathObj 'hooks'
    Tools    = Get-AgxPathObj 'tools'
}

if (-not $isInAgxRoot) {
    $autoSync = Get-GitLocalConfig-Setting 'autosync'
    Write-Host "|     AutoSync: $autoSync" -ForegroundColor DarkGray

    $track = Get-GitSubmoduleConfig-Setting 'track' 'master'
    Write-Host "|     Track: $track" -ForegroundColor DarkGray

    Write-Host '|     Updating AgX ...' -ForegroundColor DarkGray
    $checkoutOutput = git -C .agx checkout $track 2>&1
    foreach ($line in $checkoutOutput) {
        Write-Host "|         $line" -ForegroundColor DarkGray
    }
}

if ($(Get-GitAgx-Setting 'useHooks') -eq 'true') {
    & (Join-Path $AgxPaths.Tools.Absolute 'install-hooks.ps1') -AgxPaths $AgxPaths
}
if ($(Get-GitAgx-Setting 'useAliases') -eq 'true') {
    & (Join-Path $AgxPaths.Tools.Absolute 'install-aliases.ps1') -AgxPaths $AgxPaths -isInAgxRoot:$isInAgxRoot
}

Test-GitAliasesConfigured

Write-Host "└─▶🎉 Repository '$repoName' initialization complete!" -ForegroundColor Green
Write-Host "📚 See $($AgxPaths.Readme) for more information on repository configuration" -ForegroundColor Cyan

# If this is a consuming repo (not .agx itself), also run init.ps1 in the .agx submodule
if (-not $isInAgxRoot) {
    # Only run init.ps1 in the submodule if the current working directory is not inside .agx
    $currentLocation = Get-Location
    $isInAgx = $currentLocation.Path -like '*\.agx'
    if (-not $isInAgx) {
        $agxInitScript = Join-Path $PSScriptRoot 'init.ps1'
        Write-Host "`n`n    Running the init script in the '.agx' submodule...`n`n" -ForegroundColor DarkGray
        Set-Location $agxRoot
        & $agxInitScript
        Set-Location $repoRoot
    }
}
