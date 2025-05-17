# Repository Info Script for Git Aliases and Hooks
# Displays repository context for users and AI agents

$ErrorActionPreference = 'Stop'

# Get the repository name (from remote if available, else folder name)
$remoteUrl = git config --get remote.origin.url 2>$null
if ($remoteUrl) {
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($remoteUrl)
}
else {
    $repoName = Split-Path (git rev-parse --show-toplevel) -Leaf
}

# Get the repository root directory
$repoRoot = git rev-parse --show-toplevel

# Get the active branch
$branch = git branch --show-current

# Function to display submodules on a single line, comma-separated and in single quotes
function Write-Submodules() {
    $submodules = git config --file (Join-Path $repoRoot '.gitmodules') --get-regexp '^submodule\..*\.path$' 2>$null
    if ($submodules) {
        $submoduleNames = @()
        $submodules -split "`n" | ForEach-Object {
            $parts = $_ -split ' '
            if ($parts.Length -eq 2) {
                $submoduleNames += "'$($parts[1])'"
            }
        }
        if ($submoduleNames.Count -gt 0) {
            Write-Host ('🧩 Submodules: ' + ($submoduleNames -join ', ')) -ForegroundColor Cyan
        }
    }
}

# Display repository information
Write-Host "📂 Repository: $repoName" -ForegroundColor Cyan
Write-Submodules $repoRoot
Write-Host "📁 Repository path: $repoRoot" -ForegroundColor DarkGray
Write-Host "🔀 Active branch: $branch" -ForegroundColor DarkGray

# This check always passes as it's informational only
exit 0
