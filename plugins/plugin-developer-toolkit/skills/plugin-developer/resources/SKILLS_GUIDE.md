# Skills Guide

Complete guide to creating model-invoked skills in Claude Code plugins.

## What are Skills?

**Skills are automatically activated capabilities** that Claude uses based on context. Unlike commands (which require explicit user invocation), skills activate when Claude determines they're relevant.

**Key characteristics**:
- ✅ Automatically discovered by Claude
- ✅ Activated based on description matching
- ✅ Loaded progressively (metadata first, content on-demand)
- ✅ Best for contextual capabilities

## Skill Structure

```
plugin-name/
└── skills/
    └── skill-name/
        ├── SKILL.md           # Required: Skill definition
        └── resources/         # Optional: Sub-resources
            ├── TOPIC_1.md
            └── TOPIC_2.md
```

## SKILL.md Format

Every skill requires a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: skill-name
description: Clear description of what this skill does and when to use it. Include keywords and example use cases.
---

# Skill Title

## Overview
Explain what the skill does and why it's useful.

## When to Use
List specific scenarios when this skill should activate.

## Usage
Provide examples and patterns.

## Best Practices
Guidelines for using this skill effectively.
```

### Critical: The Description

The `description` field is the **most important** part:

```yaml
# ❌ Bad: Vague, no keywords
description: Helps with documentation

# ✅ Good: Specific, keyword-rich
description: Generate comprehensive API documentation from code. Use when user asks to create API docs, document endpoints, generate OpenAPI specs, or create API reference documentation.
```

**Include in description**:
- What the skill does
- When it should activate
- Specific keywords and phrases
- Example use cases

## Activation Patterns

Claude activates skills through **description matching**:

### Example 1: Direct Match

```yaml
---
name: changelog-generator
description: Generate and maintain CHANGELOG.md files. Use when user asks to create changelog, update release notes, or document version changes.
---
```

**Activates when user says**:
- "Generate a changelog"
- "Update CHANGELOG.md"
- "Create release notes"
- "Document version changes"

### Example 2: Topic-Based Match

```yaml
---
name: react-performance
description: Optimize React component performance including memoization, code splitting, and bundle optimization. Use when discussing React performance, slow rendering, or bundle size.
---
```

**Activates when user discusses**:
- "This component renders too slowly"
- "How do I optimize React performance?"
- "My bundle is too large"

### Example 3: Broad Coverage

```yaml
---
name: frontend-dev
description: Comprehensive React/TypeScript frontend development guidelines covering components, state management, performance, accessibility, and testing. Use when building React components, designing frontend architecture, or implementing modern frontend patterns.
---
```

**Activates on any frontend discussion**:
- Component design questions
- TypeScript questions
- Performance issues
- Testing questions

## Progressive Resource Loading

For large skills, use layered architecture:

### Main SKILL.md (Entry Point)

Keep main file lightweight (~400 lines):

```markdown
---
name: big-skill
description: Comprehensive guide covering multiple topics...
---

# Big Skill

## Quick Reference

- **Topic 1** → `./resources/TOPIC_1.md`
- **Topic 2** → `./resources/TOPIC_2.md`
- **Topic 3** → `./resources/TOPIC_3.md`

## Overview
Brief overview of the skill...

## How to Use
When you ask about Topic 1, I'll load the detailed resource file.
```

### Resource Files (Loaded On-Demand)

```markdown
# resources/TOPIC_1.md

Detailed content for Topic 1 (200-400 lines)
- Code examples
- Best practices
- Deep explanations
```

**Benefits**:
- ✅ Main file stays lightweight
- ✅ Only relevant content loaded
- ✅ Prevents context overflow
- ✅ Scales to comprehensive coverage

## Skill Examples

### Example 1: Simple Skill

```markdown
---
name: git-commit-helper
description: Generate well-formatted git commit messages following conventional commits. Use when user needs to create commits or write commit messages.
---

# Git Commit Helper

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

- feat: New feature
- fix: Bug fix
- docs: Documentation
- refactor: Code refactoring
- test: Tests
- chore: Maintenance

## Examples

### Feature Commit
```
feat(auth): Add OAuth login support

Implement OAuth 2.0 authentication flow with Google and GitHub providers.
Includes token refresh and session management.

Closes #123
```

