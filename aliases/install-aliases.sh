#!/bin/bash
# install-aliases.sh - Installs Git aliases from a shared aliases file
# Usage: ./install-aliases.sh [path/to/aliases/file]

set -e

# Determine repository root and name
REPO_ROOT=$(git rev-parse --show-toplevel)
if [ $? -ne 0 ]; then
  echo "Error: Not in a Git repository"
  exit 1
fi

# Get repository name
REPO_NAME=$(basename "$REPO_ROOT")

# Determine if we're in the .agx repository itself or a repository with .agx as a submodule
if [ "$REPO_NAME" = ".agx" ]; then
  BASE_PATH="$REPO_ROOT/aliases"
else
  BASE_PATH="$REPO_ROOT/.agx/aliases"
fi

ALIASES_FILE="$BASE_PATH/agx.aliases"

echo "  🔄 Configuring Git aliases for '$REPO_NAME'..."

# Read the aliases file line by line
count=0
while read -r line; do
  # Skip empty lines and comments
  if [ -z "$line" ] || [[ "$line" =~ ^# ]]; then
    continue
  fi

  # Parse the alias name and value using : as delimiter (split only on the first :)
  alias_key=$(echo "$line" | awk -F':' '{print $1}' | xargs)
  alias_value=$(echo "$line" | awk -F':' '{sub($1":", ""); print}' | xargs)

# FIX: this prints with valid aliases, research!!

  if [ -z "$alias_key" ] || [ -z "$alias_value" ]; then
    echo "  ⚠️ Warning: Invalid alias definition: $line"
    continue
  fi

  # Check if the alias exists and update if different
  current_value=$(git config --local --get "alias.$alias_key" 2>/dev/null)

  if [ -z "$current_value" ]; then
    echo "  ✅ Setting Git alias: $alias_key -> $alias_value"
    git config --local "alias.$alias_key" "$alias_value"
    count=$((count + 1))
  elif [ "$current_value" != "$alias_value" ]; then
    echo "  🔄 Updating Git alias: $alias_key -> $alias_value"
    git config --local "alias.$alias_key" "$alias_value"
    count=$((count + 1))
  fi
done < "$ALIASES_FILE"

if [ "$count" -ne 0 ]; then
  echo "  ✅ $count Git-AgX aliases installed successfully"
fi
