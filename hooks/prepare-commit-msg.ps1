param(
    [string]$CommitMsgFile,
    [string]$CommitSource,
    [string]$SHA1
)

$hookDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$initialContent = Get-Content $CommitMsgFile

# Overwrite with template or ai-commit
if ($env:AGX_AI_WORKFLOW -eq 'true') {
    $aiCommit = Join-Path $hookDir '../ai/ai-commit.txt'
    Get-Content $aiCommit | Set-Content $CommitMsgFile
}
else {
    $template = Join-Path $hookDir 'commit-template.txt'
    Get-Content $template | Set-Content $CommitMsgFile
}

# Append the original content (e.g. changed files) if it existed
if ($initialContent.Count -gt 0) {
    Add-Content $CommitMsgFile ''
    $initialContent | ForEach-Object { Add-Content $CommitMsgFile $_ }
}
