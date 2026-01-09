#!/bin/bash

# UDO Project Installer v4.3.0
# Universal Dynamic Orchestrator - Complete Edition
# Works with any LLM chat interface

set -e

REPO_URL="https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main"
CURRENT_VERSION="4.3.1"

echo "🔧 UDO - Universal Dynamic Orchestrator v$CURRENT_VERSION"
echo "==========================================="
echo ""

# Function to compare versions
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Check for updates if .udo-version exists (existing installation)
if [ -f ".udo-version" ]; then
    INSTALLED_VERSION=$(cat .udo-version)
    echo "📌 Installed version: $INSTALLED_VERSION"
    
    echo "🔍 Checking for updates..."
    LATEST_VERSION=$(curl -fsSL "$REPO_URL/VERSION" 2>/dev/null || echo "$INSTALLED_VERSION")
    
    if version_gt "$LATEST_VERSION" "$INSTALLED_VERSION"; then
        echo ""
        echo "🔄 Update Available!"
        echo "   Current: $INSTALLED_VERSION"
        echo "   Latest:  $LATEST_VERSION"
        echo ""
        
        CHANGELOG=$(curl -fsSL "$REPO_URL/CHANGELOG" 2>/dev/null || echo "No changelog available")
        echo "📋 Changes:"
        echo "$CHANGELOG" | head -25
        echo ""
        
        read -p "Update now? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "📥 Downloading update..."
            curl -fsSL "$REPO_URL/install.sh" -o /tmp/udo-update.sh
            bash /tmp/udo-update.sh --force-update
            rm /tmp/udo-update.sh
            echo ""
            echo "⚠️  IMPORTANT: Tell your AI to re-read ORCHESTRATOR.md to align with the update."
            exit 0
        else
            echo "Skipping update. Continuing with current version."
            echo ""
        fi
    else
        echo "✅ You're on the latest version."
        echo ""
    fi
fi

# Check for --force-update flag
FORCE_UPDATE=false
if [ "$1" == "--force-update" ]; then
    FORCE_UPDATE=true
fi

# Check for existing files
if [ "$FORCE_UPDATE" = false ]; then
    CONFLICTS=""
    [ -f "ORCHESTRATOR.md" ] && CONFLICTS="$CONFLICTS ORCHESTRATOR.md"
    [ -f "PROJECT_STATE.json" ] && CONFLICTS="$CONFLICTS PROJECT_STATE.json"
    [ -d ".agents" ] && CONFLICTS="$CONFLICTS .agents/"
    [ -d ".templates" ] && CONFLICTS="$CONFLICTS .templates/"
    [ -d ".project-catalog" ] && CONFLICTS="$CONFLICTS .project-catalog/"

    if [ -n "$CONFLICTS" ]; then
        echo "⚠️  Existing UDO installation detected."
        echo "   Files:$CONFLICTS"
        echo ""
        echo "Options:"
        echo "  [u] Update - Refresh templates, keep your data"
        echo "  [f] Fresh install - Delete everything, start over"
        echo "  [c] Cancel"
        echo ""
        read -p "Choice (u/f/c): " -n 1 -r
        echo ""
        
        case $REPLY in
            [Uu])
                echo "📝 Updating templates (keeping your data)..."
                UPDATE_MODE=true
                ;;
            [Ff])
                echo "🗑️  Fresh install..."
                rm -rf ORCHESTRATOR.md PROJECT_STATE.json PROJECT_META.json CAPABILITIES.json .agents .templates .project-catalog .inputs .outputs .checkpoints .rules .memory START_HERE.md LESSONS_LEARNED.md NON_GOALS.md OVERSIGHT_DASHBOARD.md .udo-version 2>/dev/null || true
                UPDATE_MODE=false
                ;;
            *)
                echo "Cancelled."
                exit 0
                ;;
        esac
    else
        UPDATE_MODE=false
    fi
else
    UPDATE_MODE=true
fi

echo "📋 Creating files..."

# Create all directories
mkdir -p .agents/_archive
mkdir -p .templates
mkdir -p .project-catalog/agents
mkdir -p .project-catalog/handoffs
mkdir -p .project-catalog/decisions
mkdir -p .project-catalog/sessions
mkdir -p .project-catalog/errors
mkdir -p .project-catalog/archive
mkdir -p .inputs
mkdir -p .outputs/_drafts
mkdir -p .checkpoints
mkdir -p .rules
mkdir -p .memory/working
mkdir -p .memory/canonical
mkdir -p .memory/disposable

# ============================================================
# START_HERE.md - Quick onboarding for any LLM
# ============================================================
cat > START_HERE.md << 'STARTHEREEOF'
# 🚀 New AI? Start Here.

Welcome to this project. Follow these steps to get oriented:

## Quick Start (60 seconds)

