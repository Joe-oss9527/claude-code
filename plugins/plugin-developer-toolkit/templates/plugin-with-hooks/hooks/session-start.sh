#!/bin/bash
# SessionStart hook example - runs when Claude Code starts

# TODO: Add your session initialization logic

# Example: Check for required tools
if ! command -v node &> /dev/null; then
  message="⚠️ Node.js not found. Some features may not work."
else
  message="✓ Environment checks passed"
fi

# Output to Claude
cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$message"
  }
}
EOF

exit 0
