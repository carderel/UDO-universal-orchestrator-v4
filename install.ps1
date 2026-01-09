# UDO Project Installer v4.3.1
# Universal Dynamic Orchestrator - Complete Edition
# PowerShell version for Windows

$ErrorActionPreference = "Stop"
$CURRENT_VERSION = "4.3.1"
$REPO_URL = "https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main"

Write-Host "🔧 UDO - Universal Dynamic Orchestrator v$CURRENT_VERSION" -ForegroundColor Cyan
Write-Host "==========================================="
Write-Host ""

# Function to compare versions
function Compare-Version {
    param([string]$v1, [string]$v2)
    $ver1 = [Version]$v1
    $ver2 = [Version]$v2
    return $ver1 -lt $ver2
}

# Check for updates if .udo-version exists
if (Test-Path ".udo-version") {
    $INSTALLED_VERSION = Get-Content ".udo-version" -Raw
    $INSTALLED_VERSION = $INSTALLED_VERSION.Trim()
    Write-Host "📌 Installed version: $INSTALLED_VERSION"
    
    Write-Host "🔍 Checking for updates..."
    try {
        $LATEST_VERSION = (Invoke-WebRequest -Uri "$REPO_URL/VERSION" -UseBasicParsing).Content.Trim()
        
        if (Compare-Version $INSTALLED_VERSION $LATEST_VERSION) {
            Write-Host ""
            Write-Host "🔄 Update Available!" -ForegroundColor Yellow
            Write-Host "   Current: $INSTALLED_VERSION"
            Write-Host "   Latest:  $LATEST_VERSION"
            Write-Host ""
            
            try {
                $CHANGELOG = (Invoke-WebRequest -Uri "$REPO_URL/CHANGELOG" -UseBasicParsing).Content
                Write-Host "📋 Changes:"
                $CHANGELOG -split "`n" | Select-Object -First 25 | ForEach-Object { Write-Host $_ }
                Write-Host ""
            } catch {
                Write-Host "📋 Changelog not available"
            }
            
            $response = Read-Host "Update now? (y/N)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                Write-Host "📥 Downloading update..."
                $script = (Invoke-WebRequest -Uri "$REPO_URL/install.ps1" -UseBasicParsing).Content
                Invoke-Expression $script
                Write-Host ""
                Write-Host "⚠️  IMPORTANT: Tell your AI to re-read ORCHESTRATOR.md to align with the update." -ForegroundColor Yellow
                exit 0
            } else {
                Write-Host "Skipping update. Continuing with current version."
                Write-Host ""
            }
        } else {
            Write-Host "✅ You're on the latest version." -ForegroundColor Green
            Write-Host ""
        }
    } catch {
        Write-Host "Could not check for updates. Continuing..."
    }
}

# Check for existing files
$CONFLICTS = @()
if (Test-Path "ORCHESTRATOR.md") { $CONFLICTS += "ORCHESTRATOR.md" }
if (Test-Path "PROJECT_STATE.json") { $CONFLICTS += "PROJECT_STATE.json" }
if (Test-Path ".agents") { $CONFLICTS += ".agents/" }
if (Test-Path ".templates") { $CONFLICTS += ".templates/" }
if (Test-Path ".project-catalog") { $CONFLICTS += ".project-catalog/" }

if ($CONFLICTS.Count -gt 0) {
    Write-Host "⚠️  Existing UDO installation detected." -ForegroundColor Yellow
    Write-Host "   Files: $($CONFLICTS -join ', ')"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  [u] Update - Refresh templates, keep your data"
    Write-Host "  [f] Fresh install - Delete everything, start over"
    Write-Host "  [c] Cancel"
    Write-Host ""
    $choice = Read-Host "Choice (u/f/c)"
    
    switch ($choice.ToLower()) {
        'u' {
            Write-Host "📝 Updating templates (keeping your data)..."
            $UPDATE_MODE = $true
        }
        'f' {
            Write-Host "🗑️  Fresh install..."
            $itemsToRemove = @(
                "ORCHESTRATOR.md", "PROJECT_STATE.json", "PROJECT_META.json", 
                "CAPABILITIES.json", ".agents", ".templates", ".project-catalog",
                ".inputs", ".outputs", ".checkpoints", ".rules", ".memory",
                "START_HERE.md", "LESSONS_LEARNED.md", "NON_GOALS.md", 
                "OVERSIGHT_DASHBOARD.md", ".udo-version"
            )
            foreach ($item in $itemsToRemove) {
                if (Test-Path $item) {
                    Remove-Item -Recurse -Force $item
                }
            }
            $UPDATE_MODE = $false
        }
        default {
            Write-Host "Cancelled."
            exit 0
        }
    }
} else {
    $UPDATE_MODE = $false
}

