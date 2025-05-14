# Ensure the script is executed within a Git repository
try {
    $script:repoRoot = git rev-parse --show-toplevel
    $script:repoName = Split-Path -Leaf $repoRoot
}
catch {
    Write-Host '❌ Error: Not in a Git repository' -ForegroundColor Red
    exit 1
}

# Determine if we're in the .agx repository itself or a repository with .agx as a submodule
$script:isAgxRepo = ($repoName -eq '.agx')
$script:hooksPath = if ($isAgxRepo) { 'hooks' } else { '.agx/hooks' }

Write-Host "  ⚙️ Configuring Git hooks for '$repoName'..." -ForegroundColor Cyan

# Configure Git to use the appropriate hooks directory
git config --local core.hooksPath $hooksPath

Write-Host '  ✅ Git hooks installed successfully!' -ForegroundColor Green
