#!/bin/bash

# AI Agent Skills Setup Script
# Sets up skills and configuration files for various AI tools

set -e

REPO_URL="https://github.com/vshrinath/ai-agent-skills-golden.git"
SKILLS_DIR="skills"
CONFIG_DIR=".ai-config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository. Please run this script from your project root."
        exit 1
    fi
}

# Setup skills as git submodule
setup_skills_submodule() {
    print_status "Setting up AI agent skills as git submodule..."
    
    if [ -d "$SKILLS_DIR" ]; then
        print_warning "Skills directory already exists. Skipping submodule setup."
        return
    fi
    
    git submodule add "$REPO_URL" "$SKILLS_DIR"
    git submodule update --init --recursive
    
    print_success "Skills submodule added successfully"
}

# Setup skills as direct clone (for non-git projects)
setup_skills_clone() {
    print_status "Cloning AI agent skills repository..."
    
    if [ -d "$SKILLS_DIR" ]; then
        print_warning "Skills directory already exists. Skipping clone."
        return
    fi
    
    git clone "$REPO_URL" "$SKILLS_DIR"
    rm -rf "$SKILLS_DIR/.git"  # Remove git history for direct copy
    
    print_success "Skills cloned successfully"
}

# Copy configuration files to project root
setup_config_files() {
    print_status "Setting up configuration files..."
    
    # Copy AGENTS.md if it doesn't exist
    if [ ! -f "AGENTS.md" ]; then
        cp "$SKILLS_DIR/AGENTS.md" "AGENTS.md"
        print_success "AGENTS.md copied to project root"
    else
        print_warning "AGENTS.md already exists. Skipping."
    fi
    
    # Copy CONVENTIONS.md template if it doesn't exist
    if [ ! -f "CONVENTIONS.md" ]; then
        cp "$SKILLS_DIR/CONVENTIONS.md" "CONVENTIONS.md"
        print_success "CONVENTIONS.md template copied to project root"
        print_warning "Please customize CONVENTIONS.md for your project"
    else
        print_warning "CONVENTIONS.md already exists. Skipping."
    fi
}

# Setup Cursor configuration
setup_cursor() {
    print_status "Setting up Cursor configuration..."
    
    mkdir -p .cursor
    
    cat > .cursor/rules.md << 'EOF'
# Cursor Rules

## Skills System
Load AI agent skills from the `skills/` directory. Use skills by referencing them with `@skill-name`.

Available skills: @pm, @task-decomposition, @decision-framework, @guard, @qa, @self-review, @debugging, @refactoring, @api-design, @video-ai, @writer, @seo, @perf, @ux, @confidence-scoring, @context-strategy, @error-recovery

## Configuration Files
- Follow rules in `AGENTS.md`
- Follow project conventions in `CONVENTIONS.md`
- Load skills from `skills/` directory

## Workflow
1. Read AGENTS.md for universal rules
2. Read CONVENTIONS.md for project-specific patterns
3. Load relevant skills for the task
4. Follow the skill workflows and handoff patterns
EOF
    
    print_success "Cursor rules configured"
}

# Setup Claude Desktop configuration
setup_claude() {
    print_status "Setting up Claude Desktop configuration..."
    
    CLAUDE_CONFIG_DIR="$HOME/.claude"
    mkdir -p "$CLAUDE_CONFIG_DIR"
    
    # Create or update Claude configuration
    cat > "$CLAUDE_CONFIG_DIR/settings.local.json" << EOF
{
  "skills_directory": "$(pwd)/$SKILLS_DIR",
  "agents_file": "$(pwd)/AGENTS.md",
  "conventions_file": "$(pwd)/CONVENTIONS.md"
}
EOF
    
    print_success "Claude Desktop configuration updated"
}

# Setup Windsurf configuration
setup_windsurf() {
    print_status "Setting up Windsurf configuration..."
    
    mkdir -p .windsurf
    
    cat > .windsurf/rules.md << 'EOF'
# Windsurf Rules

## AI Agent Skills
Skills are located in `skills/` directory. Reference skills using `@skill-name` syntax.

Core skills: @pm, @dev, @guard, @qa, @arch, @ux, @ops

## Configuration
- Universal rules: `AGENTS.md`
- Project conventions: `CONVENTIONS.md`
- Skills directory: `skills/`

## Usage
Load skills as needed for each task. Follow handoff patterns defined in skills.
EOF
    
    print_success "Windsurf rules configured"
}

# Setup GitHub Copilot configuration
setup_copilot() {
    print_status "Setting up GitHub Copilot configuration..."
    
    mkdir -p .github
    
    cat > .github/copilot-instructions.md << 'EOF'
# GitHub Copilot Instructions

## Skills System
This project uses AI agent skills located in `skills/` directory.

## Configuration Files
- `AGENTS.md` - Universal rules for AI assistants
- `CONVENTIONS.md` - Project-specific patterns and conventions
- `skills/INDEX.md` - Available skills and usage patterns

## Usage
1. Read AGENTS.md for universal development rules
2. Read CONVENTIONS.md for project-specific patterns
3. Reference skills from skills/ directory as needed
4. Follow skill workflows and handoff patterns

## Available Skills
Product: @pm, @task-decomposition, @decision-framework
Coding: @guard, @qa, @self-review, @debugging, @refactoring, @api-design
Marketing: @video-ai, @writer, @seo, @perf
Design: @ux
Meta: @confidence-scoring, @context-strategy, @error-recovery
EOF
    
    print_success "GitHub Copilot instructions configured"
}

