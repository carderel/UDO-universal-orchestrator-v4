# UDO - Universal Dynamic Orchestrator v5

Project-level AI orchestration system with **full documentation history** for seamless LLM switching.

## What Makes v5 Different

**Switch LLMs mid-project without losing context.** Every action, handoff, and decision is documented so Claude, GPT, Gemini, or any other LLM can pick up exactly where another left off.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v5/main/install.sh | bash
```

## What Gets Installed

```
your-project/
├── ORCHESTRATOR.md              # System instructions (read first)
├── PROJECT_STATE.json           # Current status and todos
├── .agents/                     # Specialist definitions
│   └── _archive/                # Retired one-time agents
├── .templates/                  # Blueprints
│   ├── agent.md
│   ├── handoff.md
│   └── session.md
└── .project-catalog/            # 📚 Full documentation history
    ├── agents/                  # What each agent did
    │   └── {agent-name}/
    │       ├── overview.md
    │       └── work-log.md
    ├── handoffs/                # Agent-to-agent communication
    │   └── {timestamp}-{from}-to-{to}.md
    ├── decisions/               # Key decisions with rationale
    │   └── {timestamp}-{topic}.md
    └── sessions/                # Session summaries
        └── {date}-session.md
```

## Usage

### Start a Project
```
Read ORCHESTRATOR.md and help me build [your goal]
```

### Switch LLMs Mid-Project
Just tell the new AI:
```
Read ORCHESTRATOR.md, PROJECT_STATE.json, and the latest session in .project-catalog/sessions/. Continue where the last AI left off.
```

The new AI will:
1. Read the orchestrator instructions
2. Check current project state
3. Review the session history
4. Pick up pending handoffs
5. Continue seamlessly

## The Documentation System

### Agent Work Logs
Every agent's actions are logged:
```markdown
## 2025-01-08T14:30:00Z
Task: Analyze Q4 financial data
Input: transactions.csv, categories.json
Output: financial_report.md
Status: complete
Next: Hand off to content-writer for executive summary
```

### Handoffs
When agents pass work to each other:
```markdown
# Handoff: data-analyst → content-writer
Reason: Raw analysis complete, needs human-readable summary

## Data Provided
- financial_report.md (detailed analysis)
- key_metrics.json (headline numbers)

## Expected Output
- executive_summary.md (1-page overview for stakeholders)
```

### Decisions
Key choices are documented with rationale:
```markdown
# Decision: Use Wave export format
Context: Multiple accounting formats available
Options: Wave CSV, QuickBooks, Xero
Decision: Wave - client already uses it
Impact: All parsing scripts assume Wave format
```

### Sessions
Each work session is summarized:
```markdown
# Session: 2025-01-08
LLM: Claude
Summary: Completed financial analysis pipeline

## Agents Active
- accountant: Categorized 4,626 transactions
- data-analyst: Generated quarterly breakdown

## Next Session Should
1. Create executive summary
2. Review uncategorized transactions
```

## Why This Matters

| Without Documentation | With .project-catalog |
|----------------------|----------------------|
| New LLM starts from scratch | New LLM reads history and continues |
| "What was I doing?" | Check latest session.md |
| Lost context on agent handoffs | Full handoff records |
| No audit trail | Complete decision history |
| Can't debug failures | Trace back through work logs |

## Compatible With

- ✅ Claude (Web, API, VS Code extension)
- ✅ ChatGPT / GPT-4
- ✅ Gemini
- ✅ Cursor
- ✅ GitHub Copilot
- ✅ Any LLM that can read markdown files

## License

MIT
