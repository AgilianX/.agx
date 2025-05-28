param(
    [string]$CommitMsgFile,
    [string]$CommitSource,
    [string]$SHA1
)

$hookDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$initialContent = Get-Content $CommitMsgFile

# Overwrite with template or ai-commit
if ($env:AGX_AI_WORKFLOW -eq 'true') {
    $aiCommit = Join-Path $hookDir '../ai-prompts/git/temp/ai-commit.txt'
    $content = Get-Content $aiCommit -Raw
    $trimmed = $content.Trim()
    Set-Content $CommitMsgFile $trimmed
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
