# 🚀 New AI? Start Here.

Welcome to this project. Follow these steps to get oriented:

## Quick Start (60 seconds)

1. **Read your instructions:** `ORCHESTRATOR.md`
2. **Check hard stops FIRST:** `HARD_STOPS.md` (absolute rules)
3. **Check current status:** `PROJECT_STATE.json`
4. **Know your environment:** `CAPABILITIES.json`
5. **Review project context:** `PROJECT_META.json`
6. **Check for mistakes to avoid:** `LESSONS_LEARNED.md`
7. **Know what's out of scope:** `NON_GOALS.md`
8. **See latest session:** `.project-catalog/sessions/` (most recent file)

## Then Say:

> "I've reviewed the project. Current status: [summarize]. My environment supports: [capabilities]. Ready to continue with [next steps]."

## Resume Commands

| Command | When to Use |
|---------|-------------|
| `Resume` | Start of each session (quick) |
| `Deep resume` | After long break, need full context |
| `Re-sync` | After system files were updated |
| `What's the status?` | Just want oversight report |

If the user just says `Resume` or `Resume this project` - follow the Quick Resume Protocol in ORCHESTRATOR.md.

## Ending Sessions

**CRITICAL**: Before ending any session, use the handoff prompt in `HANDOFF_PROMPT.md`

Quick version:
```
End session. Create handoff at .project-catalog/sessions/
```

This creates the context file the next AI needs to continue your work.

## Key Folders

| Folder | Purpose |
|--------|---------|
| `.agents/` | Specialist AI definitions (Layer 2 rules) |
| `.rules/` | Quality standards (Layer 1 rules) |
| `.inputs/` | User-provided files and assets |
| `.outputs/` | Deliverables you create |
| `.project-catalog/` | Full history (sessions, handoffs, decisions) |
| `.checkpoints/` | Saved snapshots to roll back to |
| `.memory/` | Organized memory (working, canonical, disposable) |

## Rule Hierarchy

| Layer | Location | Override? |
|-------|----------|-----------|
| 0 | `HARD_STOPS.md` | NEVER by AI |
| 1 | `.rules/*.md` | With justification |
| 2 | `.agents/*.md` | By orchestrator |
| 3 | `LESSONS_LEARNED.md` | Easily |

## Golden Rules

1. **HARD_STOPS.md is absolute** - Never violate, never override
2. You are a **coordinator** - delegate to specialist agents
3. **Check CAPABILITIES.json** before assigning tasks
4. **Document everything** in `.project-catalog/`
5. **Never guess** - ask if unclear
6. **Check LESSONS_LEARNED.md** before starting work
7. **Archive completed phases** to manage context size
8. **Update agent templates** when lessons apply to them