# Setup Gemini CLI configuration
setup_gemini() {
    print_status "Setting up Gemini CLI configuration..."
    
    mkdir -p "$CONFIG_DIR"
    
    cat > "$CONFIG_DIR/gemini-config.md" << 'EOF'
# Gemini CLI Configuration

## Project Setup
- Skills directory: skills/
- Rules file: AGENTS.md
- Conventions file: CONVENTIONS.md

## Usage
When using Gemini CLI, reference these files:
```bash
gemini --context-file AGENTS.md --context-file CONVENTIONS.md --context-dir skills/
```

## Available Skills
Load skills by referencing the markdown files in skills/ directory.
EOF
    
    print_success "Gemini CLI configuration created"
}

# Setup Antigravity configuration (if it exists)
setup_antigravity() {
    print_status "Setting up Antigravity configuration..."
    
    mkdir -p "$CONFIG_DIR"
    
    cat > "$CONFIG_DIR/antigravity-config.md" << 'EOF'
# Antigravity Configuration

## Skills Integration
- Skills location: skills/
- Configuration: AGENTS.md, CONVENTIONS.md
- Usage: Reference skills by @skill-name

## Setup
Include skills directory and configuration files in Antigravity context.
EOF
    
    print_success "Antigravity configuration created"
}

# Create project-specific skills directory
setup_project_skills() {
    print_status "Setting up project-specific skills directory..."
    
    mkdir -p .kiro/skills/{coding,ops,marketing}
    
    cat > .kiro/skills/README.md << 'EOF'
# Project-Specific Skills

This directory contains skills customized for this specific project.

## Structure
- `coding/` - Framework-specific development skills
- `ops/` - Deployment and infrastructure skills specific to this project
- `marketing/` - Project-specific marketing and content skills

## Usage
These skills override or extend the golden skills in `skills/` directory.

## Precedence
1. Project skills (this directory) - highest priority
2. Golden skills (`skills/` directory) - fallback
3. Global skills (`~/.ai-skills/`) - lowest priority
EOF
    
    print_success "Project-specific skills directory created"
}

# Main setup function
main() {
    echo "🤖 AI Agent Skills Setup"
    echo "======================="
    echo
    
    # Parse command line arguments
    SETUP_TYPE="submodule"
    TOOLS="all"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --clone)
                SETUP_TYPE="clone"
                shift
                ;;
            --submodule)
                SETUP_TYPE="submodule"
                shift
                ;;
            --tools)
                TOOLS="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo
                echo "Options:"
                echo "  --submodule    Setup skills as git submodule (default)"
                echo "  --clone        Setup skills as direct clone"
                echo "  --tools TOOLS  Comma-separated list of tools to configure"
                echo "                 Options: cursor,claude,windsurf,copilot,gemini,antigravity,all"
                echo "  --help         Show this help message"
                echo
                echo "Examples:"
                echo "  $0                                    # Setup with defaults"
                echo "  $0 --clone --tools cursor,claude     # Clone skills, setup Cursor and Claude only"
                echo "  $0 --submodule --tools all           # Submodule skills, setup all tools"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Setup skills
    if [ "$SETUP_TYPE" = "submodule" ]; then
        check_git_repo
        setup_skills_submodule
    else
        setup_skills_clone
    fi
    
    # Setup configuration files
    setup_config_files
    setup_project_skills
    
    # Setup tools
    if [ "$TOOLS" = "all" ]; then
        setup_cursor
        setup_claude
        setup_windsurf
        setup_copilot
        setup_gemini
        setup_antigravity
    else
        IFS=',' read -ra TOOL_ARRAY <<< "$TOOLS"
        for tool in "${TOOL_ARRAY[@]}"; do
            case $tool in
                cursor)
                    setup_cursor
                    ;;
                claude)
                    setup_claude
                    ;;
                windsurf)
                    setup_windsurf
                    ;;
                copilot)
                    setup_copilot
                    ;;
                gemini)
                    setup_gemini
                    ;;
                antigravity)
                    setup_antigravity
                    ;;
                *)
                    print_warning "Unknown tool: $tool"
                    ;;
            esac
        done
    fi
    
    echo
    print_success "Setup complete!"
    echo
    echo "📋 Next steps:"
    echo "1. Customize CONVENTIONS.md for your project"
    echo "2. Add project-specific skills to .kiro/skills/ if needed"
    echo "3. Commit the changes to your repository"
    echo
    echo "🔧 Tool-specific usage:"
    echo "- Cursor: Skills loaded automatically via .cursor/rules.md"
    echo "- Claude: Reference skills with @skill-name"
    echo "- Windsurf: Use @skill-name syntax"
    echo "- Copilot: Reference .github/copilot-instructions.md"
    echo "- Gemini: Use --context-file and --context-dir flags"
    echo
    echo "📚 Available skills:"
    echo "Product: @pm, @task-decomposition, @decision-framework"
    echo "Coding: @guard, @qa, @self-review, @debugging, @refactoring, @api-design"
    echo "Marketing: @video-ai, @writer, @seo, @perf"
    echo "Design: @ux"
    echo "Meta: @confidence-scoring, @context-strategy, @error-recovery"
}

# Run main function
main "$@"