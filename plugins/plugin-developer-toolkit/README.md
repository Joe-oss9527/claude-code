# Plugin Developer Toolkit

**Meta-plugin for creating, developing, and understanding Claude Code plugins.**

This plugin teaches plugin development through self-demonstration. It IS its own best example - examine its structure to learn effective patterns!

## What This Plugin Does

### 1. Interactive Plugin Creation

Ask me to create a plugin, and I'll:
- Ask clarifying questions about your needs
- Recommend appropriate structure (skill/agent/command/hook)
- Generate complete boilerplate from templates
- Add proper documentation
- Ensure specification compliance

**Example**:
```
You: "Create a plugin for generating React component boilerplate"

Me: I'll create a skill-based plugin since this should activate automatically
    when you discuss React components...
    [Generates complete plugin structure]
```

### 2. Comprehensive Documentation

Detailed guides on every aspect of plugin development:
- **BASICS.md**: Plugin structure, plugin.json, installation
- **SKILLS_GUIDE.md**: Creating auto-activating skills
- **HOOKS_GUIDE.md**: Event handlers (PreToolUse, SessionStart, etc.)
- **BEST_PRACTICES.md**: Quality standards, testing, distribution

### 3. Ready-to-Use Templates

Four battle-tested templates to start from:
- **plugin-basic**: Minimal structure
- **plugin-with-skill**: Model-invoked capability
- **plugin-with-hooks**: Event-driven functionality
- **plugin-complete**: Full-featured reference

## Installation

```bash
cp -r plugins/plugin-developer-toolkit ~/.claude/plugins/
```

## Usage

### Learning Mode

Ask questions to understand concepts:

```
You: "How do skills work?"
Me: [Loads SKILLS_GUIDE.md and explains]

You: "What's the difference between skills and commands?"
Me: [Explains with examples]

You: "Show me how to use hooks"
Me: [Loads HOOKS_GUIDE.md]
```

### Building Mode

Ask me to create plugins:

```
You: "Create a plugin that validates commit messages"
Me: [Interactive creation process]

You: "Generate a skill for API documentation"
Me: [Creates skill-based plugin]

You: "I need a plugin with hooks for linting"
Me: [Creates plugin with PreToolUse hooks]
```

### Template Mode

Browse and customize templates:

```
You: "Show me the plugin-with-skill template"
Me: [Shows template structure and files]

You: "Customize plugin-complete for accessibility testing"
Me: [Adapts template to your use case]
```

## Plugin Components Explained

### Skills (Auto-Activated)

- Invoked by Claude based on context
- Best for: Capabilities that should be available contextually
- Example: "Documentation generator" activates when user asks about docs

### Agents (Specialized Sub-Agents)

- Specialized tools with defined capabilities
- Best for: Complex analysis, multi-step tasks
- Example: "Code reviewer" analyzes code for issues

### Commands (User-Invoked)

- Explicitly triggered with `/command-name`
- Best for: Specific workflows and operations
- Example: `/commit` creates a git commit

### Hooks (Event-Driven)

- Execute in response to lifecycle events
- Best for: Validation, automation, context preservation
- Example: PreToolUse validates before writing code

## Templates

### 1. plugin-basic

**When to use**: Learning, minimal plugin

**Contains**:
- plugin.json
- README.md

**Good for**: Understanding structure, placeholders

### 2. plugin-with-skill

**When to use**: Context-based auto-activation

**Contains**:
- Plugin metadata
- Example skill with SKILL.md
- Documentation

**Good for**: Knowledge bases, contextual helpers

**Usage**:
```bash
cp -r templates/plugin-with-skill my-skill-plugin
cd my-skill-plugin
# Edit skills/example-skill/SKILL.md
# Update description with your keywords
```

### 3. plugin-with-hooks

**When to use**: Validation, automation

**Contains**:
- Plugin metadata
- hooks.json configuration
- Example hook handlers
- Documentation

**Good for**: Linting, security checks, formatting

**Usage**:
```bash
cp -r templates/plugin-with-hooks my-hooks-plugin
cd my-hooks-plugin
chmod +x hooks/*.sh
# Edit hook scripts with your logic
```

### 4. plugin-complete

**When to use**: Full-featured plugin, reference

**Contains**:
- All components (skill, agent, command, hooks)
- Complete example
- Comprehensive documentation

**Good for**: Complex plugins, learning by example

**Usage**:
```bash
cp -r templates/plugin-complete my-complete-plugin
cd my-complete-plugin
chmod +x hooks/*.sh
# Replace TODO markers with your implementation
```

## Self-Demonstrating Design

**This plugin practices what it teaches!**

Look at this plugin's structure to see best practices:

```
plugin-developer-toolkit/
├── .claude-plugin/
│   └── plugin.json           # ← Standard metadata
├── skills/
│   └── plugin-developer/
│       ├── SKILL.md          # ← Main entry (~400 lines)
│       └── resources/        # ← Progressive loading
│           ├── BASICS.md
│           ├── SKILLS_GUIDE.md
│           ├── HOOKS_GUIDE.md
│           └── BEST_PRACTICES.md
├── templates/                # ← Ready-to-use starting points
│   ├── plugin-basic/
│   ├── plugin-with-skill/
│   ├── plugin-with-hooks/
│   └── plugin-complete/
└── README.md                 # ← This file
```

