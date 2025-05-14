# Get the repository root directory
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Error: Not in a Git repository"
    exit 1
fi

# Get repository name
REPO_NAME=$(basename "$REPO_ROOT")

# Determine if we're in the .agx repository itself or a repository with .agx as a submodule
if [ "$REPO_NAME" = ".agx" ]; then
    HOOKS_PATH="hooks"
else
    HOOKS_PATH=".agx/hooks"
fi

# Configure git to use the appropriate hooks directory
echo "  ⚙️ Configuring Git hooks for '$REPO_NAME'..."
git config --local core.hooksPath "$HOOKS_PATH"

echo "  ✅ Git hooks installed successfully! (using $HOOKS_PATH)"
