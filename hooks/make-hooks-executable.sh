# Get the repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
if [ $? -ne 0 ]; then
    echo "Error: Not in a Git repository"
    exit 1
fi

# Get repository name
REPO_NAME=$(basename "$REPO_ROOT")

# Determine if we're in the .agx repository itself or a repository with .agx as a submodule
if [ "$REPO_NAME" = ".agx" ]; then
    HOOKS_DIR="$REPO_ROOT/hooks"
else
    HOOKS_DIR="$REPO_ROOT/.agx/hooks"
fi

# Recursively find all files without extensions in the hooks directory and make them executable
find "$HOOKS_DIR" -type f ! -name "*.*" -exec chmod +x {} \;

# Make all shell scripts executable
find "$HOOKS_DIR" -name "*.sh" -exec chmod +x {} \;

echo "  All hooks are now executable!"
