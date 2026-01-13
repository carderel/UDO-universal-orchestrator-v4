# UDO - Universal Dynamic Orchestrator v4

**The AI project management system that works with any LLM.**

Switch between Claude, GPT, Gemini, or any AI mid-project without losing context.

---

## Installation

Navigate to your project folder first, then run one of the following:

### Mac / Linux / WSL (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash
```

### Mac / Linux (Zsh)

```zsh
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | zsh
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.ps1 | iex
```

### Windows Command Prompt (cmd)

```cmd
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh -o install.sh && bash install.sh
```

Or if you have PowerShell available:

```cmd
powershell -Command "irm https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.ps1 | iex"
```

### Git Bash (Windows)

```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash
```

### Without Takeover Module

If you don't need project takeover capabilities:

```bash
# Mac/Linux/WSL
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash -s -- --no-takeover

# Windows PowerShell
powershell -File install.ps1 -NoTakeover
```

---

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
├── COMMANDS.md                  # Command reference
├── HANDOFF_PROMPT.md            # Session handoff prompts
├── HARD_STOPS.md                # Absolute rules (Layer 0)
├── PROJECT_STATE.json           # Current status
├── LESSONS_LEARNED.md           # Situational lessons (Layer 3)
│
├── .agents/                     # Specialists (Layer 2)
├── .rules/                      # Standards (Layer 1)
├── .takeover/                   # Takeover module
├── .inputs/                     # User files
├── .outputs/                    # Deliverables
├── .project-catalog/            # Full history + session logs
├── .checkpoints/                # Snapshots
└── .memory/                     # Working/canonical/disposable
```

## Usage

### Start New Project
```
"Read START_HERE.md and begin"
```

### Resume Project
```
"Resume"          # Quick resume
"Deep resume"     # Full context with recent sessions
```

### End Session
```
"Handoff"         # Full context handoff
"Quick handoff"   # Minimal handoff
```

### Check Status
```
"What's the status?"
```

### Takeover Existing Project
```
"Read .takeover/TAKEOVER_ORCHESTRATOR.md and start takeover"
```

### All Commands
See `COMMANDS.md` for the complete command reference.

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
