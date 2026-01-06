# UDO - Universal Dynamic Orchestrator v4

Project-level AI orchestration system that works with any LLM chat interface.

## Quick Install

Run this in any project folder:

```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash
```

## What Gets Installed

```
your-project/
├── ORCHESTRATOR.md        # System prompt for AI orchestration
├── PROJECT_STATE.json     # Tracks goals, todos, progress
├── .agents/               # Spawned specialist agents
│   └── _archive/          # Retired single-use agents
└── .templates/
    └── agent.md           # Blueprint for new agents
```

## Usage

### VS Code Claude Extension
```
Read ORCHESTRATOR.md and help me build [your goal]
```

### Cursor
Rename `ORCHESTRATOR.md` to `.cursorrules` - it auto-loads.

### GitHub Copilot Chat
```
@workspace Follow ORCHESTRATOR.md to build [your goal]
```

### Any LLM Chat
Paste the contents of `ORCHESTRATOR.md` as your first message.

## How It Works

1. **Decompose** - Break your goal into atomic todos
2. **Classify** - Identify what specialist is needed for each
3. **Delegate** - Create agent definitions in `.agents/` as needed
4. **Validate** - Verify each output meets success criteria
5. **Integrate** - Update state and continue

The `PROJECT_STATE.json` file persists between sessions, so you can pick up where you left off.

## License

MIT
