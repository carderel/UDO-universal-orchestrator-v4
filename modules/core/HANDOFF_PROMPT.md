# 🔄 Session Handoff Protocol

**Copy and paste this to the AI before ending your session.**

---

## Full Handoff Prompt

```
You are preparing a context handoff between two AI agents.

Generate a single, self-contained Markdown document that fully reconstructs the active working context of this project so a new agent with an empty memory can continue without loss of continuity.

The document must be written as if it is the only thing the new agent will see.

**Start with Tags:**
Add a Tags line at the top with 3-5 hashtags for the main topics covered:
Tags: #topic1 #topic2 #topic3

**Include:**

0. **Tags** (at very top of file)
   - 3-5 hashtags for main topics (e.g., #api #authentication #refactoring)

1. **Executive Summary**
   - What is this project?
   - What phase are we in?
   - What just happened this session?

2. **User Context**
   - User's goals and motivations
   - Key constraints and preferences
   - Working style observations

3. **Active Work**
   - Current todos (from PROJECT_STATE.json)
   - What's in progress
   - What's blocked and why

4. **Decisions Made**
   - Key decisions from this session
   - Rationale for each
   - Any decisions deferred

5. **Technical Context**
   - Systems, tools, architectures in play
   - Files created or modified this session
   - Dependencies or integrations

6. **Rules of Engagement**
   - How the user wants AI to behave
   - Communication preferences
   - Things to avoid

7. **Known Risks & Failure Modes**
   - What could go wrong
   - What has gone wrong
   - Mitigations in place

8. **Open Threads & Next Actions**
   - Unresolved questions
   - Next session priorities
   - Anything time-sensitive

**Precision Rules:**
- Use concrete language, not vague summaries
- Preserve terminology exactly as used
- Do not invent facts or fill gaps
- If uncertain, label as "INFERRED" or "UNCERTAIN"

**Output:**
Save to: .project-catalog/sessions/YYYY-MM-DD-HH-MM-handoff.md
Update: PROJECT_STATE.json with current status
Confirm: "Handoff document created at [path]. Ready for next agent."
```

---

## Quick Handoff (Minimum Viable)

If short on time:

```
End session. Create handoff at .project-catalog/sessions/ covering:
1. What we did
2. What's next
3. Any blockers
4. Files changed

Update PROJECT_STATE.json. Confirm when done.
```

---

## Micro Handoff (Emergency)

```
Quick handoff: summarize session, update PROJECT_STATE.json, log to sessions folder.
```

---

## Why This Matters

Without a handoff:
- Next AI starts from zero
- Work gets repeated
- Context is lost
- Decisions get revisited

With a handoff:
- Seamless continuation
- No repeated explanations
- Preserved momentum
- Accumulated intelligence

---

## IDE Snippet Setup

### VS Code / Cursor

Add to User Snippets (Cmd+Shift+P → "Snippets: Configure User Snippets" → markdown.json):

```json
{
  "UDO Full Handoff": {
    "prefix": "handoff",
    "body": [
      "You are preparing a context handoff between two AI agents.",
      "",
      "Generate a single, self-contained Markdown document that fully reconstructs the active working context of this project so a new agent with an empty memory can continue without loss of continuity.",
      "",
      "Save to: .project-catalog/sessions/YYYY-MM-DD-HH-MM-handoff.md",
      "Update: PROJECT_STATE.json",
      "Confirm when complete."
    ]
  },
  "UDO Quick Handoff": {
    "prefix": "qhandoff",
    "body": [
      "End session. Create handoff at .project-catalog/sessions/ covering:",
      "1. What we did",
      "2. What's next", 
      "3. Any blockers",
      "4. Files changed",
      "",
      "Update PROJECT_STATE.json. Confirm when done."
    ]
  }
}
```

### Text Expander / Alfred / Raycast

Create shortcuts:
- `;handoff` → Full handoff prompt
- `;qh` → Quick handoff prompt

---

## Handoff Checklist

Before closing your IDE:

- [ ] Ran handoff prompt
- [ ] AI confirmed session logged
- [ ] PROJECT_STATE.json updated
- [ ] Checked .project-catalog/sessions/ has new file

