#!/usr/bin/env pwsh
# debug.ps1 - PowerShell version of debug.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Files
)
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
foreach ($file in $Files) {
    $scriptPath = (Resolve-Path $MyInvocation.MyCommand.Path).Path
    $filePath = (Resolve-Path $file).Path
    if ($filePath -eq $scriptPath) { continue }
    if ($filePath -match '\..*ignore$') { continue }
    $pattern = $debugPatterns -join '|'
    $debugStatements = Select-String -Path $file -Pattern $pattern -SimpleMatch:$false
    if ($debugStatements) {
        Write-Host "❌ Found debug statement(s) in: $file" -ForegroundColor Red
        $debugStatements | ForEach-Object {
            $lineNum = $_.LineNumber
            $lineText = $_.Line.Trim()
            Write-Host ('    @{0}.  {1}' -f $lineNum, $lineText) -ForegroundColor DarkGray
        }
        exit 1
    }
}
exit 0
