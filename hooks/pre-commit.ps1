# pre-commit.ps1 - PowerShell version for pre-commit
# This script runs before any Git commit

# Get staged files (not deleted), filter out directories and submodules (gitlinks)
$rawFiles = git diff --cached --name-only --diff-filter=ACM | Where-Object { $_ }
$files = @()
foreach ($file in $rawFiles) {
    if (Test-Path $file -PathType Container) { continue }
    $isSubmodule = git ls-files --stage -- "$file" | Select-String '^160000'
    if ($isSubmodule) { continue }
    $files += $file
}

# Run each check script on filtered staged files
$hookDir = Join-Path $PSScriptRoot 'checks'
$checkScripts = Get-ChildItem -Path $hookDir -File | Where-Object { $_.Name.EndsWith('.ps1') }
foreach ($script in $checkScripts) {
    if ($files.Count -gt 0) {
        & $script.FullName @files
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}
Write-Host '✅ All checks passed.' -ForegroundColor Green
exit 0