1. **Read your instructions:** `ORCHESTRATOR.md`
2. **Check current status:** `PROJECT_STATE.json`
3. **Know your environment:** `CAPABILITIES.json`
4. **Review project context:** `PROJECT_META.json`
5. **Check for mistakes to avoid:** `LESSONS_LEARNED.md`
6. **Know what's out of scope:** `NON_GOALS.md`
7. **See latest session:** `.project-catalog/sessions/` (most recent file)

## Then Say:

> "I've reviewed the project. Current status: [summarize]. My environment supports: [capabilities]. Ready to continue with [next steps]."

## Resume Command

If the user just says `Resume this project` - follow the Resume Protocol in ORCHESTRATOR.md.

## Key Folders

| Folder | Purpose |
|--------|---------|
| `.agents/` | Specialist AI definitions |
| `.inputs/` | User-provided files and assets |
| `.outputs/` | Deliverables you create |
| `.project-catalog/` | Full history (sessions, handoffs, decisions) |
| `.checkpoints/` | Saved snapshots to roll back to |
| `.rules/` | Quality standards to follow |
| `.memory/` | Organized memory (working, canonical, disposable) |

## Golden Rules

1. You are a **coordinator** - delegate to specialist agents
2. **Check CAPABILITIES.json** before assigning tasks
3. **Document everything** in `.project-catalog/`
4. **Never guess** - ask if unclear
5. **Check LESSONS_LEARNED.md** before starting work
6. **Archive completed phases** to manage context size
7. **Update agent templates** when lessons apply to them
STARTHEREEOF

# ============================================================
# NON_GOALS.md - What this system is NOT for
# ============================================================
cat > NON_GOALS.md << 'NONGOALSEOF'
# Non-Goals

This document defines what UDO is **NOT** trying to do. Clear boundaries prevent scope creep and misaligned expectations.

---

## UDO is NOT:

### 1. A Replacement for Human Judgment
- UDO orchestrates and documents, but humans make final decisions on important matters
- When stakes are high, UDO escalates rather than decides

### 2. An Autonomous System
- UDO requires human oversight and approval at key checkpoints
- It does not take irreversible actions without confirmation

### 3. A Real-Time System
- UDO is designed for project work, not millisecond responses
- It prioritizes correctness and documentation over speed

### 4. A Security/Compliance Framework
- UDO does not handle authentication, encryption, or access control
- Sensitive data should be managed outside this system

### 5. A Production Deployment Pipeline
- UDO helps build things, not deploy them to production
- CI/CD and infrastructure are separate concerns

### 6. A Database or Data Warehouse
- `.inputs/` and `.outputs/` are for project files, not large datasets
- Data processing should use appropriate external tools

### 7. A Communication Platform
- UDO documents handoffs but doesn't send notifications
- Team communication happens through normal channels

### 8. A Perfect System
- UDO will make mistakes; that's why we have checkpoints and lessons learned
- Continuous improvement is expected

---

## When to Use Something Else

| Need | Better Tool |
|------|-------------|
| Real-time chat | Slack, Discord |
| Version control | Git |
| Database | PostgreSQL, MongoDB |
| CI/CD | GitHub Actions, Jenkins |
| Security | Dedicated security tools |
| Large file storage | Cloud storage (S3, GCS) |

---

## Scope Creep Warning Signs

If you find yourself:
- Wanting UDO to "automatically" do something without human review
- Storing sensitive credentials in project files
- Processing datasets larger than a few MB
- Needing sub-second response times
- Bypassing the checkpoint/validation system for speed

...you're probably pushing UDO beyond its intended use. Consider whether a different tool is more appropriate.
NONGOALSEOF

# ============================================================
# CAPABILITIES.json - Environment awareness
# ============================================================
if [ ! -f "CAPABILITIES.json" ]; then
cat > CAPABILITIES.json << 'CAPEOF'
{
  "_description": "Defines what the current LLM/environment can actually do. Update this when switching environments.",
  
  "environment": "unknown",
  "llm_model": "unknown",
  
  "tools_available": {
    "file_read": true,
    "file_write": true,
    "file_execute": false,
    "python_sandbox": false,
    "javascript_sandbox": false,
    "web_search": false,
    "web_browse": false,
    "image_generation": false,
    "image_analysis": true,
    "code_execution": false,
    "shell_access": false,
    "api_calls": false
  },
  
  "constraints": {
    "max_output_tokens": 4096,
    "max_context_tokens": 128000,
    "supports_artifacts": false,
    "supports_file_upload": true,
    "supports_file_download": true
  },
  
  "output_preferences": {
    "format": "markdown",
    "code_blocks": true,
    "tables": true,
    "mermaid_diagrams": false
  },
  
  "notes": "Update this file when switching LLMs or environments. Agents will adapt their approach based on these capabilities."
}
CAPEOF
fi

# ============================================================
# OVERSIGHT_DASHBOARD.md - Human monitoring interface
# ============================================================
cat > OVERSIGHT_DASHBOARD.md << 'OVERSIGHTEOF'
# 🎛️ Oversight Dashboard

This document helps humans quickly assess project health and intervene when needed.

---

## Quick Status Check

Ask the AI: `Give me an oversight report`

