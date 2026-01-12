# UDO - Universal Dynamic Orchestrator v4

**The AI project management system that works with any LLM.**

Switch between Claude, GPT, Gemini, or any AI mid-project without losing context.

## Quick Install

**Mac/Linux/WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.ps1 | iex
```

**With Takeover Module** (for inheriting existing projects):
```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash -s -- --with-takeover
```

## Rule Hierarchy

| Layer | Location | Purpose | Override? |
|-------|----------|---------|-----------|
| 0 | `HARD_STOPS.md` | Absolute rules | Never by AI |
| 1 | `.rules/*.md` | Detailed standards | With justification |
| 2 | `.agents/*.md` | Agent-specific rules | By orchestrator |
| 3 | `LESSONS_LEARNED.md` | Situational lessons | Easily |

## Project Structure

```
your-project/
├── START_HERE.md                # Quick onboarding
├── ORCHESTRATOR.md              # Operating instructions
├── HARD_STOPS.md                # Absolute rules (Layer 0)
├── PROJECT_STATE.json           # Current status
├── LESSONS_LEARNED.md           # Situational lessons (Layer 3)
│
├── .agents/                     # Specialists (Layer 2)
├── .rules/                      # Standards (Layer 1)
├── .inputs/                     # User files
├── .outputs/                    # Deliverables
├── .project-catalog/            # Full history
├── .checkpoints/                # Snapshots
└── .memory/                     # Working/canonical/disposable
```

## Usage

### Start New Project
```
Tell your AI: "Read START_HERE.md and begin"
```

### Resume Project
```
"Resume this project"
```

### Check Status
```
"Give me an oversight report"
```

### Takeover Existing Project
```
"Read .takeover/TAKEOVER_ORCHESTRATOR.md and start takeover"
```

## Repository Structure

```
UDO-universal-orchestrator-v4/
├── install.sh              # Thin loader (downloads modules)
├── install.ps1             # PowerShell loader
├── VERSION
├── CHANGELOG
├── README.md
│
└── modules/
    ├── core/               # System files
    ├── templates/          # Blueprints
    ├── rules/              # Default standards
    └── takeover/           # Takeover module
```

## Contributing

Edit individual files in `modules/`. The install scripts download them at runtime.

## License

MIT
