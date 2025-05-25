#!/usr/bin/env pwsh
# conflicts.ps1 - PowerShell version of conflicts.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string]$File
)

$thisScript = $MyInvocation.MyCommand.Path
if ($(Resolve-Path $File).Path -eq $thisScript) { exit 0 }

$conflictMatches = Select-String -Path $File -Pattern '<<<<<<<|=======|>>>>>>>'

if ($conflictMatches) {
    Write-Host "❌ Found merge conflict markers in: $File" -ForegroundColor Red
    $conflictMatches | ForEach-Object {
        $lineNum = $_.LineNumber
        $lineText = $_.Line.Trim()
        Write-Host ('    @{0}.  {1}' -f $lineNum, $lineText) -ForegroundColor DarkGray
    }
    exit 1
}

exit 0