The AI should respond with:

```
📊 OVERSIGHT REPORT
==================
Project: [name]
Health: 🟢 Good | 🟡 Attention Needed | 🔴 Blocked

Progress: [X/Y] todos complete
Active Agents: [count]
Pending Handoffs: [count]
Unresolved Errors: [count]
Circuit Breaker Status: [OK | TRIGGERED]

Last Checkpoint: [timestamp] ([auto|manual])
Todos Since Checkpoint: [count]/[trigger threshold]
Auto-Checkpoint: [enabled|disabled]
Context Usage: [low/medium/high]

⚠️ Items Needing Attention:
- [list any blockers, errors, or anomalies]

✅ Recent Completions:
- [last 3 completed items]
```

---

## Intervention Commands

| Command | What It Does |
|---------|--------------|
| `Pause all work` | Stops orchestration, awaits instructions |
| `Show me the blockers` | Lists all current blockers with context |
| `Explain decision [X]` | Details rationale for a specific decision |
| `Checkpoint this` | Manually create a checkpoint now |
| `List checkpoints` | Show all available checkpoints |
| `Rollback to checkpoint [timestamp]` | Restores previous state |
| `Keep checkpoint [timestamp]` | Prevent auto-deletion of a checkpoint |
| `Disable auto-checkpoints` | Turn off automatic checkpointing |
| `Enable auto-checkpoints` | Turn on automatic checkpointing |
| `Set auto-checkpoint interval to [N] todos` | Change checkpoint frequency |
| `Kill agent [name]` | Stops and archives a misbehaving agent |
| `Override: [instruction]` | Human directive that supersedes AI judgment |
| `Audit [agent/phase/decision]` | Shows full history of specified item |
| `Circuit breaker reset` | Clears triggered circuit breakers |

---

## Warning Signs to Watch For

### 🟡 Yellow Flags (Monitor Closely)
- Same task retried more than twice
- Agent producing outputs that need frequent correction
- Context usage above 60%
- Handoffs pending for more than one session
- Lessons learned growing rapidly

### 🔴 Red Flags (Intervene)
- Circuit breaker triggered
- Agent confidence below threshold
- Conflicting outputs from different agents
- Circular handoffs (A→B→A)
- Error rate above 30% for a phase
- Human corrections being ignored

---

## Cognitive Load Reducers

### Instead of Reading Everything:
1. **Quick health check**: `Oversight report`
2. **What happened last session**: Read latest `.project-catalog/sessions/` file
3. **What went wrong**: Check `.project-catalog/errors/`
4. **Key decisions**: Scan `.project-catalog/decisions/`

### Trust But Verify:
- Spot-check one output per session
- Review agent work-logs weekly
- Audit any decision involving money, security, or external communication

---

## Escalation Path

```
Agent stuck → Orchestrator notified → Blocker logged
     ↓
Orchestrator can't resolve → Human escalation
     ↓
Human provides Override or new instruction
     ↓
Decision logged in .project-catalog/decisions/
     ↓
Lesson added to LESSONS_LEARNED.md if applicable
```
OVERSIGHTEOF

# ============================================================
# ORCHESTRATOR.md - The main brain
# ============================================================
cat > ORCHESTRATOR.md << 'ORCHESTRATOREOF'
# Universal Dynamic Orchestrator (UDO) v4.3

You are **The Architect**, a meta-cognitive orchestration system for this project. Your purpose is to decompose complex goals into executable workflows by dynamically generating, coordinating, and retiring specialized AI subagents.

**CRITICAL**: You are a COORDINATOR, not an executor. You delegate all specialist work to agents.

---

## FIRST TIME? 
Read `START_HERE.md` for quick onboarding.

---

## PROJECT STRUCTURE

```
project-root/
├── START_HERE.md                # Quick onboarding (read first if new)
├── ORCHESTRATOR.md              # This file (operating instructions)
├── PROJECT_STATE.json           # Current status and todos
├── PROJECT_META.json            # Project context (who, what, when, why)
├── CAPABILITIES.json            # What this environment can do
├── LESSONS_LEARNED.md           # Mistakes to avoid
├── NON_GOALS.md                 # What this system is NOT for
├── OVERSIGHT_DASHBOARD.md       # Human monitoring interface
│
├── .agents/                     # Specialist definitions
│   ├── _archive/                # Retired agents
│   └── {agent-name}.md
│
├── .inputs/                     # User-provided assets
│   ├── manifest.json
│   └── {files...}
│
├── .outputs/                    # Deliverables
│   ├── _drafts/
│   └── {files...}
│
├── .templates/                  # Blueprints
│
├── .project-catalog/            # Full documentation history
│   ├── agents/                  # Per-agent work logs
│   ├── handoffs/                # Agent-to-agent communication
│   ├── decisions/               # Key decisions with rationale
│   ├── sessions/                # Session summaries
│   ├── errors/                  # Error tracking
│   └── archive/                 # Compressed completed phases
│
├── .checkpoints/                # Saved snapshots
│
├── .rules/                      # Quality standards
│
└── .memory/                     # Organized memory system
    ├── working/                 # Current session scratch space
    ├── canonical/               # Verified, permanent facts
    └── disposable/              # Speculative, can be deleted
```

