#!/bin/bash
# PreToolUse hook example - validates before writing code

# Read input from stdin
input=$(cat)

# Extract tool information
tool_name=$(echo "$input" | jq -r '.tool_name')
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# TODO: Add your validation logic here
# Example: Check for specific patterns

if [[ "$tool_name" == "Edit" || "$tool_name" == "Write" ]]; then
  content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string')

  # TODO: Replace with your validation
  if echo "$content" | grep -q "TODO.*important"; then
    echo "⚠️ Warning: Found important TODO in code" >&2
    # Exit 2 to block operation
    # exit 2
  fi
fi

# Exit 0 to allow operation
exit 0
