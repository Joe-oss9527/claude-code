# My Hooks Plugin

Plugin demonstrating event hooks for validation and automation.

## What This Plugin Provides

### Hooks

1. **PreToolUse** - Validates before code edits
   - Triggers: Before Edit or Write operations
   - Purpose: Check for patterns, enforce rules

2. **SessionStart** - Initializes session
   - Triggers: When Claude Code starts
   - Purpose: Environment checks, welcome message

## Installation

```bash
cp -r my-hooks-plugin ~/.claude/plugins/

# Make hook scripts executable
chmod +x ~/.claude/plugins/my-hooks-plugin/hooks/*.sh
```

## Usage

Hooks run automatically:

- **PreToolUse**: Executes before file edits
- **SessionStart**: Executes when starting Claude

## Customization

### Edit Hook Logic

1. Open `hooks/pre-tool-use.sh`
2. Replace TODO sections with your validation logic
3. Test the hook

### Add More Hooks

Edit `hooks/hooks.json` to add:
- PostToolUse
- PreCompact
- UserPromptSubmit

## Exit Codes

PreToolUse hooks:
- `0`: Allow operation
- `2`: Block operation (show error message)

Other hooks:
- `0`: Success
- Non-zero: Error (operation continues)

## Testing

```bash
# Test PreToolUse hook
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.ts","content":"test"}}' | bash hooks/pre-tool-use.sh

# Check exit code
echo $?  # Should be 0 or 2
```

## Structure

```
my-hooks-plugin/
├── .claude-plugin/
│   └── plugin.json
├── hooks/
│   ├── hooks.json
│   ├── pre-tool-use.sh
│   └── session-start.sh
└── README.md
```

## License

MIT
