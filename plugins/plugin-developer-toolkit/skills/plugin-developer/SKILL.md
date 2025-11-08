---
name: plugin-developer
description: Guide for creating and developing Claude Code plugins, skills, agents, commands, and hooks. Use when user wants to create plugins, understand plugin architecture, or extend Claude Code functionality. Provides templates, best practices, and interactive assistance.
---

# Plugin Developer Toolkit

## I Am a Meta-Skill (Self-Demonstrating)

I help you create Claude Code plugins and skills. **I am my own best example** - by examining my structure, you can learn plugin development patterns:

- This SKILL.md is my entry point (~400 lines)
- My resources are organized in `./resources/`
- My templates are ready to use in `./templates/`
- My entire structure follows official best practices

**Learn by example**: Want to understand skills? Look at how I'm built!

## What I Can Do

### 1. Teach Plugin Development

I provide comprehensive guidance on:
- Plugin architecture and structure
- Creating skills (model-invoked)
- Creating agents (specialized sub-agents)
- Creating slash commands (user-invoked)
- Using hooks (event handlers)
- Best practices and patterns

### 2. Generate Plugins Interactively

When you ask me to create a plugin, I will:
1. Ask about your plugin's purpose
2. Suggest appropriate structure (skill/agent/command/hook)
3. Generate boilerplate from templates
4. Add your custom logic
5. Create comprehensive documentation
6. Ensure it follows official specifications

### 3. Provide Ready-to-Use Templates

I include 4 battle-tested templates:
- **plugin-basic**: Minimal plugin structure
- **plugin-with-skill**: Plugin with a skill (model-invoked)
- **plugin-with-hooks**: Plugin with event hooks
- **plugin-complete**: Full-featured plugin (skill + agent + command + hook)

## Quick Reference Guide

### Plugin Components

**What's a Plugin?**
A plugin extends Claude Code with custom functionality. It can contain:

| Component | Purpose | Invoked By | Location |
|-----------|---------|------------|----------|
| **Skill** | Model-invoked capability | Claude (automatic) | `skills/` |
| **Agent** | Specialized sub-agent | Claude or user | `agents/` |
| **Command** | User-invoked action | User (explicit `/cmd`) | `commands/` |
| **Hook** | Event handler | System events | `hooks/` |
| **MCP Server** | External tool integration | Various | `mcp/` |

### Skills vs Commands

This is a common confusion point:

**Skills** (`skills/` directory):
- ✅ Automatically activated by Claude based on context
- ✅ Loaded when description matches user's need
- ✅ Best for: Capabilities that should be available contextually
- ✅ Example: "Generate documentation when user asks for docs"

**Commands** (`commands/` directory):
- ✅ Explicitly invoked by user with `/command-name`
- ✅ Require user action to trigger
- ✅ Best for: Specific workflows and operations
- ✅ Example: "/commit - Create a git commit"

**When to use what:**
- Use **skill** if it should activate based on what user is discussing
- Use **command** if user should explicitly trigger it

## Learning Resources

I organize knowledge into focused resources. When you need detailed information, I'll load the relevant resource:

### Core Topics

- 📚 **Plugin Basics** → `./resources/BASICS.md`
  - Plugin structure and anatomy
  - Official specifications
  - File organization
  - Metadata (plugin.json)

- 🎯 **Creating Skills** → `./resources/SKILLS_GUIDE.md`
  - Skill definition and structure
  - YAML frontmatter requirements
  - Writing effective descriptions
  - Progressive resource loading
  - Skill activation patterns

- 🤖 **Creating Agents** → `./resources/AGENTS_GUIDE.md`
  - Agent vs skill differences
  - Agent capabilities
  - Specialized agent patterns
  - Model selection (haiku/sonnet/opus)

- ⌨️ **Slash Commands** → `./resources/COMMANDS_GUIDE.md`
  - Command structure
  - Markdown-based commands
  - Command invocation
  - Passing arguments

