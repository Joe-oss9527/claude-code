# My Complete Plugin

Full-featured reference plugin demonstrating all Claude Code plugin components.

## Components

### 1. Skill (Model-Invoked)
- **Name**: example-skill
- **Activates**: Automatically based on context
- **Purpose**: TODO

### 2. Agent (Specialized)
- **Name**: example-agent
- **Usage**: `Launch example-agent`
- **Purpose**: TODO

### 3. Command (User-Invoked)
- **Name**: /example-command
- **Usage**: `/example-command [args]`
- **Purpose**: TODO

### 4. Hooks (Event-Driven)
- **PreToolUse**: Validation before edits
- **PostToolUse**: Automation after edits
- **SessionStart**: Initialization

## Installation

```bash
cp -r my-complete-plugin ~/.claude/plugins/
chmod +x ~/.claude/plugins/my-complete-plugin/hooks/*.sh
```

## Usage

### Using the Skill
Ask Claude about [topic] to activate the skill automatically.

### Using the Agent
```
You: "Launch example-agent to analyze [something]"
```

### Using the Command
```
You: "/example-command arg1 arg2"
```

### Hooks
Hooks run automatically at appropriate times.

## Customization

Replace TODO markers with your implementation:
1. Edit skill description and content
2. Define agent capabilities
3. Implement command logic
4. Add hook validation/automation

## Structure

```
my-complete-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── example-skill/
│       └── SKILL.md
├── agents/
│   └── example-agent.md
├── commands/
│   └── example-command.md
├── hooks/
│   ├── hooks.json
│   ├── pre-tool-use.sh
│   ├── post-tool-use.sh
│   └── session-start.sh
└── README.md
```

## License

MIT
