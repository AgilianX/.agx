#!/usr/bin/env pwsh
# todo.ps1 - PowerShell version of todo.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Files
)
$blocked = $false
# Common TODO patterns
$todoPatterns = @(
    'TODO',
    'FIXME',
    'BUG',
    'HACK',
    'UNDONE'
)
foreach ($file in $Files) {
    $scriptPath = (Resolve-Path $MyInvocation.MyCommand.Path).Path
    $filePath = (Resolve-Path $file).Path
    if ($filePath -eq $scriptPath) { continue }
    $wordPattern = "\b($($todoPatterns -join '|'))"
    $todoMatches = Select-String -Path $file -Pattern $wordPattern -SimpleMatch:$false -CaseSensitive:$false
    if ($todoMatches) {
        Write-Host "❌ Found TODO-like marker in: $file" -ForegroundColor Red
        $todoMatches | ForEach-Object {
            $lineNum = $_.LineNumber
            $lineText = $_.Line.Trim()
            Write-Host ('    @{0}.  {1}' -f $lineNum, $lineText) -ForegroundColor DarkGray
        }
        $blocked = $true
    }
}
if ($blocked) {
    Write-Host "
💡 Use `TODO:` for short-lived local todos.
   Create issues and link them in the code via // Issue: #IssueNumber for longer-lived / remote tasks."
    exit 1
}
exit 0
