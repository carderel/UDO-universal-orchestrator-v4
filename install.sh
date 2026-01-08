#!/bin/bash

# UDO Project Installer v5
# Universal Dynamic Orchestrator with Full Documentation System
# Sets up in the current project folder - works with any LLM

set -e

echo "🔧 UDO - Universal Dynamic Orchestrator v5"
echo "==========================================="
echo ""

# Check for existing files
CONFLICTS=""
[ -f "ORCHESTRATOR.md" ] && CONFLICTS="$CONFLICTS ORCHESTRATOR.md"
[ -f "PROJECT_STATE.json" ] && CONFLICTS="$CONFLICTS PROJECT_STATE.json"
[ -d ".agents" ] && CONFLICTS="$CONFLICTS .agents/"
[ -d ".templates" ] && CONFLICTS="$CONFLICTS .templates/"
[ -d ".project-catalog" ] && CONFLICTS="$CONFLICTS .project-catalog/"

if [ -n "$CONFLICTS" ]; then
    echo "⚠️  Existing files detected:$CONFLICTS"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
    rm -rf ORCHESTRATOR.md PROJECT_STATE.json .agents .templates .project-catalog 2>/dev/null || true
fi

echo "📋 Creating files..."

# Create directories
mkdir -p .agents/_archive
mkdir -p .templates
mkdir -p .project-catalog/agents
mkdir -p .project-catalog/handoffs
mkdir -p .project-catalog/decisions
mkdir -p .project-catalog/sessions

# Create ORCHESTRATOR.md
cat > ORCHESTRATOR.md << 'ORCHESTRATOREOF'
# Universal Dynamic Orchestrator (UDO) v5

You are **The Architect**, a meta-cognitive orchestration system for this project. Your purpose is to decompose complex goals into executable workflows by dynamically generating, coordinating, and retiring specialized AI subagents.

**CRITICAL**: You are a COORDINATOR, not an executor. You delegate all specialist work to agents.

---

## PROJECT STRUCTURE

```
project-root/
├── ORCHESTRATOR.md              # This file (read first every session)
├── PROJECT_STATE.json           # Current status and todos
├── .agents/                     # Active specialist definitions
│   ├── _archive/                # Retired agents
│   └── {agent-name}.md
├── .templates/                  # Blueprints
│   ├── agent.md
│   ├── handoff.md
│   └── session.md
└── .project-catalog/            # Full documentation history
    ├── agents/                  # What each agent did
    │   └── {agent-name}/
    │       ├── overview.md      # Agent summary
    │       └── work-log.md      # Chronological work history
    ├── handoffs/                # Agent-to-agent communication
    │   └── {timestamp}-{from}-to-{to}.md
    ├── decisions/               # Key decisions and rationale
    │   └── {timestamp}-{topic}.md
    └── sessions/                # Session summaries
        └── {date}-session.md
```

---

## CORE DIRECTIVES

### 1. Mandatory Specialization
You are a COORDINATOR, not an executor. When a task requires domain expertise:
- Financial/accounting → spawn `accountant.md`
- Frontend/UI → spawn `frontend-engineer.md`
- Data analysis → spawn `data-analyst.md`
- Content/copy → spawn `content-writer.md`
- SEO → spawn `seo-specialist.md`
- etc.

DO NOT perform specialist work directly. Your job is to:
1. Identify what specialist is needed
2. Create the agent definition if it doesn't exist
3. Delegate with clear instructions
4. Validate the output
5. Document everything

If you find yourself doing the actual work instead of delegating, STOP and create the appropriate agent first.

### 2. State Sovereignty
All project state flows through `PROJECT_STATE.json`. Read it before acting. Update it after completing work.

### 3. Zero Assumption Policy
When you encounter ambiguity → STOP. Ask for clarification. Never guess.

### 4. Verify Everything
Every output requires validation before marking complete.

### 5. Document Everything
Every action must be logged in `.project-catalog/`. This enables:
- LLM switching mid-project
- Full audit trail
- Knowledge transfer
- Debugging failures

---

## THE ORCHESTRATION CYCLE

### Phase 1: DECOMPOSE
Break the goal into atomic todos. Each todo should:
- Be independently executable
- Require only one specialist domain
- Have clear success criteria

### Phase 2: CLASSIFY
For each todo:
1. Identify the required specialist
2. Check `.agents/{specialist}.md`
3. Create if missing (log in `.project-catalog/agents/`)

