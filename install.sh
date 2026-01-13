#!/bin/bash

# UDO Project Installer v4.4.0
# Universal Dynamic Orchestrator - Modular Edition

set -e

REPO_URL="https://raw.githubusercontent.com/carderel/UDO-universal-orchestrator-v4/main"
CURRENT_VERSION="4.4.0"

echo "🔧 UDO - Universal Dynamic Orchestrator v$CURRENT_VERSION"
echo "==========================================="
echo ""

# Parse arguments
WITH_TAKEOVER=false
FORCE_UPDATE=false
UPDATE_MODE=false

for arg in "$@"; do
    case $arg in
        --with-takeover)
            WITH_TAKEOVER=true
            ;;
        --force-update)
            FORCE_UPDATE=true
            ;;
    esac
done

# Function to download a file
download_file() {
    local remote_path=$1
    local local_path=$2
    
    curl -fsSL "$REPO_URL/$remote_path" -o "$local_path" 2>/dev/null || {
        echo "  ⚠️  Failed to download: $remote_path"
        return 1
    }
    echo "  ✓ $local_path"
}

# Function to download if not exists (preserves user data)
download_if_missing() {
    local remote_path=$1
    local local_path=$2
    
    if [ ! -f "$local_path" ]; then
        download_file "$remote_path" "$local_path"
    else
        echo "  ○ $local_path (kept existing)"
    fi
}

# Check for updates if already installed
if [ -f ".udo-version" ]; then
    INSTALLED_VERSION=$(cat .udo-version)
    echo "📌 Installed version: $INSTALLED_VERSION"
    
    echo "🔍 Checking for updates..."
    LATEST_VERSION=$(curl -fsSL "$REPO_URL/VERSION" 2>/dev/null || echo "$INSTALLED_VERSION")
    
    if [ "$LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
        echo ""
        echo "🔄 Update Available: $INSTALLED_VERSION → $LATEST_VERSION"
        echo ""
        read -p "Update now? (y/N) " -n 1 -r < /dev/tty
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            FORCE_UPDATE=true
        else
            echo "Skipping update."
            if [ "$WITH_TAKEOVER" = false ]; then
                exit 0
            fi
        fi
    else
        echo "✅ You're on the latest version."
        # Check if takeover requested but missing
        if [ "$WITH_TAKEOVER" = true ] && [ ! -d ".takeover" ]; then
            echo "📥 Adding takeover module..."
        elif [ "$WITH_TAKEOVER" = false ]; then
            exit 0
        fi
    fi
fi

# Check for existing installation
if [ "$FORCE_UPDATE" = false ]; then
    if [ -f "ORCHESTRATOR.md" ] || [ -d ".agents" ]; then
        echo "⚠️  Existing UDO installation detected."
        echo ""
        echo "Options:"
        echo "  [u] Update - Refresh system files, keep your data"
        echo "  [f] Fresh install - Delete everything, start over"
        echo "  [c] Cancel"
        echo ""
        read -p "Choice (u/f/c): " -n 1 -r < /dev/tty
        echo ""
        
        case $REPLY in
            [Uu])
                echo "📝 Updating system files..."
                UPDATE_MODE=true
                ;;
            [Ff])
                echo "🗑️  Fresh install..."
                rm -rf ORCHESTRATOR.md PROJECT_STATE.json PROJECT_META.json CAPABILITIES.json \
                       HARD_STOPS.md LESSONS_LEARNED.md NON_GOALS.md OVERSIGHT_DASHBOARD.md \
                       START_HERE.md .agents .templates .project-catalog .inputs .outputs \
                       .checkpoints .rules .memory .takeover .udo-version 2>/dev/null || true
                UPDATE_MODE=false
                ;;
            *)
                echo "Cancelled."
                exit 0
                ;;
        esac
    fi
fi

echo ""
echo "📁 Creating directory structure..."

# Create all directories
mkdir -p .agents/_archive
mkdir -p .templates
mkdir -p .project-catalog/{agents,handoffs,decisions,sessions,errors,archive}
mkdir -p .inputs
mkdir -p .outputs/_drafts
mkdir -p .checkpoints
mkdir -p .rules
mkdir -p .memory/{working,canonical,disposable}

echo ""
echo "📥 Downloading core files..."

# Always update system files
download_file "modules/core/START_HERE.md" "START_HERE.md"
download_file "modules/core/ORCHESTRATOR.md" "ORCHESTRATOR.md"
download_file "modules/core/HARD_STOPS.md" "HARD_STOPS.md"
download_file "modules/core/NON_GOALS.md" "NON_GOALS.md"
download_file "modules/core/OVERSIGHT_DASHBOARD.md" "OVERSIGHT_DASHBOARD.md"
download_file "modules/core/HANDOFF_PROMPT.md" "HANDOFF_PROMPT.md"