### Bug Fix
```
fix(api): Handle null responses in user endpoint

Add null checks to prevent crashes when user data is missing.
Includes test coverage for edge cases.

Fixes #456
```
```

### Example 2: Layered Skill

```markdown
---
name: comprehensive-guide
description: Complete guide to topic with multiple sub-topics. Loads relevant resources based on user questions.
---

# Comprehensive Guide

## Resource Structure

This skill covers:

1. **Basics** → `./resources/BASICS.md`
2. **Advanced** → `./resources/ADVANCED.md`
3. **Troubleshooting** → `./resources/TROUBLESHOOTING.md`

## How It Works

When you ask about basics, I load BASICS.md.
When you have advanced questions, I load ADVANCED.md.

## Quick Tips

- Start with basics if you're new
- Jump to advanced for complex scenarios
- Check troubleshooting for common issues
```

## Skill Best Practices

### 1. Write Clear Descriptions

```yaml
# ❌ Too vague
description: Helps with code

# ✅ Specific and keyword-rich
description: Review JavaScript code for bugs, security issues, and best practices. Use when analyzing code, debugging issues, or ensuring code quality.
```

### 2. Include Usage Examples

```markdown
## Example Usage

**User**: "Check this function for bugs"

**Claude** (activates skill):
- Analyzes function logic
- Identifies potential bugs
- Suggests fixes with code examples
```

### 3. Organize Content Clearly

```markdown
## Table of Contents

1. [Overview](#overview)
2. [When to Use](#when-to-use)
3. [Examples](#examples)
4. [Best Practices](#best-practices)
```

### 4. Use Code Examples Liberally

```markdown
## Pattern: Safe Error Handling

### ❌ Bad
```javascript
const data = JSON.parse(userInput);
```

### ✅ Good
```javascript
try {
  const data = JSON.parse(userInput);
} catch (error) {
  console.error('Invalid JSON:', error);
  return null;
}
```
```

### 5. Keep Skills Focused

One skill, one purpose:

- ✅ `react-hooks` - Focused on React hooks
- ✅ `typescript-types` - Focused on TypeScript
- ❌ `everything-frontend` - Too broad, split it up

## Testing Skills

### Test Activation

```
You: "Use skill-name"
# Should activate explicitly

You: [Ask question matching description]
# Should activate automatically
```

### Verify Content Loading

Check that:
- Main SKILL.md loads
- Resources load when referenced
- Content is relevant to question

### Check Description Quality

Ask questions that should trigger the skill:
- Does it activate?
- Is it the right skill?
- Is content helpful?

## Common Mistakes

### 1. Description Too Generic

```yaml
# ❌ Bad
description: Coding helper

# ✅ Good
description: Generate Python code following PEP 8 style guide. Use when writing Python functions, classes, or modules.
```

### 2. Missing Keywords

```yaml
# ❌ Missing key phrases
description: React helper

# ✅ Includes trigger phrases
description: React development helper. Use when building React components, writing hooks, managing state, or debugging React applications.
```

### 3. YAML Syntax Errors

```yaml
# ❌ Wrong: Missing quotes on multi-line
description: This is a
  multi-line description

# ✅ Correct: Use pipe or quotes
description: |
  This is a multi-line
  description properly formatted
```

### 4. Monolithic Skills

```markdown
# ❌ Bad: One huge file (5000 lines)
All content in SKILL.md

# ✅ Good: Layered structure
Main SKILL.md (400 lines)
Resources loaded on-demand
```

## Advanced Patterns

### Tool Restrictions

Limit which tools a skill can use:

```yaml
---
name: read-only-analyzer
description: Analyze code without modifications
allowed-tools:
  - Read
  - Grep
  - Glob
---
```

This prevents accidental file modifications.

### Skill Composition

Reference other skills:

```markdown
## Related Skills

This skill works well with:
- `code-reviewer` for quality checks
- `test-generator` for test coverage
- `doc-generator` for documentation
```

## Skill Checklist

Before publishing a skill:

- ✅ Valid YAML frontmatter
- ✅ Clear, keyword-rich description
- ✅ Organized content structure
- ✅ Code examples (✅/❌ format)
- ✅ Usage examples
- ✅ Best practices section
- ✅ Tested activation
- ✅ Documented in README

## Resources

- [Official Skills Documentation](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Skills Cookbooks](https://github.com/anthropics/claude-cookbooks/tree/main/skills)
