#!/bin/bash
#
# Repository Initialization Script
#
# This script sets up your local development environment after cloning this repository.
# It configures Git aliases, hooks, and other tools necessary for consistent development workflows.

# Determine repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Error: Not in a Git repository"
    exit 1
fi

# Get repository name from path
REPO_NAME=$(basename "$REPO_ROOT")
echo "📦 Initializing repository setup for '$REPO_NAME'..."

# Determine if we're in the .agx repository itself or a repository with .agx as a submodule
BASE_PATH="$REPO_ROOT/.agx"
if [ "$REPO_NAME" = ".agx" ]; then
    BASE_PATH=$REPO_ROOT
fi

HOOKS_DIR="$BASE_PATH/hooks"
ALIASES_DIR="$BASE_PATH/aliases"
README_PATH="$BASE_PATH/README.md"

# 1. Make all hook scripts executable
echo "🔧 Making Git hooks executable..."
bash "$HOOKS_DIR/make-hooks-executable.sh"

# 2. Install Git hooks
echo "🔧 Installing Git hooks..."
bash "$HOOKS_DIR/install-hooks.sh"

# 3. Install Git aliases
echo "🔧 Installing Git aliases..."
bash "$ALIASES_DIR/install-aliases.sh"

# 4. Check if our aliases are properly configured
echo "🔍 Verifying Git aliases..."
ALIAS_CHECK=$(git config --local --get alias.agx-setup-test)
if [ -z "$ALIAS_CHECK" ]; then
    echo "⚠️ Warning: Git aliases don't appear to be configured correctly"
else
    echo "✅ Git aliases configured successfully"
fi

echo "🎉 Repository initialization complete!"
echo "📚 See $README_PATH for more information on repository configuration"
