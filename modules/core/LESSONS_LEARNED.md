# Lessons Learned

This file captures recent/situational lessons. It's **Layer 3** of the rule hierarchy.

---

## Rule Hierarchy

| Layer | Location | Purpose | Max Items |
|-------|----------|---------|-----------|
| 0 | HARD_STOPS.md | Absolute rules (NEVER violate) | ~15 |
| 1 | .rules/*.md | Detailed standards | Unlimited |
| 2 | .agents/*.md (Learned Rules section) | Agent-specific rules | ~15/agent |
| 3 | LESSONS_LEARNED.md (this file) | Recent/situational | ~20 active |

---

## How This File Works

**For AIs**: 
1. Read this file at session start
2. When adding a lesson:
   - Agent-specific? → Add to that agent's `## Learned Rules` section
   - Stable standard? → Add to appropriate `.rules/` file
   - Situational/recent? → Add here
3. When lessons pile up, prompt user to review and graduate stable ones

**For Humans**: 
- When you correct the AI, say "add to lessons"
- AI will ask clarifying questions before adding
- Review periodically to graduate stable lessons upward

---

## Agent Lesson Index

| Agent | Rules Count | Last Updated |
|-------|-------------|--------------|
| <!-- AI updates this table --> | | |

---

## Active Lessons (Layer 3)

<!-- Add lessons below. Format:

### L001: [Short Title]
- **Priority**: [critical | high | normal | low]
- **Date**: YYYY-MM-DD
- **Scope**: [cross-cutting | project-specific | temporary]
- **Context**: When does this apply?
- **Rule**: What to do
- **Anti-pattern**: What NOT to do
- **Expires**: [date | never | review-quarterly]

Priority Guide:
- critical: Check EVERY time before relevant actions (almost hard-stop level)
- high: Important, check at start of related tasks
- normal: Apply when relevant (default)
- low: Nice to have, can be skipped if context-constrained

-->

---

## Lesson Lifecycle

```
New correction
     ↓
Added here (Layer 3) with clarifying questions
     ↓
Applied 5+ times successfully?
     ↓
YES → Graduate to Layer 2 (agent) or Layer 1 (.rules/)
     ↓
Remove from this file (now permanent)
```

---

## Archived Lessons

| ID | Title | Graduated To | Date |
|----|-------|--------------|------|
| <!-- AI tracks graduated lessons here --> | | | |