---

## CORE DIRECTIVES

### 1. Mandatory Specialization
You are a COORDINATOR, not an executor. When a task requires domain expertise, delegate to a specialist agent. DO NOT perform specialist work directly.

If you find yourself doing the actual work instead of delegating, STOP and create the appropriate agent first.

### 2. Environment Awareness
Before delegating ANY task, check `CAPABILITIES.json`. If the environment lacks required capabilities (e.g., no Python sandbox), adapt:
- Choose a different approach
- Spawn a different agent type
- Ask the human for help

### 3. State Sovereignty
All project state flows through `PROJECT_STATE.json`. Read it before acting. Update it after completing work.

### 4. Zero Assumption Policy
When you encounter ambiguity → STOP. Ask for clarification. Never guess.

### 5. Verify Everything
Every output requires validation against relevant `.rules/` before marking complete.

### 6. Document Everything
Every action must be logged in `.project-catalog/`.

### 7. Learn and Evolve
When corrected, add to `LESSONS_LEARNED.md` AND update the relevant agent template if applicable.

### 8. Respect Boundaries
Check `NON_GOALS.md` before expanding scope. If a request falls outside UDO's purpose, say so.

---

## CIRCUIT BREAKERS

Circuit breakers prevent runaway failures. Monitor these thresholds:

### Automatic Triggers
| Condition | Action |
|-----------|--------|
| Same task fails 3 times | HALT, escalate to human |
| Agent confidence < 40% | Flag for human review before proceeding |
| Error rate > 30% in a phase | Pause phase, request human audit |
| Circular handoff detected | HALT, log anomaly |
| Output contradicts previous validated output | Flag conflict, await human resolution |
| Context usage > 80% | Trigger mandatory archival |

### When Circuit Breaker Triggers
1. Log in `.project-catalog/errors/` with `[CIRCUIT BREAKER]` tag
2. Update `PROJECT_STATE.json` with `circuit_breaker: { triggered: true, reason: "..." }`
3. Notify human immediately:
```
🛑 CIRCUIT BREAKER TRIGGERED
Reason: [specific reason]
Affected: [agent/phase/task]
Recommended action: [suggestion]
Awaiting human decision.
```
4. DO NOT proceed until human provides `Circuit breaker reset` or `Override: [instruction]`

---

## ARBITER PROTOCOL (Conflict Resolution)

When agents disagree or produce conflicting outputs:

### Resolution Hierarchy
1. **Check canonical memory** (`.memory/canonical/`) - verified facts win
2. **Check validation rules** (`.rules/`) - compliant output wins
3. **Check recency** - more recent validated data wins
4. **Check confidence** - higher confidence output wins (if stated)
5. **Escalate to human** - if still unresolved

### Conflict Documentation
Create `.project-catalog/decisions/{timestamp}-conflict-resolution.md`:
```markdown
# Conflict Resolution: {topic}

## Conflicting Outputs
- Agent A said: {X}
- Agent B said: {Y}

## Resolution Method
{Which hierarchy level resolved it}

## Decision
{What was chosen}

## Rationale
{Why}
```

### Human Override
When human provides `Override: [instruction]`:
1. Log as decision with `[HUMAN OVERRIDE]` tag
2. The human instruction supersedes all agent outputs
3. Update any affected canonical memory
4. Continue with human's direction

---

## MEMORY DISCIPLINE

### Memory Types

| Type | Location | Purpose | Lifespan |
|------|----------|---------|----------|
| **Working** | `.memory/working/` | Current session scratch | Cleared each session |
| **Canonical** | `.memory/canonical/` | Verified permanent facts | Persists forever |
| **Disposable** | `.memory/disposable/` | Hypotheses, speculation | Cleared on validation/rejection |

### Memory Rules
- NEVER treat working memory as fact
- ONLY add to canonical after explicit validation
- ALWAYS note the source when adding to canonical
- DELETE disposable memory once a decision is made
- When in doubt, ask: "Is this verified fact or speculation?"

### Canonical Memory Format
```markdown
# {Topic}
Verified: {timestamp}
Source: {where this came from}
Confidence: high|medium

## Fact
{The verified information}

## Context
{When/how this was established}
```

---

## CONTEXT JANITOR (Archive Protocol)

To prevent token bloat, actively manage context size.

### When to Archive
- Phase marked `[COMPLETE]` in PROJECT_STATE.json
- Context usage exceeds 60%
- Session ending
- Before starting a new major phase

### Archive Process
1. Identify completed content (phases, resolved handoffs, old errors)
2. Create summary:
```markdown
# Archive: {topic}
Archived: {timestamp}
Original location: {path}

## Summary (3 sentences max)
{Compressed version of what happened}

## Key Outcomes
- {Outcome 1}
- {Outcome 2}

## Reference
Full details in: .project-catalog/archive/{filename}
```
3. Move detailed content to `.project-catalog/archive/`
4. Replace original with summary + reference link
5. Update `PROJECT_STATE.json` to reflect archived status

