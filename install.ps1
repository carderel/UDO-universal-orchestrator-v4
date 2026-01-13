# UDO Project Installer v4.4.0
# Universal Dynamic Orchestrator - Modular Edition
# PowerShell version for Windows

param(
    [switch]$NoTakeover,
    [switch]$ForceUpdate
)

$ErrorActionPreference = "Stop"
$REPO_URL = "https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main"
$CURRENT_VERSION = "4.4.0"

# Takeover is included by default
$WithTakeover = -not $NoTakeover

Write-Host "🔧 UDO - Universal Dynamic Orchestrator v$CURRENT_VERSION" -ForegroundColor Cyan
Write-Host "==========================================="
Write-Host ""

# Function to download a file
function Download-File {
    param([string]$RemotePath, [string]$LocalPath)
    
    try {
        $content = (Invoke-WebRequest -Uri "$REPO_URL/$RemotePath" -UseBasicParsing).Content
        Set-Content -Path $LocalPath -Value $content -Encoding UTF8 -NoNewline
        Write-Host "  ✓ $LocalPath"
        return $true
    } catch {
        Write-Host "  ⚠️  Failed to download: $RemotePath" -ForegroundColor Yellow
        return $false
    }
}

# Function to download if not exists
function Download-IfMissing {
    param([string]$RemotePath, [string]$LocalPath)
    
    if (-not (Test-Path $LocalPath)) {
        Download-File $RemotePath $LocalPath
    } else {
        Write-Host "  ○ $LocalPath (kept existing)"
    }
}

$UPDATE_MODE = $false

# Check for updates if already installed
if (Test-Path ".udo-version") {
    $INSTALLED_VERSION = (Get-Content ".udo-version" -Raw).Trim()
    Write-Host "📌 Installed version: $INSTALLED_VERSION"
    
    Write-Host "🔍 Checking for updates..."
    try {
        $LATEST_VERSION = (Invoke-WebRequest -Uri "$REPO_URL/VERSION" -UseBasicParsing).Content.Trim()
        
        if ($LATEST_VERSION -ne $INSTALLED_VERSION) {
            Write-Host ""
            Write-Host "🔄 Update Available: $INSTALLED_VERSION → $LATEST_VERSION" -ForegroundColor Yellow
            Write-Host ""
            $response = Read-Host "Update now? (y/N)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                $ForceUpdate = $true
            } else {
                Write-Host "Skipping update."
                if (-not $WithTakeover) {
                    exit 0
                }
            }
        } else {
            Write-Host "✅ You're on the latest version." -ForegroundColor Green
            # Check if takeover requested but missing
            if ($WithTakeover -and -not (Test-Path ".takeover")) {
                Write-Host "📥 Adding takeover module..." -ForegroundColor Yellow
            } elseif (-not $WithTakeover) {
                exit 0
            }
        }
    } catch {
        Write-Host "Could not check for updates."
    }
}

# Check for existing installation
if (-not $ForceUpdate) {
    if ((Test-Path "ORCHESTRATOR.md") -or (Test-Path ".agents")) {
        Write-Host "⚠️  Existing UDO installation detected." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Options:"
        Write-Host "  [u] Update - Refresh system files, keep your data"
        Write-Host "  [f] Fresh install - Delete everything, start over"
        Write-Host "  [c] Cancel"
        Write-Host ""
        $choice = Read-Host "Choice (u/f/c)"
        
        switch ($choice.ToLower()) {
            'u' {
                Write-Host "📝 Updating system files..."
                $UPDATE_MODE = $true
            }
            'f' {
                Write-Host "🗑️  Fresh install..."
                $itemsToRemove = @(
                    "ORCHESTRATOR.md", "PROJECT_STATE.json", "PROJECT_META.json", 
                    "CAPABILITIES.json", "HARD_STOPS.md", "LESSONS_LEARNED.md",
                    "NON_GOALS.md", "OVERSIGHT_DASHBOARD.md", "START_HERE.md",
                    ".agents", ".templates", ".project-catalog", ".inputs", 
                    ".outputs", ".checkpoints", ".rules", ".memory", ".takeover",
                    ".udo-version"
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
    }
}

Write-Host ""
Write-Host "📁 Creating directory structure..."

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

Write-Host ""
Write-Host "📥 Downloading core files..."

# Always update system files
Download-File "modules/core/START_HERE.md" "START_HERE.md"
Download-File "modules/core/ORCHESTRATOR.md" "ORCHESTRATOR.md"
Download-File "modules/core/HARD_STOPS.md" "HARD_STOPS.md"
Download-File "modules/core/NON_GOALS.md" "NON_GOALS.md"
Download-File "modules/core/OVERSIGHT_DASHBOARD.md" "OVERSIGHT_DASHBOARD.md"
Download-File "modules/core/HANDOFF_PROMPT.md" "HANDOFF_PROMPT.md"
Download-File "modules/core/COMMANDS.md" "COMMANDS.md"

# Preserve user data files
Download-IfMissing "modules/core/PROJECT_STATE.json" "PROJECT_STATE.json"
Download-IfMissing "modules/core/PROJECT_META.json" "PROJECT_META.json"
Download-IfMissing "modules/core/CAPABILITIES.json" "CAPABILITIES.json"
Download-IfMissing "modules/core/LESSONS_LEARNED.md" "LESSONS_LEARNED.md"

Write-Host ""
Write-Host "📥 Downloading templates..."

Download-File "modules/templates/agent.md" ".templates\agent.md"
Download-File "modules/templates/handoff.md" ".templates\handoff.md"
Download-File "modules/templates/session.md" ".templates\session.md"
Download-File "modules/templates/error.md" ".templates\error.md"
Download-File "modules/templates/canonical-fact.md" ".templates\canonical-fact.md"
Download-File "modules/templates/archive-summary.md" ".templates\archive-summary.md"

Write-Host ""
Write-Host "📥 Downloading default rules..."

Download-IfMissing "modules/rules/code-standards.md" ".rules\code-standards.md"
Download-IfMissing "modules/rules/content-guidelines.md" ".rules\content-guidelines.md"
Download-IfMissing "modules/rules/data-validation.md" ".rules\data-validation.md"

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
    ".memory\working\.gitkeep",
    ".memory\canonical\.gitkeep",
    ".memory\disposable\.gitkeep"
)

foreach ($path in $gitkeepPaths) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType File -Path $path -Force | Out-Null
    }
}

