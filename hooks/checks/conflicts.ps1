#!/usr/bin/env pwsh
# conflicts.ps1 - PowerShell version of conflicts.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Files
)
foreach ($file in $Files) {
    # Compare file paths using full path resolution
    $scriptPath = (Resolve-Path $MyInvocation.MyCommand.Path).Path
    $filePath = (Resolve-Path $file).Path
    if ($filePath -eq $scriptPath) { continue }
    $conflictMatches = Select-String -Path $file -Pattern '<<<<<<<|=======|>>>>>>>'
    if ($conflictMatches) {
        Write-Host "❌ Found merge conflict markers in: $file" -ForegroundColor Red
        $conflictMatches | ForEach-Object {
            $lineNum = $_.LineNumber
            $lineText = $_.Line.Trim()
            Write-Host ("    @{0}.  {1}" -f $lineNum, $lineText) -ForegroundColor DarkGray
        }
        exit 1
    }
}
exit 0
