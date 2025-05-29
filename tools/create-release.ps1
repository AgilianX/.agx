param([Parameter(Mandatory = $true)][string]$sourceBranch)
git merge --squash -X theirs $sourceBranch
git commit
