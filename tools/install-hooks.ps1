param([Parameter(Mandatory)]$AgxPaths)
$ErrorActionPreference = 'Stop'
git config --local core.hooksPath $AgxPaths.Hooks.Relative
Write-Host '└─▶✅ Git hooks installed successfully!' -ForegroundColor Green
Write-Host "|     Hooks path: $($AgxPaths.Hooks.Relative)" -ForegroundColor DarkGray
