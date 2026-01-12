# Hard Stops

These rules are **ABSOLUTE**. No exceptions. No judgment calls. No "but in this context..."

If you encounter a situation where a hard stop conflicts with a user request:
1. **STOP** - Do not proceed
2. **EXPLAIN** - Tell the user which hard stop applies
3. **ESCALATE** - Only a human editing this file directly can change these rules

---

## Rule Hierarchy

```
Layer 0: HARD_STOPS.md     ← You are here (ABSOLUTE - never override)
Layer 1: .rules/*.md       ← Detailed standards (override with justification)
Layer 2: .agents/*.md      ← Agent-specific rules (override by orchestrator)
Layer 3: LESSONS_LEARNED.md ← Situational lessons (easily adjusted)
```

---

## Security

- **HS-SEC-001**: NEVER include API keys, passwords, tokens, or secrets in any output
- **HS-SEC-002**: NEVER expose database connection strings or internal URLs
- **HS-SEC-003**: NEVER bypass or disable authentication/authorization checks
- **HS-SEC-004**: NEVER log or store credentials, even temporarily

## Data Protection

- **HS-DATA-001**: NEVER store PII (personally identifiable information) in logs or outputs
- **HS-DATA-002**: NEVER transmit data to external services without explicit user approval
- **HS-DATA-003**: NEVER retain sensitive data in .memory/ beyond the current session

## Compliance

- **HS-COMP-001**: NEVER generate content claiming to be legal, medical, or financial advice
- **HS-COMP-002**: NEVER proceed with actions that would violate stated compliance requirements

## Client-Specific

<!-- Add client-specific hard stops below -->
<!-- Example: 
- **HS-CLIENT-001**: NEVER mention [Competitor Name] in any deliverable
- **HS-CLIENT-002**: NEVER use [Banned Term] - always use [Approved Term] instead
-->

---

## Adding Hard Stops

Before adding a hard stop, verify:
1. **Is it truly absolute?** - If it needs "except when..." it belongs in .rules/ instead
2. **Is it serious?** - Security, legal, compliance, or client-critical only
3. **Is it rare?** - Keep total hard stops under 15 to maintain clarity

To add: Edit this file directly. Hard stops cannot be added by AI.

---

## Hard Stop Violation Response

If AI detects it's about to violate a hard stop:

```
🛑 HARD STOP VIOLATION PREVENTED

Rule: [HS-XXX-000] [Rule description]
Request: [What was asked]
Conflict: [Why this violates the rule]

I cannot proceed with this request. This is an absolute rule that 
cannot be overridden. If you believe this rule should be changed, 
please edit HARD_STOPS.md directly.
```
