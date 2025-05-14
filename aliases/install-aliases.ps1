# Repository Aliases Installation Script for Windows
#
# This script installs Git aliases from a shared aliases file
# Usage: .\install-aliases.ps1 [path\to\aliases\file]

# Determine repository root and name
try {
    $script:repoRoot = git rev-parse --show-toplevel
    $script:repoName = Split-Path -Leaf $repoRoot
}
catch {
    Write-Host '❌ Error: Not in a Git repository' -ForegroundColor Red
    exit 1
}

$script:isAgxRepo = ($repoName -eq '.agx')
$script:basePath = if ($isAgxRepo) { $repoRoot } else { Join-Path $repoRoot '.agx' }
$script:aliasesFile = Join-Path $basePath 'aliases/agx.aliases'

Write-Host "  ⚙️ Configuring Git aliases for '$repoName'..." -ForegroundColor Cyan

$script:existingCount = 0
$script:existingAliases = git config --get-regexp '^alias\.agx-' | ForEach-Object { $_.Split(' ')[0].Substring(6) }
$script:existingCount = $existingAliases.Count
if ($existingCount -ne 0) { Write-Host "  ℹ️  $existingCount Git-AgX aliases already configured" -ForegroundColor Cyan }

$script:count = 0
foreach ($line in Get-Content $aliasesFile) {
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { continue }

    $parts = $line -split ':', 2
    if ($parts.Length -ne 2) {
        Write-Host "⚠️ Warning: Invalid alias definition: $line" -ForegroundColor Yellow
        continue
    }

    $aliasKey = $parts[0].Trim()
    $aliasValue = $parts[1].Trim()

    if ([string]::IsNullOrWhiteSpace($aliasKey) -or [string]::IsNullOrWhiteSpace($aliasValue)) {
        Write-Host "⚠️ Warning: Invalid alias definition: $line" -ForegroundColor Yellow
        continue
    }

    $currentValue = git config --local --get "alias.$aliasKey" 2>$null

    if (-not $currentValue) {
        Write-Host "  ✅ Setting Git alias: $aliasKey -> $aliasValue" -ForegroundColor Green
        git config --local "alias.$aliasKey" $aliasValue
        $count++
    }
    elseif ($currentValue -ne $aliasValue) {
        Write-Host "  🔄 Updating Git alias: $aliasKey -> $aliasValue" -ForegroundColor Blue
        git config --local "alias.$aliasKey" $aliasValue
        $count++
    }
}

if ($count -ne 0) { Write-Host "  ✅ $count Git-AgX aliases installed successfully" -ForegroundColor Green }