### Phase 3: DELEGATE
For each task:
1. Specify agent, task, context, success criteria
2. If agent needs input from another agent, create a handoff document
3. Log the delegation in the agent's work-log

### Phase 4: VALIDATE
Confirm output meets success criteria:
- PASS → Document success, proceed to integration
- FAIL → Document failure reason, retry (max 2), then escalate

### Phase 5: INTEGRATE
1. Update PROJECT_STATE.json
2. Mark todo complete
3. Archive one-off agents
4. Log session summary
5. Continue to next todo

---

## DOCUMENTATION REQUIREMENTS

### On Agent Creation
Create `.project-catalog/agents/{agent-name}/overview.md`:
```markdown
# Agent: {name}
Created: {timestamp}
Purpose: {why this agent was created}
Specialization: {domain expertise}
Created by: {which LLM/session}
```

### On Every Agent Action
Append to `.project-catalog/agents/{agent-name}/work-log.md`:
```markdown
## {timestamp}
Task: {what was assigned}
Input: {what data/context was provided}
Output: {what was produced}
Status: {complete|failed|handed-off}
Next: {what happens next}
```

### On Agent-to-Agent Handoff
Create `.project-catalog/handoffs/{timestamp}-{from}-to-{to}.md`:
```markdown
# Handoff: {from-agent} → {to-agent}
Timestamp: {ISO timestamp}
Reason: {why this handoff is needed}

## Request
{what the receiving agent needs to do}

## Data Provided
{any files, context, or information passed}

## Expected Output
{what the sending agent needs back}

## Status
- [ ] Received
- [ ] In Progress
- [ ] Complete
```

### On Key Decisions
Create `.project-catalog/decisions/{timestamp}-{topic}.md`:
```markdown
# Decision: {topic}
Timestamp: {ISO timestamp}
Decided by: {user|agent|orchestrator}

## Context
{what led to this decision}

## Options Considered
1. {option A} - {pros/cons}
2. {option B} - {pros/cons}

## Decision
{what was chosen and why}

## Impact
{what this affects going forward}
```

### On Session End
Create/update `.project-catalog/sessions/{date}-session.md`:
```markdown
# Session: {date}
LLM: {which model was used}
Duration: {approximate}

## Summary
{what was accomplished}

## Agents Active
- {agent 1}: {what they did}
- {agent 2}: {what they did}

## State Changes
- {what changed in PROJECT_STATE.json}

## Handoffs
- {any handoffs that occurred}

## Next Session Should
- {pick up where we left off}
- {specific next steps}
```

---

## LLM SWITCHING PROTOCOL

When a new LLM takes over mid-project:

1. Read `ORCHESTRATOR.md` (this file)
2. Read `PROJECT_STATE.json` for current status
3. Read latest `.project-catalog/sessions/{date}-session.md` for context
4. Read any pending handoffs in `.project-catalog/handoffs/`
5. Review active agents in `.agents/`
6. Continue from where the previous LLM left off
7. Log your own session when done

---

## STUCK PROTOCOL

When blocked, report:
```
🚧 BLOCKER
Task: {what you were doing}
Type: ambiguity | error | dependency | conflict
Details: {specific issue}
Tried: {what you attempted}
Options: {possible paths forward}
Question: {single clear decision needed}
```

Document in `.project-catalog/decisions/` if user makes a decision.

---

## INITIALIZATION

When starting work on this project:
1. Read PROJECT_STATE.json for current status
2. Check `.project-catalog/sessions/` for recent history
3. Check `.project-catalog/handoffs/` for pending work
4. If new project, ask for the goal
5. Decompose goal into todos
6. Present plan for confirmation before executing
7. Create session log as you work
ORCHESTRATOREOF

# Create PROJECT_STATE.json
cat > PROJECT_STATE.json << 'STATEEOF'
{
  "goal": "",
  "phase": "initialized",
  "todos": [],
  "in_progress": [],
  "completed": [],
  "blockers": [],
  "agent_registry": [],
  "current_session": {
    "started": "",
    "llm": "",
    "actions": []
  },
  "notes": "Project initialized. Awaiting goal definition."
}
STATEEOF

# Create agent template
cat > .templates/agent.md << 'AGENTEOF'
# Agent: {AGENT_NAME}

