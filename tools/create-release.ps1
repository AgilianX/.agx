param([Parameter(Mandatory = $true)][string]$sourceBranch)
git merge --squash $sourceBranch
git commit
