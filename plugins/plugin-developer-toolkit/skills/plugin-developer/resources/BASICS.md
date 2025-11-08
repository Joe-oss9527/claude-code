# Plugin Basics

Essential knowledge for creating Claude Code plugins.

## What is a Plugin?

A plugin is a directory structure that extends Claude Code's functionality. Plugins can add:
- **Skills**: Automatically activated capabilities
- **Agents**: Specialized sub-agents
- **Commands**: User-invoked actions
- **Hooks**: Event handlers
- **MCP Servers**: External tool integrations

## Official Plugin Structure

```
your-plugin/
├── .claude-plugin/
│   └── plugin.json          # Required: Metadata
├── skills/                   # Optional
│   └── skill-name/
│       ├── SKILL.md         # Skill definition
│       └── resources/       # Optional sub-resources
├── agents/                   # Optional
│   └── agent-name.md
├── commands/                 # Optional
│   └── command-name.md
├── hooks/                    # Optional
│   ├── hooks.json
│   └── handlers/
└── README.md                # Recommended
```

## plugin.json (Required)

Every plugin must have `.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "description": "What this plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "your@email.com"
  },
  "keywords": ["keyword1", "keyword2"],
  "repository": {
    "type": "git",
    "url": "https://github.com/user/repo"
  }
}
```

**Required fields**:
- `name`: Plugin identifier (kebab-case)
- `description`: Clear, concise explanation
- `version`: Semantic versioning (MAJOR.MINOR.PATCH)

**Recommended fields**:
- `author`: Creator information
- `keywords`: Improve discoverability
- `repository`: Source code location

## Plugin Installation

### Method 1: Copy to Plugins Directory

```bash
cp -r my-plugin ~/.claude/plugins/
```

### Method 2: Symlink (for development)

```bash
ln -s $(pwd)/my-plugin ~/.claude/plugins/my-plugin
```

### Method 3: Package Manager (future)

```bash
claude plugin install my-plugin
```

## Plugin Discovery

Claude Code automatically discovers plugins in:
- `~/.claude/plugins/` (global)
- `./.claude/plugins/` (project-local)

On startup, Claude:
1. Scans plugin directories
2. Reads `plugin.json` metadata
3. Loads skill descriptions (lightweight)
4. Registers commands and hooks

## Environment Variables

Plugins can use these environment variables:

- `${CLAUDE_PLUGIN_ROOT}`: Current plugin directory
- `${CLAUDE_PROJECT_DIR}`: Project root directory (deprecated, use CLAUDE_PLUGIN_ROOT)

**Example**:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/hooks/handler.sh
```

## Naming Conventions

**Plugin names**: kebab-case
- ✅ `my-awesome-plugin`
- ❌ `MyAwesomePlugin`, `my_awesome_plugin`

**Skill names**: kebab-case or snake_case
- ✅ `react-component-generator`
- ✅ `react_component_generator`

**Agent names**: kebab-case
- ✅ `code-reviewer`

**Command names**: kebab-case
- ✅ `/commit-and-push`

## Common Mistakes

### 1. Invalid JSON

```json
{
  "name": "my-plugin",
  "description": "My plugin"   // ❌ Trailing comma
}
```

**Fix**: Remove trailing commas, validate JSON

### 2. Missing YAML Frontmatter

```markdown
# My Skill    <!-- ❌ No frontmatter -->

This is my skill...
```

**Fix**: Add YAML frontmatter:
```yaml
---
name: my-skill
description: What it does
---
```

### 3. Wrong Directory Structure

```
my-plugin/
└── plugin.json    ❌ Wrong location
```

**Fix**: Must be in `.claude-plugin/`:
```
my-plugin/
└── .claude-plugin/
    └── plugin.json    ✅ Correct
```

## Debugging Plugins

### Check Plugin is Loaded

```bash
# Claude loads plugins on startup
# Check logs or ask: "What plugins are available?"
```

### Test Skill Activation

```
You: "Use my-skill"
# Should activate the skill explicitly
```

### Test Command

```
You: /my-command
# Should execute the command
```

### Check Hooks

Add debug output to hook scripts:
```bash
echo "Hook executed at $(date)" >> /tmp/hook-debug.log
```

## Distribution

### Sharing Plugins

1. **GitHub Repository**:
   ```bash
   git clone https://github.com/user/plugin-name
   cd plugin-name
   cp -r . ~/.claude/plugins/plugin-name
   ```

2. **Zip Archive**:
   ```bash
   zip -r my-plugin.zip my-plugin/
   # User extracts to ~/.claude/plugins/
   ```

3. **Documentation**:
   - Include comprehensive README
   - Add installation instructions
   - Provide usage examples
   - List requirements

## Official Documentation

- [Claude Code Plugins](https://docs.claude.com/en/docs/claude-code/plugins)
- [Skills Documentation](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Hooks Reference](https://docs.claude.com/en/docs/claude-code/hooks)

## Quick Start Checklist

Creating your first plugin:

1. ✅ Create plugin directory
2. ✅ Add `.claude-plugin/plugin.json`
3. ✅ Choose component type (skill/agent/command/hook)
4. ✅ Create component files
5. ✅ Write README with examples
6. ✅ Test locally
7. ✅ Add to version control
8. ✅ Share with team/community

## Next Steps

Now that you understand the basics:
- Read SKILLS_GUIDE.md to create skills
- Read AGENTS_GUIDE.md to create agents
- Read COMMANDS_GUIDE.md to create commands
- Read HOOKS_GUIDE.md to use hooks