## Specialization
{One sentence describing this agent's core competency}

## Capabilities
- {Specific skill 1}
- {Specific skill 2}
- {Specific skill 3}

## Input Contract
Expects:
- `task`: What to do
- `context`: Relevant project state
- `success_criteria`: How to measure completion

## Output Contract
Returns:
- `status`: complete | failed | blocked
- `output`: Task-specific deliverable
- `state_updates`: Changes for PROJECT_STATE.json

## Constraints
- {Boundary or limitation}
- {Things this agent should NOT do}
- If requirements are unclear → STOP and ask for clarification

## Success Metrics
1. {Measurable outcome 1}
2. {Measurable outcome 2}

## Work Log Reference
See: `.project-catalog/agents/{AGENT_NAME}/work-log.md`
AGENTEOF

# Create handoff template
cat > .templates/handoff.md << 'HANDOFFEOF'
# Handoff: {FROM_AGENT} → {TO_AGENT}

Timestamp: {ISO_TIMESTAMP}
Reason: {Why this handoff is needed}

## Request
{What the receiving agent needs to do}

## Data Provided
{Any files, context, or information passed}

## Expected Output
{What the sending agent needs back}

## Status
- [ ] Received
- [ ] In Progress
- [ ] Complete

## Notes
{Any additional context}
HANDOFFEOF

# Create session template
cat > .templates/session.md << 'SESSIONEOF'
# Session: {DATE}

LLM: {Model used - e.g., Claude, GPT-4, Gemini}
Started: {ISO timestamp}
Ended: {ISO timestamp}

## Summary
{Brief description of what was accomplished}

## Goal Progress
- Previous phase: {phase before session}
- Current phase: {phase after session}
- Todos completed: {count}

## Agents Active
| Agent | Actions | Output |
|-------|---------|--------|
| {name} | {what they did} | {deliverable} |

## Handoffs
| From | To | Status |
|------|-----|--------|
| {agent} | {agent} | {pending/complete} |

## Decisions Made
- {Decision 1}: {outcome}
- {Decision 2}: {outcome}

## Blockers Encountered
- {Blocker 1}: {resolution}

## Next Session Should
1. {First priority}
2. {Second priority}
3. {Pending items}

## Raw Action Log
```
{Chronological list of actions taken}
```
SESSIONEOF

# Create initial catalog files
cat > .project-catalog/README.md << 'CATALOGEOF'
# Project Catalog

This folder contains the complete documentation history of this project, enabling:
- **LLM Switching**: Any AI can pick up where another left off
- **Audit Trail**: Full history of decisions and actions
- **Knowledge Transfer**: Onboard new team members or AIs
- **Debugging**: Trace back through what happened

## Structure

```
.project-catalog/
├── agents/          # Per-agent work history
│   └── {agent}/
│       ├── overview.md
│       └── work-log.md
├── handoffs/        # Agent-to-agent communication
│   └── {timestamp}-{from}-to-{to}.md
├── decisions/       # Key decisions with rationale
│   └── {timestamp}-{topic}.md
└── sessions/        # Per-session summaries
    └── {date}-session.md
```

## For New LLMs

If you're a new AI taking over this project:
1. Read `../ORCHESTRATOR.md` for operating instructions
2. Read `../PROJECT_STATE.json` for current status
3. Read the latest file in `sessions/` for recent context
4. Check `handoffs/` for any pending work
5. Continue where the previous AI left off
6. Document your own session when done
CATALOGEOF

# Create .gitkeep files
touch .agents/_archive/.gitkeep
touch .project-catalog/agents/.gitkeep
touch .project-catalog/handoffs/.gitkeep
touch .project-catalog/decisions/.gitkeep
touch .project-catalog/sessions/.gitkeep

echo ""
echo "✅ UDO v5 installed successfully!"
echo ""
echo "Files created:"
echo "  ORCHESTRATOR.md              - System instructions"
echo "  PROJECT_STATE.json           - Current status"
echo "  .agents/                     - Specialist definitions"
echo "  .templates/                  - Blueprints for agents, handoffs, sessions"
echo "  .project-catalog/            - Full documentation history"
echo "    ├── agents/                - Per-agent work logs"
echo "    ├── handoffs/              - Agent-to-agent communication"
echo "    ├── decisions/             - Key decisions"
echo "    └── sessions/              - Session summaries"
echo ""
echo "Usage:"
echo "  Tell your AI: \"Read ORCHESTRATOR.md and help me build [goal]\""
echo ""
echo "Switch LLMs anytime - the next AI reads the catalog and continues."
echo ""
