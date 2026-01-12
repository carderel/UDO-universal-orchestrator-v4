# 🎛️ Oversight Dashboard

Quick human oversight for project health and intervention.

---

## Quick Status Check

Ask: `Give me an oversight report`

Response format:
```
📊 OVERSIGHT REPORT
==================
Project: [name]
Health: 🟢 Good | 🟡 Attention | 🔴 Blocked

Progress: [X/Y] todos complete
Active Agents: [count]
Pending Handoffs: [count]
Unresolved Errors: [count]
Circuit Breaker: [OK | TRIGGERED]

Last Checkpoint: [timestamp]
Context Usage: [low/medium/high]

⚠️ Needing Attention:
- [blockers, errors, anomalies]

✅ Recent Completions:
- [last 3 items]
```

---

## Intervention Commands

| Command | What It Does |
|---------|--------------|
| `Pause all work` | Stops orchestration |
| `Show me the blockers` | Lists all blockers |
| `Explain decision [X]` | Details rationale |
| `Checkpoint this` | Manual checkpoint now |
| `List checkpoints` | Show all checkpoints |
| `Rollback to checkpoint [name]` | Restore state |
| `Kill agent [name]` | Stop misbehaving agent |
| `Override: [instruction]` | Human directive |
| `Circuit breaker reset` | Clear triggered breakers |

---

## Warning Signs

### 🟡 Yellow Flags
- Same task retried more than twice
- Agent outputs need frequent correction
- Context usage above 60%
- Handoffs pending for more than one session

### 🔴 Red Flags
- Circuit breaker triggered
- Agent confidence below threshold
- Conflicting outputs from agents
- Circular handoffs (A→B→A)
- Error rate above 30%

---

## Quick Checks

| Need | Where to Look |
|------|---------------|
| What happened last? | `.project-catalog/sessions/` |
| What went wrong? | `.project-catalog/errors/` |
| Key decisions | `.project-catalog/decisions/` |
| Current todos | `PROJECT_STATE.json` |

---

## Escalation Path

```
Agent stuck → Blocker logged
     ↓
Orchestrator can't resolve → Human escalation
     ↓
Human provides Override
     ↓
Decision logged in .project-catalog/decisions/
     ↓
Lesson added if applicable
```