# Download support files
Download-File "modules/core/memory-README.md" ".memory\README.md"
Download-File "modules/core/catalog-README.md" ".project-catalog\README.md"
Download-File "modules/core/sessions-README.md" ".project-catalog\sessions\README.md"
Download-File "modules/core/inputs-manifest.json" ".inputs\manifest.json"

# Takeover module (optional)
if ($WithTakeover) {
    Write-Host ""
    Write-Host "📥 Downloading takeover module..."
    
    New-Item -ItemType Directory -Path ".takeover\audits" -Force | Out-Null
    New-Item -ItemType Directory -Path ".takeover\evidence" -Force | Out-Null
    New-Item -ItemType Directory -Path ".takeover\agent-templates" -Force | Out-Null
    
    Download-File "modules/takeover/TAKEOVER_ORCHESTRATOR.md" ".takeover\TAKEOVER_ORCHESTRATOR.md"
    Download-File "modules/takeover/discovery.json" ".takeover\discovery.json"
    Download-File "modules/takeover/scope-config.json" ".takeover\scope-config.json"
    Download-File "modules/takeover/agent-templates/structure-auditor.md" ".takeover\agent-templates\structure-auditor.md"
    Download-File "modules/takeover/agent-templates/documentation-auditor.md" ".takeover\agent-templates\documentation-auditor.md"
    Download-File "modules/takeover/agent-templates/code-quality-auditor.md" ".takeover\agent-templates\code-quality-auditor.md"
    Download-File "modules/takeover/agent-templates/security-auditor.md" ".takeover\agent-templates\security-auditor.md"
    Download-File "modules/takeover/agent-templates/test-auditor.md" ".takeover\agent-templates\test-auditor.md"
}

# Save version
Set-Content -Path ".udo-version" -Value $CURRENT_VERSION -Encoding UTF8

Write-Host ""
Write-Host "✅ UDO v$CURRENT_VERSION installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Core Files:"
Write-Host "  START_HERE.md              - Quick onboarding for any AI"
Write-Host "  ORCHESTRATOR.md            - Operating instructions"
Write-Host "  HARD_STOPS.md              - Absolute rules (Layer 0)"
Write-Host "  PROJECT_STATE.json         - Current status"
Write-Host "  LESSONS_LEARNED.md         - Situational lessons (Layer 3)"
Write-Host ""
Write-Host "Rule Hierarchy:"
Write-Host "  Layer 0: HARD_STOPS.md     - NEVER violate"
Write-Host "  Layer 1: .rules/*.md       - Detailed standards"
Write-Host "  Layer 2: .agents/*.md      - Agent-specific rules"
Write-Host "  Layer 3: LESSONS_LEARNED.md - Recent/situational"
Write-Host ""
Write-Host "Usage:"
Write-Host "  Tell your AI: `"Read START_HERE.md and begin`""
Write-Host "  To resume:    `"Resume this project`""
Write-Host "  For status:   `"Give me an oversight report`""

if ($WithTakeover) {
    Write-Host ""
    Write-Host "Takeover Mode:"
    Write-Host "  Tell your AI: `"Read .takeover/TAKEOVER_ORCHESTRATOR.md and start takeover`""
}

Write-Host ""
