param([Parameter(Mandatory = $true)][string]$submodulePath)

# Get the diff line for the submodule
$diffLine = git agx-ai-diff-staged $submodulePath | Select-String -Pattern '^[-+]Subproject commit' | ForEach-Object { $_.Line }

if ($diffLine.Count -eq 2) {
    $oldCommit = $diffLine[0] -replace '^[-+]Subproject commit ', ''
    $newCommit = $diffLine[1] -replace '^[-+]Subproject commit ', ''
    Write-Host 'Submodule commit range:' -ForegroundColor DarkGray
    Write-Host "    $oldCommit..$newCommit" -ForegroundColor DarkGray
    $commitRange = "$oldCommit..$newCommit"
    & git -C $submodulePath --no-pager log $commitRange
}
else {
    Write-Host "Could not determine submodule commit range from 'git agx-ai-diff-staged $submodulePath'." -ForegroundColor Red
    exit 1
}
