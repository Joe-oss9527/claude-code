# Hooks Guide

Complete guide to using hooks for event-driven functionality in Claude Code plugins.

## What are Hooks?

**Hooks are event handlers** that execute in response to Claude Code lifecycle events. They enable:
- Validation before operations
- Automation after operations
- Context preservation
- Custom workflows

## Available Hook Types

| Hook | When It Executes | Use Cases |
|------|------------------|-----------|
| **PreToolUse** | Before tool execution | Validation, security checks, linting |
| **PostToolUse** | After tool execution | Formatting, notifications, logging |
| **PreCompact** | Before context compaction | Save important information |
| **SessionStart** | At session initialization | Setup, welcome messages, checks |
| **UserPromptSubmit** | After user submits prompt | Custom processing, skill activation |

## Hook Configuration

### hooks.json Format

```json
{
  "description": "Description of your hooks",
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/validate.sh"
          }
        ],
        "matcher": "Edit|Write"
      }
    ],
    "SessionStart": [
      {
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh"
      }
    ]
  }
}
```

### Hook Structure

```json
{
  "type": "command",           // Always "command"
  "command": "bash script.sh", // Command to execute
  "timeout": 5000              // Optional: timeout in ms
}
```

## PreToolUse Hook

Executes **before** tool operations. Can block execution.

### Use Cases

- Validate code before writing
- Check security patterns
- Enforce coding standards
- Lint code

### Example: Security Validation

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ${CLAUDE_PLUGIN_ROOT}/hooks/security_check.py"
          }
        ],
        "matcher": "Edit|Write|MultiEdit"
      }
    ]
  }
}
```

### Hook Handler (Python)

```python
#!/usr/bin/env python3
import json
import sys

# Read hook input from stdin
input_data = json.loads(sys.stdin.read())

tool_name = input_data.get("tool_name")
tool_input = input_data.get("tool_input", {})

if tool_name in ["Edit", "Write"]:
    content = tool_input.get("new_string") or tool_input.get("content", "")

    # Check for dangerous pattern
    if "eval(" in content:
        print("⚠️ Security Warning: eval() detected!", file=sys.stderr)
        sys.exit(2)  # Exit code 2 blocks execution

# Allow tool to proceed
sys.exit(0)
```

### Exit Codes

- `0`: Allow operation
- `2`: Block operation (show error to user)
- Other: Hook failed (operation proceeds)

## PostToolUse Hook

Executes **after** tool operations. Cannot block (operation already happened).

### Use Cases

- Format code after editing
- Run linters/formatters
- Update documentation
- Trigger builds

### Example: Auto-Format

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/format.sh"
          }
        ],
        "matcher": "Edit|Write"
      }
    ]
  }
}
```

### Hook Handler (Bash)

```bash
#!/bin/bash

# Read input (contains file path)
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Format TypeScript/JavaScript files
if [[ "$file_path" =~ \.(ts|tsx|js|jsx)$ ]]; then
  prettier --write "$file_path"
fi

exit 0
```

## PreCompact Hook

Executes before Claude compacts conversation history.

### Use Cases

- Save important design decisions
- Preserve architecture notes
- Export context to files

### Example: Context Preservation

```json
{
  "hooks": {
    "PreCompact": [
      {
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/save-context.sh"
      }
    ]
  }
}
```

### Hook Handler

```bash
#!/bin/bash

# Read conversation history from stdin
input=$(cat)

# Extract important information
session_id=$(echo "$input" | jq -r '.session_id')
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Save to file
mkdir -p .claude/session-context
echo "$input" > ".claude/session-context/${session_id}_${timestamp}.json"

echo "Context saved" >&2
exit 0
```

## SessionStart Hook

Executes when Claude Code session begins.

### Use Cases

- Display welcome message
- Check dependencies
- Set up environment
- Load configuration

### Example: Dependency Check

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh"
      }
    ]
  }
}
```

### Hook Handler

```bash
#!/bin/bash

# Check for required tools
if ! command -v node &> /dev/null; then
  echo "⚠️ Node.js not found. Some features may not work." >&2
fi

# Display welcome message
cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Welcome! Frontend development guidelines loaded."
  }
}
EOF