Write-Host "📋 Creating files..."

# Create all directories
$directories = @(
    ".agents\_archive",
    ".templates",
    ".project-catalog\agents",
    ".project-catalog\handoffs",
    ".project-catalog\decisions",
    ".project-catalog\sessions",
    ".project-catalog\errors",
    ".project-catalog\archive",
    ".inputs",
    ".outputs\_drafts",
    ".checkpoints",
    ".rules",
    ".memory\working",
    ".memory\canonical",
    ".memory\disposable"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# ============================================================
# START_HERE.md
# ============================================================
$START_HERE = @'
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
'@
Set-Content -Path "START_HERE.md" -Value $START_HERE -Encoding UTF8

# ============================================================
# NON_GOALS.md
# ============================================================
$NON_GOALS = @'
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
'@
Set-Content -Path "NON_GOALS.md" -Value $NON_GOALS -Encoding UTF8

# ============================================================
# CAPABILITIES.json
# ============================================================
if (-not (Test-Path "CAPABILITIES.json")) {
$CAPABILITIES = @'
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
'@
Set-Content -Path "CAPABILITIES.json" -Value $CAPABILITIES -Encoding UTF8
}

# ============================================================
# OVERSIGHT_DASHBOARD.md
# ============================================================
$OVERSIGHT = @'
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
'@
Set-Content -Path "OVERSIGHT_DASHBOARD.md" -Value $OVERSIGHT -Encoding UTF8

# ============================================================
# ORCHESTRATOR.md (abbreviated - key sections)
# ============================================================
$ORCHESTRATOR = @'
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

### 2. Environment Awareness
Before delegating ANY task, check `CAPABILITIES.json`. If the environment lacks required capabilities, adapt.

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
Check `NON_GOALS.md` before expanding scope.

---

## CIRCUIT BREAKERS

Circuit breakers prevent runaway failures. Monitor these thresholds:

| Condition | Action |
|-----------|--------|
| Same task fails 3 times | HALT, escalate to human |
| Agent confidence < 40% | Flag for human review |
| Error rate > 30% in a phase | Pause phase, request audit |
| Circular handoff detected | HALT, log anomaly |
| Context usage > 80% | Trigger mandatory archival |

---

## CHECKPOINT PROTOCOL

### Auto-Checkpoint Triggers
| Trigger | Default | Description |
|---------|---------|-------------|
| `todos_completed` | 3 | Checkpoint after every N completed todos |
| `phase_complete` | true | Checkpoint when a major phase completes |
| `session_end` | true | Checkpoint before ending a session |
| `before_risky_operation` | true | Checkpoint before deletions, major refactors |

---

## THE ORCHESTRATION CYCLE

### Phase 1: DECOMPOSE
Break the goal into atomic todos.

### Phase 2: CLASSIFY
Identify required specialist, check capabilities, create agent if needed.

### Phase 3: DELEGATE
Assign task with context, rules, success criteria.

### Phase 4: VALIDATE
Confirm output meets criteria. PASS → proceed. FAIL → retry (max 2), then circuit breaker.

### Phase 5: INTEGRATE
1. Move approved outputs
2. Update PROJECT_STATE.json
3. Check auto-checkpoint triggers
4. Archive completed work if needed
5. Continue to next todo

---

## RESUME PROTOCOL

When user says "Resume this project":
1. Read PROJECT_STATE.json, CAPABILITIES.json, PROJECT_META.json
2. Read LESSONS_LEARNED.md
3. Check circuit breaker status
4. Check latest session and pending handoffs
5. Produce oversight report
6. Summarize and await confirmation

---

## INITIALIZATION (New Project)

1. Ask user to fill in CAPABILITIES.json
2. Ask for the project goal
3. Ask clarifying questions for PROJECT_META.json
4. Review NON_GOALS.md
5. Decompose goal into todos
6. Present plan for confirmation
7. Begin orchestration cycle
'@
Set-Content -Path "ORCHESTRATOR.md" -Value $ORCHESTRATOR -Encoding UTF8

# ============================================================
# LESSONS_LEARNED.md
# ============================================================
if (-not (Test-Path "LESSONS_LEARNED.md")) {
$LESSONS = @'
# Lessons Learned

This file captures mistakes and corrections so they aren't repeated. Every AI should read this before starting work.

---

## How to Use This File

**For AIs**: 
1. Read this entire file at the start of each session
2. Apply these lessons to avoid repeating mistakes
3. When adding a lesson, check if it applies to an agent template
4. If yes, UPDATE THE TEMPLATE too

**For Humans**: When you correct the AI, ask it to add the lesson here.

---

## Lessons

<!-- Add lessons below this line -->

'@
Set-Content -Path "LESSONS_LEARNED.md" -Value $LESSONS -Encoding UTF8
}

# ============================================================
# PROJECT_STATE.json
# ============================================================
if (-not (Test-Path "PROJECT_STATE.json")) {
$STATE = @'
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
'@
Set-Content -Path "PROJECT_STATE.json" -Value $STATE -Encoding UTF8
}

# ============================================================
# PROJECT_META.json
# ============================================================
if (-not (Test-Path "PROJECT_META.json")) {
$META = @'
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
'@
Set-Content -Path "PROJECT_META.json" -Value $META -Encoding UTF8
}

# ============================================================
# .inputs/manifest.json
# ============================================================
if (-not (Test-Path ".inputs\manifest.json")) {
$MANIFEST = @'
{
  "files": [],
  "notes": "Add files to this folder and document them here."
}
'@
Set-Content -Path ".inputs\manifest.json" -Value $MANIFEST -Encoding UTF8
}

# ============================================================
# Templates
# ============================================================
$AGENT_TEMPLATE = @'
# Agent: {AGENT_NAME}

## Specialization
{One sentence describing this agent's core competency}

## Required Capabilities
- {capability_1}: required|optional

## Capabilities
- {Specific skill 1}
- {Specific skill 2}

## Input Contract
Expects:
- `task`: What to do
- `context`: Relevant project state
- `success_criteria`: How to measure completion
- `confidence_threshold`: Minimum confidence to proceed (default: 50%)

## Output Contract
Returns:
- `status`: complete | failed | blocked
- `confidence`: 0-100%
- `output`: File path in `.outputs/`

## Constraints
- If confidence < threshold → Flag for human review
- If requirements unclear → STOP and ask

## Learned Rules
<!-- Auto-updated based on LESSONS_LEARNED.md -->

## Work Log Reference
See: `.project-catalog/agents/{AGENT_NAME}/work-log.md`
'@
Set-Content -Path ".templates\agent.md" -Value $AGENT_TEMPLATE -Encoding UTF8

$HANDOFF_TEMPLATE = @'
# Handoff: {FROM_AGENT} → {TO_AGENT}

Timestamp: {ISO_TIMESTAMP}
Reason: {Why this handoff is needed}

## Request
{What the receiving agent needs to do}

## Data Provided
{Files being passed}

## Expected Output
{What's needed back}

## Status
- [ ] Received
- [ ] In Progress
- [ ] Complete
'@
Set-Content -Path ".templates\handoff.md" -Value $HANDOFF_TEMPLATE -Encoding UTF8

$SESSION_TEMPLATE = @'
# Session: {DATE}

LLM: {Model used}
Started: {timestamp}
Ended: {timestamp}

## Summary
{What was accomplished}

## Oversight Report
```
Health: 🟢|🟡|🔴
Progress: [X/Y] todos
Circuit Breaker: OK|TRIGGERED
```

## Agents Active
| Agent | Actions | Output |
|-------|---------|--------|

## Next Session Should
1. {First priority}
2. {Second priority}
'@
Set-Content -Path ".templates\session.md" -Value $SESSION_TEMPLATE -Encoding UTF8

# ============================================================
# Default Rules
# ============================================================
$CODE_RULES = @'
# Code Standards

## General
- Write clear, readable code
- Include comments for complex logic
- Follow language-specific conventions

## Before Submitting
- [ ] Code runs without errors
- [ ] Edge cases handled
- [ ] Confidence level stated
'@
Set-Content -Path ".rules\code-standards.md" -Value $CODE_RULES -Encoding UTF8

$CONTENT_RULES = @'
# Content Guidelines

## Tone
- Professional but approachable
- Clear and concise

## Before Submitting
- [ ] Spelling and grammar checked
- [ ] Factual claims verified
- [ ] Confidence level stated
'@
Set-Content -Path ".rules\content-guidelines.md" -Value $CONTENT_RULES -Encoding UTF8

$DATA_RULES = @'
# Data Validation Rules

## Before Processing
- Verify file encoding
- Check for header row
- Note any missing values

## Before Submitting
- [ ] Output format matches requirements
- [ ] Numbers verified
- [ ] Confidence level stated
'@
Set-Content -Path ".rules\data-validation.md" -Value $DATA_RULES -Encoding UTF8

# ============================================================
# Catalog README
# ============================================================
if (-not (Test-Path ".project-catalog\README.md")) {
$CATALOG_README = @'
# Project Catalog

Complete documentation history enabling LLM switching and full audit trail.

## For New LLMs

1. Read `../START_HERE.md` first
2. Then `../ORCHESTRATOR.md`
3. Check `../CAPABILITIES.json`
4. Check `sessions/` for latest session
5. Continue where the previous AI left off
'@
Set-Content -Path ".project-catalog\README.md" -Value $CATALOG_README -Encoding UTF8
}

# ============================================================
# Memory README
# ============================================================
$MEMORY_README = @'
# Memory System

## Folders

### /working/
- Current session scratch space
- Cleared at end of each session

### /canonical/
- Verified, permanent facts
- Only add after explicit validation

### /disposable/
- Hypotheses and speculation
- Delete when validated or rejected
'@
Set-Content -Path ".memory\README.md" -Value $MEMORY_README -Encoding UTF8

# Create .gitkeep files
$gitkeepPaths = @(
    ".agents\_archive\.gitkeep",
    ".project-catalog\agents\.gitkeep",
    ".project-catalog\handoffs\.gitkeep",
    ".project-catalog\decisions\.gitkeep",
    ".project-catalog\sessions\.gitkeep",
    ".project-catalog\errors\.gitkeep",
    ".project-catalog\archive\.gitkeep",
    ".inputs\.gitkeep",
    ".outputs\_drafts\.gitkeep",
    ".checkpoints\.gitkeep",
    ".rules\.gitkeep",
    ".memory\working\.gitkeep",
    ".memory\canonical\.gitkeep",
    ".memory\disposable\.gitkeep"
)

foreach ($path in $gitkeepPaths) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType File -Path $path -Force | Out-Null
    }
}

# Save version file
Set-Content -Path ".udo-version" -Value $CURRENT_VERSION -Encoding UTF8

Write-Host ""
Write-Host "✅ UDO v$CURRENT_VERSION installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Core Files:"
Write-Host "  START_HERE.md              - Quick onboarding for any AI"
Write-Host "  ORCHESTRATOR.md            - Operating instructions"
Write-Host "  PROJECT_STATE.json         - Current status"
Write-Host "  PROJECT_META.json          - Project context"
Write-Host "  CAPABILITIES.json          - Environment capabilities"
Write-Host "  LESSONS_LEARNED.md         - Persistent learning"
Write-Host "  NON_GOALS.md               - Scope boundaries"
Write-Host "  OVERSIGHT_DASHBOARD.md     - Human monitoring"
Write-Host ""
Write-Host "Folders:"
Write-Host "  .agents/                   - Specialist definitions"
Write-Host "  .inputs/                   - User-provided files"
Write-Host "  .outputs/                  - Deliverables"
Write-Host "  .templates/                - Blueprints"
Write-Host "  .project-catalog/          - Full history + archive"
Write-Host "  .checkpoints/              - Saved snapshots"
Write-Host "  .rules/                    - Quality standards"
Write-Host "  .memory/                   - Working/canonical/disposable"
Write-Host ""
Write-Host "Usage:"
Write-Host "  Tell your AI: `"Read START_HERE.md and begin`""
Write-Host "  To resume:    `"Resume this project`""
Write-Host "  For status:   `"Give me an oversight report`""
Write-Host ""
