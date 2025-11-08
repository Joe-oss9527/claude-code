# Best Practices for Plugin Development

Essential guidelines for creating high-quality Claude Code plugins.

## Plugin Design Principles

### 1. Do One Thing Well

```
✅ Good: frontend-dev-guidelines
   - Focused on frontend development
   - Clear scope and purpose

❌ Bad: everything-dev-tool
   - Too broad
   - Unclear purpose
   - Maintenance nightmare
```

### 2. Follow Official Specifications

- Use standard directory structure
- Include required `plugin.json`
- Follow YAML frontmatter format
- Use official environment variables

### 3. Progressive Disclosure

For skills with lots of content:

```
Main SKILL.md: ~400 lines (overview)
Resources: 200-400 lines each (details)
Total: Comprehensive coverage without context overflow
```

## Naming Conventions

### Plugin Names

```
✅ frontend-dev-guidelines
✅ security-guidance
✅ code-review

❌ FrontendDevGuidelines (PascalCase)
❌ frontend_dev_guidelines (snake_case)
❌ FE-Dev (abbreviations)
```

### Skill Names

```
✅ react-component-generator
✅ api-docs-generator

❌ ReactComponentGenerator
❌ rcg (too short)
```

### File Names

```
✅ SKILL.md (skills)
✅ code-reviewer.md (agents)
✅ commit-push-pr.md (commands)
✅ hooks.json (hooks)

❌ skill.md (wrong case)
❌ Code_Reviewer.md (wrong case/separator)
```

## Documentation Standards

### README.md Structure

```markdown
# Plugin Name

Brief description (1-2 sentences)

## Overview

What this plugin does and why it's useful

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

```bash
cp -r plugin-name ~/.claude/plugins/
```

## Usage

### Example 1
[Clear example with explanation]

### Example 2
[Another example]

## Configuration

[If applicable]

## Troubleshooting

Common issues and solutions

## License

[License information]
```

### Skill Documentation

Every SKILL.md should include:

```markdown
---
name: skill-name
description: Clear, keyword-rich description
---

# Skill Title

## Overview
What this skill does

## When to Use
Specific scenarios

## Examples
Code examples with ✅/❌ format

## Best Practices
Guidelines and tips
```

## Code Quality

### Use Clear Examples

```markdown
## Pattern: Error Handling

### ❌ Bad
```typescript
const data = JSON.parse(input);
```

### ✅ Good
```typescript
try {
  const data = JSON.parse(input);
} catch (error) {
  console.error('Invalid JSON:', error);
  return null;
}
```
```

### Include Context

```markdown
## Why This Matters

This pattern prevents crashes when:
1. Input is malformed
2. Data source is unreliable
3. Edge cases occur

Real-world impact: Prevents 90% of parsing errors
```

### Provide Alternatives

```markdown
## Solution Options

1. **Option A**: Simple, works for most cases
2. **Option B**: Complex, handles edge cases
3. **Option C**: Performance-optimized

Choose based on your needs...
```

## Version Control

### Semantic Versioning

```
MAJOR.MINOR.PATCH

1.0.0 - Initial release
1.1.0 - New feature (backward compatible)
1.1.1 - Bug fix
2.0.0 - Breaking change
```

### Git Practices

```bash
# Clear commit messages
git commit -m "feat: Add React hooks guide"
git commit -m "fix: Correct TypeScript example"
git commit -m "docs: Update README with new examples"

# Tag releases
git tag v1.0.0
git push --tags
```

### Changelog

```markdown
# Changelog

## [1.1.0] - 2024-01-15

### Added
- New resource for advanced patterns
- 5 additional examples

### Fixed
- Typo in SKILL.md
- Broken link in README

## [1.0.0] - 2024-01-01

### Added
- Initial release
- Basic skill structure
- Documentation
```

## Testing Plugins

### Test Checklist

```
Plugin Structure:
- ✅ Valid plugin.json
- ✅ Proper directory structure
- ✅ All referenced files exist

Skills:
- ✅ Valid YAML frontmatter
- ✅ Description triggers activation
- ✅ Content is helpful and accurate
- ✅ Examples work as shown

Commands:
- ✅ Command executes
- ✅ Arguments work correctly
- ✅ Error handling works

Hooks:
- ✅ Hooks execute at right time
- ✅ Exit codes correct
- ✅ Error messages clear
- ✅ Performance acceptable

Documentation:
- ✅ README is clear
- ✅ Installation instructions work
- ✅ Examples are accurate
- ✅ Links work
```

