#!/usr/bin/env pwsh
# debug.ps1 - PowerShell version of debug.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string]$File
)

$thisScript = $MyInvocation.MyCommand.Path
if ($(Resolve-Path $File).Path -eq $thisScript) { exit 0 }

if ($env:AGX_PRECOMMIT_SKIPDEBUGCHECK -eq '1') {
    Write-Host '[debug.ps1] ⚠️  Skipping debug statement check due to AGX_PRECOMMIT_SKIPDEBUGCHECK=1'
    exit 0
}

$debugPatterns = @(
    'console\.log',
    'debugger',
    'print\(',
    'Debug\.WriteLine\(',
    'Trace\.WriteLine\(',
    'Console\.WriteLine\(',
    'System\.Diagnostics\.Debugger\.Break\(',
    'Debug\.Assert\(',
    'Trace\.Assert\(',
    '#if +DEBUG',
    'UnityEngine\.Debug\.Log'
)

$pattern = $debugPatterns -join '|'
$debugStatements = Select-String -Path $File -Pattern $pattern -SimpleMatch:$false
if ($debugStatements) {
    Write-Host "❌ Found debug statement(s) in: $File" -ForegroundColor Red
    $debugStatements | ForEach-Object {
        $lineNum = $_.LineNumber
        $lineText = $_.Line.Trim()
        Write-Host ('    @{0}.  {1}' -f $lineNum, $lineText) -ForegroundColor DarkGray
    }

    Write-Host '
💡 Remove debug statements before committing. If you need to keep them, use environment variable AGX_PRECOMMIT_SKIPDEBUGCHECK=1 to skip this check.'

    exit 1
}

exit 0
