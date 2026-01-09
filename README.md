# UDO - Universal Dynamic Orchestrator v4

**The AI project management system that works with any LLM.**

Switch between Claude, GPT, Gemini, or any other AI mid-project without losing context. Built with circuit breakers, memory discipline, and human oversight for real-world reliability.

## Quick Install

**Mac/Linux/WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.ps1 | iex
```

## What Makes UDO Different

| Problem | UDO Solution |
|---------|--------------|
| AI forgets context between sessions | Full documentation trail + organized memory |
| Can't switch LLMs mid-project | Everything in files any AI can read |
| AI repeats the same mistakes | `LESSONS_LEARNED.md` + auto-updating templates |
| AI produces "confident nonsense" | Circuit breakers + confidence thresholds |
| No visibility into what's happening | `OVERSIGHT_DASHBOARD.md` + health reports |
| Scope creep | `NON_GOALS.md` + explicit boundaries |
| Token bloat on long projects | Context Janitor auto-archives completed work |
| Different LLMs have different capabilities | `CAPABILITIES.json` environment awareness |
| Conflicts between agents | Arbiter Protocol with deterministic resolution |
| Mixing facts with speculation | Memory discipline (working/canonical/disposable) |

## Project Structure

```
your-project/
├── START_HERE.md                # 🚀 Quick onboarding (AI reads first)
├── ORCHESTRATOR.md              # 🧠 Operating instructions
├── PROJECT_STATE.json           # 📊 Current status and todos
├── PROJECT_META.json            # 📋 Project context
├── CAPABILITIES.json            # 🔧 Environment capabilities
├── LESSONS_LEARNED.md           # 🎓 Mistakes to avoid
├── NON_GOALS.md                 # 🚫 Scope boundaries
├── OVERSIGHT_DASHBOARD.md       # 🎛️ Human monitoring
│
├── .agents/                     # 🤖 Specialist definitions
├── .inputs/                     # 📥 User-provided files
├── .outputs/                    # 📤 Deliverables
├── .templates/                  # 📝 Blueprints
├── .project-catalog/            # 📚 Full history + archive
├── .checkpoints/                # 💾 Saved snapshots
├── .rules/                      # ✅ Quality standards
└── .memory/                     # 🧠 Working/canonical/disposable
```

## Usage

### Start a New Project
```
Read START_HERE.md and begin.
```

### Resume an Existing Project
```
Resume this project.
```

### Get a Health Check
```
Give me an oversight report.
```

### Switch LLMs Mid-Project
Tell the new AI:
```
Read START_HERE.md and continue where the last AI left off.
```

## Key Features

### 🛑 Circuit Breakers
Automatic protection against runaway failures:
- Halts after 3 consecutive task failures
- Flags outputs with low confidence (< 40%)
- Pauses when error rate exceeds 30%
- Detects circular handoffs
- Triggers archival at 80% context usage

### ⚖️ Arbiter Protocol
Deterministic conflict resolution:
1. Canonical memory wins
2. Validation rules as tiebreaker
3. More recent validated data wins
4. Higher confidence wins
5. Human decides if still unresolved

### 🧠 Memory Discipline
Three-tier memory system:
- **Working**: Session scratch (cleared each session)
- **Canonical**: Verified facts (permanent)
- **Disposable**: Speculation (cleared on resolution)

### 🎛️ Human Oversight
Built for human supervision:
- Quick health reports
- Warning signs guide
- Intervention commands
- Cognitive load reducers
- Full audit trail

### 📦 Context Janitor
Prevents token bloat:
- Auto-archives completed phases
- 3-sentence summaries
- Full details preserved in archive
- Triggers at 60% context usage

### 🔧 Environment Awareness
Adapts to your LLM:
- `CAPABILITIES.json` defines available tools
- Agents check before executing
- Graceful handling of missing capabilities

### 📈 Self-Optimizing
Active learning system:
- Lessons learned update agent templates
- Templates improve over time
- Learning persists across LLMs

## Commands Reference

| Command | What It Does |
|---------|--------------|
| `Resume this project` | Load state and continue |
| `Give me an oversight report` | Quick health check |
| `Checkpoint this` | Manually save current state |
| `List checkpoints` | Show all available checkpoints |
| `Rollback to checkpoint [timestamp]` | Restore previous state |
| `Disable auto-checkpoints` | Turn off automatic saves |
| `Set auto-checkpoint interval to [N] todos` | Change save frequency |
| `Pause all work` | Stop and await instructions |
| `Override: [instruction]` | Human directive supersedes AI |
| `Circuit breaker reset` | Clear triggered breakers |

## Compatible With

- ✅ Claude (Web, API, VS Code, Cursor)
- ✅ ChatGPT / GPT-4 / GPT-4o
- ✅ Gemini
- ✅ GitHub Copilot
- ✅ Local LLMs (Ollama, LM Studio)
- ✅ Any LLM that can read markdown files

## Auto-Updates

Run the install command again to check for updates:
```bash
curl -fsSL https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main/install.sh | bash
```

Updates preserve your project data and prompt before making changes.

## Philosophy

UDO is built on these principles:

1. **Coordinate, don't execute** - The orchestrator delegates to specialists
2. **Document everything** - Full audit trail for debugging and handoffs
3. **Fail safely** - Circuit breakers prevent cascading failures
4. **Learn continuously** - Mistakes improve the system
5. **Respect boundaries** - Clear non-goals prevent scope creep
6. **Support humans** - Oversight is easy, not burdensome

## License

MIT