exit 0
```

## UserPromptSubmit Hook

Executes after user submits a prompt.

### Use Cases

- Custom prompt processing
- Dynamic skill activation
- Keyword detection

### Example

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/prompt-handler.sh"
      }
    ]
  }
}
```

## Matchers

Filter which tools trigger hooks:

```json
{
  "matcher": "Edit|Write|MultiEdit"  // Matches any of these tools
}
```

Common matchers:
- `"Edit"` - Only Edit tool
- `"Write"` - Only Write tool
- `"Edit|Write"` - Either tool
- `"*"` - All tools (rarely needed)

## Hook Best Practices

### 1. Fast Execution

Hooks should be fast (<1 second):

```bash
# ❌ Slow: Heavy processing
npm run build  # Takes minutes

# ✅ Fast: Quick checks
grep "TODO" "$file"
```

### 2. Graceful Failure

Don't break workflow on hook errors:

```python
try:
    # Hook logic
    pass
except Exception as e:
    # Log error but don't fail
    print(f"Hook error: {e}", file=sys.stderr)
    sys.exit(0)  # Allow operation
```

### 3. Clear Error Messages

When blocking, explain why:

```python
if issue_found:
    print("⚠️ Issue: [clear explanation]", file=sys.stderr)
    print("Fix: [how to resolve]", file=sys.stderr)
    sys.exit(2)
```

### 4. Use Environment Variables

```bash
# ✅ Good: Portable
command "${CLAUDE_PLUGIN_ROOT}/hooks/script.sh"

# ❌ Bad: Hardcoded
command "/absolute/path/script.sh"
```

### 5. Test Hooks Independently

```bash
# Test hook with sample input
echo '{"tool_name":"Edit","tool_input":{}}' | ./hooks/my-hook.sh
```

## Common Patterns

### Pattern 1: Validation with Warning

```python
#!/usr/bin/env python3
import json, sys

input_data = json.loads(sys.stdin.read())
content = input_data.get("tool_input", {}).get("content", "")

issues = []

if "console.log" in content:
    issues.append("Found console.log (remove before production)")

if "debugger" in content:
    issues.append("Found debugger statement")

if issues:
    for issue in issues:
        print(f"⚠️ {issue}", file=sys.stderr)
    # Still allow (exit 0), just warn
    sys.exit(0)

sys.exit(0)
```

### Pattern 2: Auto-Formatting

```bash
#!/bin/bash
set -e

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Format if supported file type
case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx)
    prettier --write "$file_path" 2>/dev/null || true
    ;;
  *.py)
    black "$file_path" 2>/dev/null || true
    ;;
esac

exit 0
```

### Pattern 3: Context Extraction

```typescript
// save-context.ts
import { readFileSync } from 'fs';

const input = JSON.parse(readFileSync(0, 'utf-8'));
const messages = input.messages || [];

// Extract important patterns
const decisions = messages
  .filter(m => /decided to|chose to|went with/i.test(m.content))
  .map(m => m.content);

// Save decisions
if (decisions.length > 0) {
  console.log('Preserved design decisions:', decisions.length);
}

process.exit(0);
```

## Debugging Hooks

### Add Logging

```bash
#!/bin/bash

# Log to file
echo "Hook executed: $(date)" >> /tmp/hook-debug.log
echo "Input: $(cat)" >> /tmp/hook-debug.log
```

### Check Hook Output

```bash
# Test hook directly
echo '{"tool_name":"Edit"}' | bash hooks/my-hook.sh

# Check exit code
echo $?  # Should be 0 (allow) or 2 (block)
```

### Verify JSON Output

For SessionStart hooks:

```bash
# Output must be valid JSON
bash hooks/session-start.sh | jq .
```

## Checklist

Before deploying hooks:

- ✅ hooks.json is valid JSON
- ✅ Hook scripts are executable (`chmod +x`)
- ✅ Scripts use `${CLAUDE_PLUGIN_ROOT}`
- ✅ Exit codes are correct (0 or 2)
- ✅ Error messages are clear
- ✅ Execution is fast (<1s)
- ✅ Graceful error handling
- ✅ Tested independently
- ✅ Documented in README

## Resources

- [Official Hooks Documentation](https://docs.claude.com/en/docs/claude-code/hooks)
