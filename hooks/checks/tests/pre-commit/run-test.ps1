# Runs the pre-commit.ps1 script with all test files in this folder

# Use the pre-commit subfolder for test files
$testFiles = Get-ChildItem -Path $PSScriptRoot -File | ForEach-Object { $_.FullName }

# Convert file paths to relative paths from the repo root
$repoRoot = git rev-parse --show-toplevel
$relativeTestFiles = $testFiles | ForEach-Object { $_.Replace($repoRoot + '\', '') }

# Set the environment variable to allow test files
$env:AGX_PRECOMMIT_TEST = 'true'

# Run the pre-commit.ps1 script with all test files
& "$repoRoot/hooks/pre-commit.ps1" -TestFiles $relativeTestFiles

# Reset the environment variable
Remove-Item Env:AGX_PRECOMMIT_TEST
