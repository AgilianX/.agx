#!/bin/sh
# Hook to display repository information before commit
# This is useful for users and AI agents to maintain context awareness

# Get the repository name
REPO_NAME=$(basename -s .git $(git config --get remote.origin.url 2>/dev/null || echo "local repository"))

# Get the repository root directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# Display repository information
echo "📂 Committing to repository: $(tput bold)${REPO_NAME}$(tput sgr0)"
echo "📁 Repository path: ${REPO_ROOT}"
echo "🔀 Active branch: $(git branch --show-current)"

# This check always passes as it's informational only
exit 0