**Key patterns demonstrated**:
- ✅ Layered skill architecture (prevents context overflow)
- ✅ Progressive resource loading
- ✅ Clear documentation
- ✅ Official specification compliance
- ✅ Ready-to-use templates

## Example Workflows

### Create a Simple Skill

```
You: "Create a plugin with a skill for git commit messages"

Me: I'll create a skill-based plugin. This should activate when you
    work on git commits.

    Plugin name: git-commit-helper
    Skill: commit-message-generator
    Template: plugin-with-skill

    [Generates:
     - plugin.json with metadata
     - skills/commit-message-generator/SKILL.md
     - README.md with usage examples]

You: "Perfect! How do I install it?"

Me: Copy to your plugins directory:
    cp -r git-commit-helper ~/.claude/plugins/

    Test by asking: "Help me write a commit message"
```

### Create a Validation Hook

```
You: "Create a plugin that checks for console.log before committing"

Me: This needs a PreToolUse hook to validate before writes.

    Plugin name: console-log-checker
    Hook: PreToolUse on Edit|Write
    Template: plugin-with-hooks

    [Generates:
     - hooks/hooks.json
     - hooks/pre-tool-use.sh with validation logic
     - README.md]

    The hook will:
    1. Detect console.log in code
    2. Show warning
    3. Block operation if desired

You: "Make it a warning, not blocking"

Me: [Updates hook to exit 0 (allow) instead of exit 2 (block)]
```

### Create a Complex Plugin

```
You: "Create an accessibility testing plugin with agents and commands"

Me: This needs multiple components:
    - Skill: Auto-activates on a11y questions
    - Agent: Deep accessibility analysis
    - Command: /a11y-check for explicit testing
    - Hook: PostToolUse to check edited components

    Template: plugin-complete

    [Generates comprehensive plugin with all components]
```

## Quick Start Guide

### 1. Install This Plugin

```bash
cp -r plugins/plugin-developer-toolkit ~/.claude/plugins/
```

### 2. Ask Questions

```
"How do I create a skill?"
"Show me hook examples"
"What's the plugin structure?"
```

### 3. Create Your First Plugin

```
"Create a plugin for [your use case]"
```

### 4. Customize Template

- Replace TODO markers
- Update descriptions
- Add your logic
- Test locally

### 5. Install and Test

```bash
cp -r your-plugin ~/.claude/plugins/
# Test activation/execution
```

## Development Best Practices

(From BEST_PRACTICES.md resource)

### Plugin Design
- Do one thing well
- Follow official specifications
- Use progressive disclosure for large skills
- Clear, descriptive naming

### Documentation
- Comprehensive README
- Usage examples
- Troubleshooting section
- Installation instructions

### Testing
- Test skill activation
- Verify command execution
- Check hook behavior
- Validate JSON files

### Distribution
- Include LICENSE
- Version with semantic versioning
- Clean repository
- Clear contribution guidelines

## Troubleshooting

### Skill Not Activating

**Check**:
1. plugin.json is valid JSON
2. SKILL.md has valid YAML frontmatter
3. Description includes relevant keywords
4. Plugin is in correct directory

**Test**: Ask Claude explicitly about your skill's topic

### Command Not Found

**Check**:
1. Command file in `commands/` directory
2. File name matches command
3. File has markdown content

**Test**: Type `/` to see available commands

### Hook Not Executing

**Check**:
1. hooks.json is valid JSON
2. Hook script exists and is executable
3. Script path uses `${CLAUDE_PLUGIN_ROOT}`
4. Exit codes are correct (0 or 2)

**Debug**: Add logging to hook script

## Resources

### Official Documentation
- [Claude Code Plugins](https://docs.claude.com/en/docs/claude-code/plugins)
- [Skills Overview](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Hooks Reference](https://docs.claude.com/en/docs/claude-code/hooks)

### This Plugin's Resources
- `./skills/plugin-developer/resources/BASICS.md`
- `./skills/plugin-developer/resources/SKILLS_GUIDE.md`
- `./skills/plugin-developer/resources/HOOKS_GUIDE.md`
- `./skills/plugin-developer/resources/BEST_PRACTICES.md`

### Templates
- `./templates/plugin-basic/`
- `./templates/plugin-with-skill/`
- `./templates/plugin-with-hooks/`
- `./templates/plugin-complete/`

## Contributing

This toolkit welcomes contributions:
- Additional templates
- More examples
- Improved documentation
- Bug fixes

## Version History

### 1.0.0 (Current)
- ✅ Interactive plugin creation
- ✅ Comprehensive documentation (4 guides)
- ✅ 4 ready-to-use templates
- ✅ Self-demonstrating architecture
- ✅ Best practices guidance

## License

MIT License - See LICENSE file for details

## Feedback

Questions or suggestions? Open an issue in the main repository.

---

**Ready to create your first plugin?** Ask me: "Create a plugin for [your use case]"

I'll guide you through the entire process step-by-step!