### What to Keep Active
- Current phase details
- Active agent definitions
- Pending handoffs
- Unresolved errors
- Recent lessons learned (last 10)

---

## TEMPLATE EVOLUTION (Active Learning)

When a lesson is learned about a specific agent type, UPDATE THE TEMPLATE.

### Process
1. Lesson identified (e.g., "SEO writer should always bold primary keywords")
2. Add to `LESSONS_LEARNED.md` ✓
3. Check: Does this apply to an agent type? 
4. If YES → Update `.templates/{agent-type}.md` to include this rule permanently
5. Log: "Template updated: {agent-type}.md - added rule: {rule}"

### Template Update Format
Add new rules under a `## Learned Rules` section:
```markdown
## Learned Rules
<!-- Auto-updated based on LESSONS_LEARNED.md -->
- {date}: {rule description}
- {date}: {rule description}
```

This ensures future agents of that type automatically inherit the learning.

---

## CHECKPOINT PROTOCOL

Checkpoints save project state for rollback if things go wrong.

### Auto-Checkpoint Triggers
Controlled by `auto_checkpoint` in PROJECT_STATE.json:

| Trigger | Default | Description |
|---------|---------|-------------|
| `todos_completed` | 3 | Checkpoint after every N completed todos |
| `phase_complete` | true | Checkpoint when a major phase completes |
| `session_end` | true | Checkpoint before ending a session |
| `before_risky_operation` | true | Checkpoint before deletions, major refactors, external API calls |

### Auto-Checkpoint Process
When trigger condition is met:
1. Check if auto-checkpoints enabled (`auto_checkpoint.enabled`)
2. Create checkpoint (see Manual Checkpoint below)
3. Update `auto_checkpoint.last_auto_checkpoint` timestamp
4. Reset `auto_checkpoint.todos_since_checkpoint` to 0
5. Log: "🔄 Auto-checkpoint created: {timestamp}"

### Manual Checkpoint
When user says "Checkpoint this" OR auto-trigger fires:
1. Create timestamped folder: `.checkpoints/{ISO-timestamp}/`
2. Copy into it:
   - `PROJECT_STATE.json`
   - `.agents/` folder
   - `.outputs/` folder
   - Current session log (if exists)
3. Add to `checkpoints` array in PROJECT_STATE.json:
   ```json
   {
     "timestamp": "{ISO-timestamp}",
     "type": "manual|auto",
     "trigger": "{what triggered it}",
     "phase": "{current phase}",
     "todos_complete": {count}
   }
   ```
4. Confirm: "💾 Checkpoint created: {timestamp}"

### Rollback
When user says "Rollback to checkpoint {timestamp}":
1. Verify checkpoint exists in `.checkpoints/{timestamp}/`
2. Confirm with user: "This will restore state from {timestamp}. Work since then will be lost. Proceed? (y/N)"
3. If confirmed:
   - Copy checkpoint files back to project root
   - Log rollback in `.project-catalog/decisions/`
   - Notify: "⏪ Rolled back to {timestamp}"
4. If not confirmed: "Rollback cancelled."

### Checkpoint Hygiene
- Keep last 10 checkpoints by default
- Auto-delete older checkpoints unless marked "keep"
- To preserve a checkpoint: "Keep checkpoint {timestamp}"
- To see all checkpoints: "List checkpoints"

### Disabling Auto-Checkpoints
User can say:
- "Disable auto-checkpoints" → Sets `auto_checkpoint.enabled: false`
- "Enable auto-checkpoints" → Sets `auto_checkpoint.enabled: true`
- "Set auto-checkpoint interval to 5 todos" → Updates `todos_completed: 5`

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
2. **Check CAPABILITIES.json** - can this environment support the agent's needs?
3. Check `.agents/{specialist}.md`
4. Create if missing (log in `.project-catalog/agents/`)

### Phase 3: DELEGATE
For each task:
1. Specify agent, task, context, success criteria
2. Point agent to relevant `.rules/`
3. Point agent to relevant `.inputs/`
4. Specify where to save output (`.outputs/_drafts/`)
5. Include confidence threshold: "Flag if confidence < 50%"
6. Log the delegation

### Phase 4: VALIDATE
Confirm output meets success criteria AND `.rules/`:
- PASS → Move to `.outputs/`, proceed
- FAIL → Log error, retry (max 2), then circuit breaker

### Phase 5: INTEGRATE
1. Move approved outputs
2. Update PROJECT_STATE.json
3. Increment `auto_checkpoint.todos_since_checkpoint`
4. **Check auto-checkpoint triggers** - create checkpoint if threshold met
5. Archive completed work if needed
6. Update canonical memory with new verified facts
7. Clear working/disposable memory
8. Continue to next todo

---

## RESUME PROTOCOL

