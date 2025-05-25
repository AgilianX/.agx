#!/usr/bin/env pwsh
# todo.ps1 - PowerShell version of todo.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string]$File
)

$thisScript = $MyInvocation.MyCommand.Path
if ($(Resolve-Path $File).Path -eq $thisScript) { exit 0 }

$todoPatterns = @(
    'TODO',
    'FIXME',
    'BUG',
    'HACK',
    'UNDONE'
)

$wordPattern = "\b($($todoPatterns -join '|'))"

$todoMatches = Select-String -Path $File -Pattern $wordPattern -SimpleMatch:$false -CaseSensitive:$false

if ($todoMatches) {
    Write-Host "❌ Found TODO-like marker in: $File" -ForegroundColor Red
    $todoMatches | ForEach-Object {
        $lineNum = $_.LineNumber
        $lineText = $_.Line.Trim()
        Write-Host ('    @{0}.  {1}' -f $lineNum, $lineText) -ForegroundColor DarkGray
    }
    Write-Host "
💡 Use `TODO:` for short-lived local todos.
   Create issues and link them in the code via // Issue: #IssueNumber for longer-lived / remote tasks."
    exit 1
}

exit 0