### Manual Testing

```bash
# 1. Install plugin
cp -r my-plugin ~/.claude/plugins/

# 2. Start Claude Code
claude

# 3. Test skill activation
You: [Ask question that should trigger skill]

# 4. Test command
You: /my-command

# 5. Test hooks (if applicable)
You: [Perform action that triggers hook]
```

### Automated Testing

```bash
# Validate JSON files
find . -name "*.json" -exec jq empty {} \;

# Check YAML frontmatter
grep -r "^---$" skills/

# Verify file permissions
find hooks/ -name "*.sh" -exec test -x {} \;
```

## Performance Considerations

### Keep Hooks Fast

```bash
# ❌ Bad: Slow operation
npm install  # Takes minutes

# ✅ Good: Quick check
grep "pattern" "$file"  # Milliseconds
```

### Optimize Skill Loading

```markdown
# ❌ Bad: One huge file
SKILL.md: 5000 lines (loads all at once)

# ✅ Good: Progressive loading
SKILL.md: 400 lines (entry point)
Resources: Loaded on-demand
```

### Cache When Possible

```python
# Cache expensive operations
@lru_cache(maxsize=128)
def expensive_computation(input):
    return result
```

## Security Considerations

### Validate Inputs

```python
# Hook handler
input_data = json.loads(sys.stdin.read())

# Validate structure
if not isinstance(input_data, dict):
    sys.exit(0)

if "tool_name" not in input_data:
    sys.exit(0)
```

### Safe Command Execution

```bash
# ❌ Bad: Command injection risk
eval "$user_input"

# ✅ Good: Safe execution
command_array=("$cmd" "$arg1" "$arg2")
"${command_array[@]}"
```

### Protect Sensitive Data

```python
# ❌ Bad: Log sensitive data
print(f"Token: {api_key}")

# ✅ Good: Redact sensitive data
print("Token: [REDACTED]")
```

## Distribution

### Package Correctly

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json
├── skills/
├── README.md
├── LICENSE
└── CHANGELOG.md

# Don't include:
❌ node_modules/
❌ .git/
❌ .env
❌ Personal data
```

### Licensing

```markdown
# README.md

## License

This plugin is licensed under the MIT License.
See LICENSE file for details.
```

### Installation Instructions

```markdown
## Installation

### Method 1: Direct Copy
```bash
git clone https://github.com/user/plugin-name
cp -r plugin-name ~/.claude/plugins/
```

### Method 2: Symlink (Development)
```bash
git clone https://github.com/user/plugin-name
ln -s $(pwd)/plugin-name ~/.claude/plugins/plugin-name
```

### Verify Installation
Ask Claude: "What plugins are available?"
```

## Maintenance

### Keep Dependencies Updated

```bash
# Check for updates
npm outdated

# Update safely
npm update --save
```

### Monitor Issues

- Watch GitHub issues
- Respond to bug reports
- Accept pull requests
- Update documentation

### Deprecation Strategy

```markdown
## Deprecation Notice

This plugin is deprecated. Please migrate to:
- new-plugin-name: Maintained alternative
- Migration guide: docs/MIGRATION.md
```

## Quality Checklist

Before publishing:

**Structure**:
- ✅ Valid plugin.json
- ✅ Standard directory structure
- ✅ All files in correct locations

**Documentation**:
- ✅ Comprehensive README
- ✅ Installation instructions
- ✅ Usage examples
- ✅ Troubleshooting section

**Code Quality**:
- ✅ Clear, commented code
- ✅ Consistent formatting
- ✅ No hardcoded paths
- ✅ Error handling

**Testing**:
- ✅ Manually tested
- ✅ Examples verified
- ✅ Hooks tested
- ✅ Cross-platform compatible (if applicable)

**Legal**:
- ✅ LICENSE file
- ✅ Copyright notices
- ✅ Attribution (if using others' work)

**Publishing**:
- ✅ Version tagged
- ✅ CHANGELOG updated
- ✅ Repository clean
- ✅ README accurate

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/overview)
- [Plugin Specifications](https://docs.claude.com/en/docs/claude-code/plugins)
- [Skills Documentation](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
