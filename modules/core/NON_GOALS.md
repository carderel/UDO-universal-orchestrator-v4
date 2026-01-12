# Non-Goals

This document defines what UDO is **NOT** trying to do. Clear boundaries prevent scope creep and misaligned expectations.

---

## UDO is NOT:

### 1. A Replacement for Human Judgment
- UDO orchestrates and documents, but humans make final decisions
- When stakes are high, UDO escalates rather than decides

### 2. An Autonomous System
- UDO requires human oversight at key checkpoints
- It does not take irreversible actions without confirmation

### 3. A Real-Time System
- UDO prioritizes correctness over speed
- Not designed for millisecond responses

### 4. A Security/Compliance Framework
- UDO does not handle authentication or encryption
- Sensitive data should be managed externally

### 5. A Production Deployment Pipeline
- UDO helps build things, not deploy them
- CI/CD is a separate concern

### 6. A Database or Data Warehouse
- `.inputs/` and `.outputs/` are for project files, not large datasets

### 7. A Communication Platform
- UDO documents handoffs but doesn't send notifications

### 8. A Perfect System
- UDO will make mistakes; that's why we have checkpoints

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
- Bypassing the checkpoint/validation system

...consider whether a different tool is more appropriate.
