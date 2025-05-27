# pre-commit.ps1 - PowerShell version for pre-commit
# This script runs before any Git commit
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$TestFiles = @()
)

& $(Resolve-Path(Join-Path $PSScriptRoot '..\\tools\\context-info.ps1'))

$rawFiles = git diff --cached --name-only --diff-filter=ACM | Where-Object { $_ }
$allFiles = $rawFiles + $TestFiles

$hookDir = Join-Path $PSScriptRoot 'checks'
$checkScripts = Get-ChildItem -Path $hookDir -File | Where-Object { $_.Name.EndsWith('.ps1') }
foreach ($file in $allFiles) {
    if (Test-Path $file -PathType Container) { continue }

    $isSubmodule = git ls-files --stage -- "$file" | Select-String '^160000'
    if ($isSubmodule) { continue }

    if ($file -match '\..*ignore$') { continue }
    if ($file.Contains('docs/') ) { continue }
    if ($env:AGX_PRECOMMIT_TEST -ne 'true' -and $file.Contains('hooks/checks/tests/pre-commit') ) { continue }

    foreach ($script in $checkScripts) {
        & $script.FullName $file
        if ($env:AGX_PRECOMMIT_TEST -eq 'true' -and $file.EndsWith('-fail.txt') -and $LASTEXITCODE -ne 0) {
            continue
        }
        elseif ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

Write-Host '✅ All checks passed.' -ForegroundColor Green
exit 0