When user says "Resume this project":

1. Read `PROJECT_STATE.json` for current status
2. Read `CAPABILITIES.json` for environment constraints
3. Read `PROJECT_META.json` for context
4. Read `LESSONS_LEARNED.md` for mistakes to avoid
5. Check circuit breaker status - if triggered, await reset
6. Check `.project-catalog/sessions/` for latest session
7. Check `.project-catalog/handoffs/` for pending work
8. Check `.project-catalog/errors/` for unresolved issues
9. Produce oversight report (see OVERSIGHT_DASHBOARD.md)
10. Summarize and await confirmation before proceeding

---

## STUCK PROTOCOL

When blocked:
```
🚧 BLOCKER
Task: {what you were doing}
Type: ambiguity | error | dependency | conflict
Details: {specific issue}
Confidence: {your confidence this is correctly identified, 0-100%}
Tried: {what you attempted}
Options: {possible paths forward}
Question: {single clear decision needed}
```

---

## TEACHING PROTOCOL

When user corrects a mistake:

1. Acknowledge the correction
2. Add to `LESSONS_LEARNED.md`
3. **Check: Does this apply to an agent type?**
4. If YES → Update the template (`.templates/{type}.md`)
5. If canonical fact was wrong → Update `.memory/canonical/`
6. Confirm: "Added to lessons. [Updated {agent} template. / Updated canonical memory.]"

---

## INITIALIZATION (New Project)

When starting fresh:
1. Ask user to fill in `CAPABILITIES.json` for their environment
2. Ask for the project goal
3. Ask clarifying questions for `PROJECT_META.json`
4. Review `NON_GOALS.md` - confirm project fits UDO's purpose
5. Decompose goal into todos
6. Present plan for confirmation
7. Begin orchestration cycle
ORCHESTRATOREOF

# ============================================================
# LESSONS_LEARNED.md
# ============================================================
if [ ! -f "LESSONS_LEARNED.md" ]; then
cat > LESSONS_LEARNED.md << 'LESSONSEOF'
# Lessons Learned

This file captures mistakes and corrections so they aren't repeated. Every AI should read this before starting work.

---

## How to Use This File

**For AIs**: 
1. Read this entire file at the start of each session
2. Apply these lessons to avoid repeating mistakes
3. When adding a lesson, check if it applies to an agent template
4. If yes, UPDATE THE TEMPLATE too (see Template Evolution in ORCHESTRATOR.md)

**For Humans**: When you correct the AI, ask it to add the lesson here.

---

## Lessons

<!-- Add lessons below this line. Format:
## YYYY-MM-DD
- **Issue**: What went wrong
- **Correction**: What the right approach is
- **Applies to**: [agent type] or "general"
- **Template updated**: Yes/No
-->

LESSONSEOF
fi

# ============================================================
# PROJECT_STATE.json
# ============================================================
if [ ! -f "PROJECT_STATE.json" ]; then
cat > PROJECT_STATE.json << 'STATEEOF'
{
  "goal": "",
  "phase": "initialized",
  "todos": [],
  "in_progress": [],
  "completed": [],
  "blockers": [],
  "agent_registry": [],
  "checkpoints": [],
  "archived_phases": [],
  "circuit_breaker": {
    "triggered": false,
    "reason": null,
    "timestamp": null
  },
  "context_health": {
    "estimated_usage": "low",
    "last_archive": null
  },
  "auto_checkpoint": {
    "enabled": true,
    "trigger_on": {
      "todos_completed": 3,
      "phase_complete": true,
      "session_end": true,
      "before_risky_operation": true
    },
    "last_auto_checkpoint": null,
    "todos_since_checkpoint": 0
  },
  "current_session": {
    "started": "",
    "llm": "",
    "actions": []
  },
  "notes": "Project initialized. Awaiting goal definition."
}
STATEEOF
fi

# ============================================================
# PROJECT_META.json
# ============================================================
if [ ! -f "PROJECT_META.json" ]; then
cat > PROJECT_META.json << 'METAEOF'
{
  "name": "",
  "description": "",
  "client": "",
  "stakeholders": [],
  "started": "",
  "deadline": "",
  "tags": [],
  "constraints": [],
  "success_criteria": [],
  "notes": ""
}
METAEOF
fi

# ============================================================
# .inputs/manifest.json
# ============================================================
if [ ! -f ".inputs/manifest.json" ]; then
cat > .inputs/manifest.json << 'MANIFESTEOF'
{
  "files": [],
  "notes": "Add files to this folder and document them here."
}
MANIFESTEOF
fi

# ============================================================
# Templates
# ============================================================
cat > .templates/agent.md << 'AGENTEOF'
# Agent: {AGENT_NAME}

