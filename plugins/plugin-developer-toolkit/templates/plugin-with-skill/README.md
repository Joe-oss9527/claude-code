# My Skill Plugin

Plugin demonstrating a model-invoked skill that activates automatically based on context.

## What This Plugin Provides

### Skill: example-skill

TODO: Describe what the skill does

**Activates when**: User discusses [topics]

## Installation

```bash
cp -r my-skill-plugin ~/.claude/plugins/
```

## Usage

The skill activates automatically when relevant. Simply ask Claude about [topic]:

```
You: "Help me with [topic]"
Claude: [Activates example-skill and provides guidance]
```

## Customization

1. Edit `skills/example-skill/SKILL.md`
2. Update the `description` field with your keywords
3. Replace TODO markers with your content
4. Test activation by asking relevant questions

## Structure

```
my-skill-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── example-skill/
│       └── SKILL.md
└── README.md
```

## License

MIT