- 🪝 **Using Hooks** → `./resources/HOOKS_GUIDE.md`
  - Available hook types
  - Hook configuration (hooks.json)
  - PreToolUse, PostToolUse, PreCompact, SessionStart
  - Writing hook handlers
  - Bash vs Python hooks

- ✨ **Best Practices** → `./resources/BEST_PRACTICES.md`
  - Official specification compliance
  - Naming conventions
  - Documentation standards
  - Testing plugins
  - Distribution patterns

- 📋 **Templates Guide** → `./resources/TEMPLATES.md`
  - Using included templates
  - Customization strategies
  - Template selection guide

## Interactive Mode

### Creating a Plugin

When you say: **"Create a plugin for [purpose]"**

I will guide you through:

1. **Discovery Questions**:
   - What does your plugin do?
   - Should it activate automatically (skill) or on-demand (command)?
   - Does it need hooks for event handling?
   - Does it need specialized agents?

2. **Structure Recommendation**:
   - Based on your answers, I'll suggest the right template
   - Explain why that structure fits your needs

3. **Code Generation**:
   - Copy appropriate template
   - Customize with your specifications
   - Generate boilerplate code
   - Add proper documentation

4. **Quality Checks**:
   - Ensure plugin.json is valid
   - Verify YAML frontmatter in skills
   - Check official specification compliance
   - Add usage examples

### Example Workflows

**Example 1: Simple Skill**

```
You: "Create a plugin with a skill for generating React component boilerplate"

Me: I'll create a skill-based plugin since this should activate when you ask
    about React components.

    Template: plugin-with-skill
    Skill name: react-component-generator
    Description: "Generate React component boilerplate..."

    [Generates complete plugin structure]
```

**Example 2: Command-Based Plugin**

```
You: "Create a plugin that validates commit messages"

Me: This should be a command since you want to trigger it explicitly.
    I'll also add a PreToolUse hook to validate before commits.

    Template: plugin-with-hooks
    Command: /validate-commit
    Hook: PreToolUse on git commit

    [Generates complete plugin structure]
```

**Example 3: Complex Plugin**

```
You: "Create a plugin for accessibility testing with agents and commands"

Me: This needs multiple components:
    - Skill: Auto-activates on accessibility questions
    - Agent: Deep accessibility analysis
    - Command: /a11y-check for explicit testing
    - Hook: PostToolUse to check edited components

    Template: plugin-complete

    [Generates comprehensive plugin]
```

## Template Overview

Located in `./templates/`, these are production-ready starting points:

### 1. plugin-basic
**When to use**: Minimal plugin, learning purposes

**Contains**:
- `.claude-plugin/plugin.json`
- `README.md`

**Good for**: Understanding structure, placeholders

### 2. plugin-with-skill
**When to use**: Model-invoked capability

**Contains**:
- Plugin metadata
- `skills/example-skill/SKILL.md`
- Documentation

**Good for**: Context-based activation, knowledge bases

### 3. plugin-with-hooks
**When to use**: Event-driven functionality

**Contains**:
- Plugin metadata
- `hooks/hooks.json`
- Hook handler scripts
- Documentation

**Good for**: Validation, automation, event handling

### 4. plugin-complete
**When to use**: Full-featured plugin

**Contains**:
- All of the above
- Skills, agents, commands, hooks
- Comprehensive example

**Good for**: Complex plugins, reference implementation

## Getting Started

### Step 1: Choose Your Approach

**Learning Mode**: Read the resources to understand concepts
```
"Explain how skills work"
"What's the difference between skills and commands?"
"Show me hook examples"
```

**Building Mode**: Ask me to create a plugin
```
"Create a plugin that [does X]"
"Generate a skill for [purpose]"
"I need a plugin with hooks for [event]"
```

**Template Mode**: Browse templates directly
```
"Show me the plugin-with-skill template"
"What templates are available?"
"Customize plugin-complete for my use case"
```

### Step 2: Customize