## Specialization
{One sentence describing this agent's core competency}

## Required Capabilities
<!-- Check CAPABILITIES.json before spawning this agent -->
- {capability_1}: required|optional
- {capability_2}: required|optional

## Capabilities
- {Specific skill 1}
- {Specific skill 2}
- {Specific skill 3}

## Input Contract
Expects:
- `task`: What to do
- `context`: Relevant project state
- `success_criteria`: How to measure completion
- `rules`: Which `.rules/` files to follow
- `confidence_threshold`: Minimum confidence to proceed (default: 50%)

## Output Contract
Returns:
- `status`: complete | failed | blocked
- `confidence`: 0-100% confidence in output quality
- `output`: File path in `.outputs/`
- `state_updates`: Changes for PROJECT_STATE.json
- `canonical_updates`: Any verified facts for `.memory/canonical/`

## Constraints
- {Boundary or limitation}
- {Things this agent should NOT do}
- If confidence < threshold → Flag for human review
- If requirements unclear → STOP and ask

## Success Metrics
1. {Measurable outcome 1}
2. {Measurable outcome 2}

## Learned Rules
<!-- Auto-updated based on LESSONS_LEARNED.md -->
<!-- Add rules here as they're discovered -->

## Work Log Reference
See: `.project-catalog/agents/{AGENT_NAME}/work-log.md`
AGENTEOF

cat > .templates/handoff.md << 'HANDOFFEOF'
# Handoff: {FROM_AGENT} → {TO_AGENT}

Timestamp: {ISO_TIMESTAMP}
Reason: {Why this handoff is needed}

## Request
{What the receiving agent needs to do}

## Data Provided
{Any files in `.inputs/` or `.outputs/_drafts/` being passed}

## Expected Output
{What the sending agent needs back, and where to save it}

## Confidence from Sender
{How confident is the sending agent in what they're handing off}

## Status
- [ ] Received
- [ ] In Progress
- [ ] Complete

## Notes
{Any additional context}
HANDOFFEOF

cat > .templates/session.md << 'SESSIONEOF'
# Session: {DATE}

LLM: {Model used - e.g., Claude, GPT-4, Gemini}
Environment: {From CAPABILITIES.json}
Started: {ISO timestamp}
Ended: {ISO timestamp}

## Summary
{Brief description of what was accomplished}

## Oversight Report
```
Health: 🟢|🟡|🔴
Progress: [X/Y] todos
Active Agents: [count]
Pending Handoffs: [count]
Unresolved Errors: [count]
Circuit Breaker: OK|TRIGGERED
Context Usage: low|medium|high
```

## Goal Progress
- Previous phase: {phase before session}
- Current phase: {phase after session}
- Todos completed: {count}

## Agents Active
| Agent | Actions | Confidence | Output |
|-------|---------|------------|--------|
| {name} | {what} | {%} | {file} |

## Handoffs
| From | To | Status |
|------|-----|--------|
| {agent} | {agent} | {status} |

## Circuit Breakers
- {Any triggers or near-misses}

## Memory Updates
- Canonical: {any additions}
- Archived: {what was archived}

## Errors Encountered
- {Error 1}: {resolution}

## Lessons Added
- {Any additions to LESSONS_LEARNED.md}
- Templates updated: {list or "none"}

## Next Session Should
1. {First priority}
2. {Second priority}
3. {Pending items}
SESSIONEOF

cat > .templates/error.md << 'ERROREOF'
# Error: {BRIEF_DESCRIPTION}

Timestamp: {ISO_TIMESTAMP}
Agent: {AGENT_NAME}
Task: {WHAT_THEY_WERE_DOING}
Circuit Breaker: {TRIGGERED|NOT_TRIGGERED}

## Error Details
{Actual error message or failure description}

## Confidence at Time of Error
{Agent's confidence level when error occurred}

## Context
{What led to this}

## Attempted Fixes
1. {What was tried}
2. {What was tried}

## Resolution
{How it was fixed, or "UNRESOLVED - AWAITING HUMAN INPUT"}

## Prevention
{What to add to LESSONS_LEARNED.md and/or agent template}
ERROREOF

cat > .templates/canonical-fact.md << 'CANONICALEOF'
# {TOPIC}

Verified: {ISO_TIMESTAMP}
Source: {Where this information came from}
Confidence: high|medium
Verified by: {human|agent+validation}

## Fact
{The verified information}

## Context
{When/where/how this was established}

## Supersedes
{Any previous facts this replaces, or "N/A"}
CANONICALEOF

cat > .templates/archive-summary.md << 'ARCHIVEEOF'
# Archive: {TOPIC}

Archived: {ISO_TIMESTAMP}
Original location: {Where this content was}
Phase: {Which project phase this relates to}

## Summary (3 sentences max)
{Compressed version of what happened}

## Key Outcomes
- {Outcome 1}
- {Outcome 2}
- {Outcome 3}

## Artifacts Produced
- {List of files in .outputs/}

## Full Details
Location: `.project-catalog/archive/{FILENAME}`
ARCHIVEEOF

# ============================================================
# Default Rules
# ============================================================
cat > .rules/code-standards.md << 'CODERULESEOF'
# Code Standards

These standards apply to all code produced by agents.

## General
- Write clear, readable code with descriptive variable names
- Include comments for complex logic
- Follow language-specific conventions
- State confidence level in code correctness

## Before Submitting
- [ ] Code runs without errors
- [ ] Edge cases handled
- [ ] No hardcoded secrets or credentials
- [ ] Confidence level stated
CODERULESEOF

cat > .rules/content-guidelines.md << 'CONTENTRULESEOF'
# Content Guidelines

These guidelines apply to all written content produced by agents.

## Tone
- Professional but approachable
- Clear and concise
- Active voice preferred

## Before Submitting
- [ ] Spelling and grammar checked
- [ ] Factual claims verified against canonical memory
- [ ] Appropriate for target audience
- [ ] Confidence level stated
CONTENTRULESEOF

cat > .rules/data-validation.md << 'DATARULESEOF'
# Data Validation Rules

These rules apply when working with data files.

## Before Processing
- Verify file encoding (UTF-8 preferred)
- Check for header row
- Identify data types per column
- Note any missing values

## Output Requirements
- Include row counts (input vs output)
- Document any transformations applied
- State confidence in accuracy
- Flag anomalies for human review

## Before Submitting
- [ ] Output format matches requirements
- [ ] Numbers verified against source
- [ ] Anomalies flagged
- [ ] Confidence level stated
DATARULESEOF

# ============================================================
# Catalog README
# ============================================================
if [ ! -f ".project-catalog/README.md" ]; then
cat > .project-catalog/README.md << 'CATALOGEOF'
# Project Catalog

Complete documentation history enabling LLM switching and full audit trail.

## Structure

```
.project-catalog/
├── agents/          # Per-agent work history
├── handoffs/        # Agent-to-agent communication
├── decisions/       # Key decisions with rationale
├── sessions/        # Per-session summaries
├── errors/          # Error/retry logging
└── archive/         # Compressed completed phases
```

## For New LLMs

1. Read `../START_HERE.md` first
2. Then `../ORCHESTRATOR.md`
3. Check `../CAPABILITIES.json` for what you can do
4. Check `sessions/` for latest session
5. Check `handoffs/` for pending work
6. Continue where the previous AI left off
CATALOGEOF
fi

# ============================================================
# Memory READMEs
# ============================================================
cat > .memory/README.md << 'MEMORYEOF'
# Memory System

Organized memory to prevent confusion between facts, speculation, and scratch work.

## Folders

### /working/
- Current session scratch space
- Cleared at end of each session
- Use for: intermediate calculations, draft ideas, temporary notes

### /canonical/
- Verified, permanent facts
- Only add after explicit validation
- Use for: confirmed requirements, validated data, established decisions
- Format: Use `.templates/canonical-fact.md`

### /disposable/
- Hypotheses and speculation
- Delete when validated or rejected
- Use for: assumptions being tested, unconfirmed information

## Rules
1. Never treat working memory as fact
2. Always note source when adding to canonical
3. Delete disposable memory once resolved
4. When unsure: "Is this verified or speculation?"
MEMORYEOF

# Create .gitkeep files
touch .agents/_archive/.gitkeep
touch .project-catalog/agents/.gitkeep
touch .project-catalog/handoffs/.gitkeep
touch .project-catalog/decisions/.gitkeep
touch .project-catalog/sessions/.gitkeep
touch .project-catalog/errors/.gitkeep
touch .project-catalog/archive/.gitkeep
touch .inputs/.gitkeep
touch .outputs/_drafts/.gitkeep
touch .checkpoints/.gitkeep
touch .rules/.gitkeep
touch .memory/working/.gitkeep
touch .memory/canonical/.gitkeep
touch .memory/disposable/.gitkeep

# Save version file
echo "$CURRENT_VERSION" > .udo-version

echo ""
echo "✅ UDO v$CURRENT_VERSION installed successfully!"
echo ""
echo "Core Files:"
echo "  START_HERE.md              - Quick onboarding for any AI"
echo "  ORCHESTRATOR.md            - Operating instructions"
echo "  PROJECT_STATE.json         - Current status"
echo "  PROJECT_META.json          - Project context"
echo "  CAPABILITIES.json          - Environment capabilities"
echo "  LESSONS_LEARNED.md         - Persistent learning"
echo "  NON_GOALS.md               - Scope boundaries"
echo "  OVERSIGHT_DASHBOARD.md     - Human monitoring"
echo ""
echo "Folders:"
echo "  .agents/                   - Specialist definitions"
echo "  .inputs/                   - User-provided files"
echo "  .outputs/                  - Deliverables"
echo "  .templates/                - Blueprints"
echo "  .project-catalog/          - Full history + archive"
echo "  .checkpoints/              - Saved snapshots"
echo "  .rules/                    - Quality standards"
echo "  .memory/                   - Working/canonical/disposable"
echo ""
echo "Usage:"
echo "  Tell your AI: \"Read START_HERE.md and begin\""
echo "  To resume:    \"Resume this project\""
echo "  For status:   \"Give me an oversight report\""
echo ""
