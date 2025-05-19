#!/usr/bin/env pwsh
# repo_info.ps1 - PowerShell version of repo_info.sh
# Display repository information before commit
$repoName = (git config --get remote.origin.url 2>$null | Split-Path -LeafBase)
if (-not $repoName) { $repoName = 'local repository' }
$repoRoot = git rev-parse --show-toplevel
$branch = git branch --show-current
Write-Host "📂 Committing to repository: $repoName" -ForegroundColor Cyan
Write-Host "📁 Repository path: $repoRoot" -ForegroundColor DarkGray
Write-Host "📝 Active branch: $branch" -ForegroundColor DarkGray
exit 0
