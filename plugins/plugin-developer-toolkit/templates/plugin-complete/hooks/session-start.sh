#!/bin/bash
# SessionStart initialization hook

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Complete plugin loaded - skill, agent, command, and hooks ready."
  }
}
EOF

exit 0
