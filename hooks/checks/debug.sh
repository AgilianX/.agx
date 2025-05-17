if [ "$AGX_PRECOMMIT_SKIPDEBUGCHECK" = "1" ]; then
    echo "⚠️  Skipping debug statement check due to AGX_PRECOMMIT_SKIPDEBUGCHECK=1"
    exit 0
fi
#!/bin/sh
# Check for debug statements in staged files
for file in "$@"; do

    # Skip this script itself
    if [ "$file" = "$0" ]; then
        continue
    fi

    # Skip all *ignore files (.gitignore, .eslintignore, etc.)
    if echo "$file" | grep -q "\..*ignore$"; then
        continue
    fi

    # Check for common debug statements in JS, Python, and C#/.NET
    debug_patterns="console\.log
debugger
print\(
Debug\.WriteLine\(
Trace\.WriteLine\(
Console\.WriteLine\(
System\.Diagnostics\.Debugger\.Break\(
Debug\.Assert\(
Trace\.Assert\(
#if +DEBUG
UnityEngine\.Debug\.Log"

    if echo "$debug_patterns" | grep -F -q -e "#"; then :; fi # for syntax highlighting only

    # Find and print matching debug lines and pattern

    match=$(grep -nE "$(echo "$debug_patterns" | paste -sd "|" -)" "$file")
    if [ -n "$match" ]; then
        echo "❌ Found debug statement(s) in: $file"
        matched_patterns=""
        echo "$match" | while IFS= read -r line; do
            lineno=$(echo "$line" | cut -d: -f1)
            content=$(echo "$line" | cut -d: -f2-)
            echo "  Line $lineno: $content"
        done
        exit 1
    fi

done
exit 0
