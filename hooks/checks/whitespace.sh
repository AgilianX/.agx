#!/bin/sh
# Check for trailing whitespace in staged files
for file in "$@"; do
    # Skip this script itself
    if [ "$file" = "$0" ]; then
        continue
    fi
    # Skip binary/image files and other known types that may have trailing whitespace
    case "$file" in
        *.png|*.jpg|*.jpeg|*.gif|*.ico|*.zip|*.gz|*.tar|*.rar|*.7z|*.exe|*.dll|*.pdf|*.mp3|*.mp4|*.mov|*.avi|*.bin|*.fig)
            continue
            ;;
    esac
    if grep -q -nE "[[:blank:]]+$" "$file"; then
        echo "❌ Found trailing whitespace in: $file"
        exit 1
    fi

done
exit 0
