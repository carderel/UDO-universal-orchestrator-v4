# UDO Commands Reference

Quick reference for all UDO commands.

---

## Session Start

| Command | What It Does |
|---------|--------------|
| `Resume` | Quick resume - read essentials, give oversight report |
| `Resume this project` | Same as above |
| `Deep resume` | Full context - essentials + last 3 session logs |
| `Re-sync` | Re-read all system files (after updates) |

---

## Session End

| Command | What It Does |
|---------|--------------|
| `Handoff` | Full handoff - comprehensive context document |
| `End session` | Same as handoff |
| `Quick handoff` | Minimal handoff - summary, next steps, files changed |

---

## Status & Oversight

| Command | What It Does |
|---------|--------------|
| `What's the status?` | Oversight report |
| `Give me an oversight report` | Detailed health check |
| `Show me the blockers` | List all blockers |

---

## Checkpoints

| Command | What It Does |
|---------|--------------|
| `Checkpoint this` | Create manual checkpoint now |
| `List checkpoints` | Show all available checkpoints |
| `Rollback to checkpoint [name]` | Restore to previous state |

---

## Learning & Corrections

| Command | What It Does |
|---------|--------------|
| `Add to lessons` | Capture correction as lesson |
| `Remember this: [instruction]` | Add to appropriate layer |
| `Review lessons` | Audit and graduate lessons |

---

## Takeover (for existing projects)

| Command | What It Does |
|---------|--------------|
| `Start takeover` | Begin discovery phase |
| `Verified` | Confirm understanding, proceed to audit |
| `Start audit` | Deploy auditor agents |
| `Generate report` | Compile findings |
| `Choose option [A/B/C/D]` | Select remediation path |
| `Abort takeover` | Cancel takeover process |

---

## Intervention

| Command | What It Does |
|---------|--------------|
| `Pause all work` | Stop orchestration |
| `Explain decision [X]` | Get rationale for a decision |
| `Kill agent [name]` | Stop misbehaving agent |
| `Override: [instruction]` | Human directive override |
| `Circuit breaker reset` | Clear triggered breakers |

---

## File Locations

| Need | Location |
|------|----------|
| Commands reference | `COMMANDS.md` (this file) |
| Main instructions | `ORCHESTRATOR.md` |
| Quick start | `START_HERE.md` |
| Handoff prompts | `HANDOFF_PROMPT.md` |
| Absolute rules | `HARD_STOPS.md` |
| Current status | `PROJECT_STATE.json` |
| Session logs | `.project-catalog/sessions/` |
| Lessons | `LESSONS_LEARNED.md` + `.agents/*.md` |