All templates use placeholders:
- `example-skill` → Your skill name
- `Example description` → Your description
- `TODO` markers for customization points

### Step 3: Install and Test

```bash
# Copy to plugins directory
cp -r your-plugin ~/.claude/plugins/

# Test activation (for skills)
# Just ask Claude about the topic

# Test command (for commands)
/your-command
```

## Official Specifications

I follow and teach the official Claude Code plugin specifications:

### Plugin Structure

```
your-plugin/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin metadata
├── skills/                   # Optional: Skills
│   └── skill-name/
│       └── SKILL.md
├── agents/                   # Optional: Agents
│   └── agent-name.md
├── commands/                 # Optional: Commands
│   └── command-name.md
├── hooks/                    # Optional: Hooks
│   ├── hooks.json
│   └── handler.sh
└── README.md                # Recommended: Documentation
```

### plugin.json Format

```json
{
  "name": "your-plugin-name",
  "description": "Clear, concise description",
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

### SKILL.md Format

```yaml
---
name: skill-name
description: Clear description of what this skill does and when to use it. Include keywords and use cases.
---

# Skill Title

## Overview
[Explanation of the skill]

## Usage
[How to use the skill]

## Examples
[Code examples and patterns]
```

## Common Patterns

### Pattern 1: Layered Skill

For large skills, use progressive resource loading:

```
skills/my-skill/
├── SKILL.md              # Main entry (~400 lines)
└── resources/
    ├── TOPIC_1.md
    ├── TOPIC_2.md
    └── TOPIC_3.md
```

Main SKILL.md references resources: "See `./resources/TOPIC_1.md`"

**Benefit**: Prevents context overflow, loads on-demand

### Pattern 2: Validation Hook

PreToolUse hook for validation:

```json
{
  "hooks": {
    "PreToolUse": [{
      "hooks": [{
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/validate.sh"
      }],
      "matcher": "Edit|Write"
    }]
  }
}
```

**Benefit**: Catch issues before code is written

### Pattern 3: Context Preservation

PreCompact hook to save important information:

```json
{
  "hooks": {
    "PreCompact": [{
      "type": "command",
      "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/save-context.sh"
    }]
  }
}
```

**Benefit**: Preserve design decisions across long sessions

## Troubleshooting

### Skill Not Activating

**Check:**
1. ✅ `plugin.json` is valid JSON
2. ✅ SKILL.md has valid YAML frontmatter
3. ✅ Description includes relevant keywords
4. ✅ Plugin is in correct directory

**Test**: Ask Claude explicitly about your skill's topic

### Command Not Found

**Check:**
1. ✅ Command file is in `commands/` directory
2. ✅ File name matches command (e.g., `my-cmd.md` → `/my-cmd`)
3. ✅ File has proper markdown content

**Test**: Type `/` to see available commands

### Hook Not Executing

**Check:**
1. ✅ `hooks.json` is valid JSON
2. ✅ Hook handler script exists
3. ✅ Script is executable (`chmod +x`)
4. ✅ Script path uses `${CLAUDE_PLUGIN_ROOT}`

**Debug**: Check logs or add debug output to script

## Best Practices Checklist

When creating plugins:

- ✅ Use clear, descriptive names (kebab-case)
- ✅ Write comprehensive descriptions
- ✅ Include usage examples in README
- ✅ Follow official plugin structure
- ✅ Use `${CLAUDE_PLUGIN_ROOT}` for paths
- ✅ Add keywords for discoverability
- ✅ Document all components
- ✅ Test before distributing
- ✅ Version your plugins (semantic versioning)
- ✅ Include LICENSE file

## Next Steps

Ready to create your first plugin? Ask me:

- "Create a plugin for [your use case]"
- "Show me the plugin-with-skill template"
- "Explain how to add hooks to a plugin"
- "What's the best structure for [specific need]"

I'll guide you through the process step-by-step!

---

**Remember**: The best way to learn is by doing. Start with a simple plugin, test it, iterate. Plugin development is easier than you think!