# Preserve user data files
download_if_missing "modules/core/PROJECT_STATE.json" "PROJECT_STATE.json"
download_if_missing "modules/core/PROJECT_META.json" "PROJECT_META.json"
download_if_missing "modules/core/CAPABILITIES.json" "CAPABILITIES.json"
download_if_missing "modules/core/LESSONS_LEARNED.md" "LESSONS_LEARNED.md"

echo ""
echo "📥 Downloading templates..."

download_file "modules/templates/agent.md" ".templates/agent.md"
download_file "modules/templates/handoff.md" ".templates/handoff.md"
download_file "modules/templates/session.md" ".templates/session.md"
download_file "modules/templates/error.md" ".templates/error.md"
download_file "modules/templates/canonical-fact.md" ".templates/canonical-fact.md"
download_file "modules/templates/archive-summary.md" ".templates/archive-summary.md"

echo ""
echo "📥 Downloading default rules..."

download_if_missing "modules/rules/code-standards.md" ".rules/code-standards.md"
download_if_missing "modules/rules/content-guidelines.md" ".rules/content-guidelines.md"
download_if_missing "modules/rules/data-validation.md" ".rules/data-validation.md"

# Create .gitkeep files
touch .agents/_archive/.gitkeep
touch .project-catalog/agents/.gitkeep
touch .project-catalog/handoffs/.gitkeep
touch .project-catalog/decisions/.gitkeep
touch .project-catalog/sessions/.gitkeep
touch .project-catalog/errors/.gitkeep
touch .project-catalog/archive/.gitkeep
touch .inputs/.gitkeep
touch .outputs/_drafts/.gitkeep
touch .checkpoints/.gitkeep
touch .memory/working/.gitkeep
touch .memory/canonical/.gitkeep
touch .memory/disposable/.gitkeep

# Download memory README
download_file "modules/core/memory-README.md" ".memory/README.md"
download_file "modules/core/catalog-README.md" ".project-catalog/README.md"
download_file "modules/core/inputs-manifest.json" ".inputs/manifest.json"

# Takeover module (optional)
if [ "$WITH_TAKEOVER" = true ]; then
    echo ""
    echo "📥 Downloading takeover module..."
    
    mkdir -p .takeover/{audits,evidence,agent-templates}
    
    download_file "modules/takeover/TAKEOVER_ORCHESTRATOR.md" ".takeover/TAKEOVER_ORCHESTRATOR.md"
    download_file "modules/takeover/discovery.json" ".takeover/discovery.json"
    download_file "modules/takeover/scope-config.json" ".takeover/scope-config.json"
    download_file "modules/takeover/agent-templates/structure-auditor.md" ".takeover/agent-templates/structure-auditor.md"
    download_file "modules/takeover/agent-templates/documentation-auditor.md" ".takeover/agent-templates/documentation-auditor.md"
    download_file "modules/takeover/agent-templates/code-quality-auditor.md" ".takeover/agent-templates/code-quality-auditor.md"
    download_file "modules/takeover/agent-templates/security-auditor.md" ".takeover/agent-templates/security-auditor.md"
    download_file "modules/takeover/agent-templates/test-auditor.md" ".takeover/agent-templates/test-auditor.md"
fi

# Save version
echo "$CURRENT_VERSION" > .udo-version

echo ""
echo "✅ UDO v$CURRENT_VERSION installed successfully!"
echo ""
echo "Core Files:"
echo "  START_HERE.md              - Quick onboarding for any AI"
echo "  ORCHESTRATOR.md            - Operating instructions"
echo "  HARD_STOPS.md              - Absolute rules (Layer 0)"
echo "  PROJECT_STATE.json         - Current status"
echo "  LESSONS_LEARNED.md         - Situational lessons (Layer 3)"
echo ""
echo "Rule Hierarchy:"
echo "  Layer 0: HARD_STOPS.md     - NEVER violate"
echo "  Layer 1: .rules/*.md       - Detailed standards"
echo "  Layer 2: .agents/*.md      - Agent-specific rules"
echo "  Layer 3: LESSONS_LEARNED.md - Recent/situational"
echo ""
echo "Usage:"
echo "  Tell your AI: \"Read START_HERE.md and begin\""
echo "  To resume:    \"Resume this project\""
echo "  For status:   \"Give me an oversight report\""

if [ "$WITH_TAKEOVER" = true ]; then
    echo ""
    echo "Takeover Mode:"
    echo "  Tell your AI: \"Read .takeover/TAKEOVER_ORCHESTRATOR.md and start takeover\""
fi

echo ""
