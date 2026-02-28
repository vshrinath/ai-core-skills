# AI Agent Skills - Golden Set

A portable library of role-based AI agent skills for software development and content projects. Compatible with Claude, Cursor, Copilot, Windsurf, and other AI assistants.

## What This Is

This is a curated collection of **highly transferable** AI agent skills (85%+ portability across projects). These skills teach AI assistants how to perform specific roles through structured prompts and methodologies.

## Skills Included

### Product & Planning (100% Transferable)
- `@pm` - Product management, feature scoping, requirements
- `@task-decomposition` - Breaking features into small, testable tasks
- `@decision-framework` - Structured decision analysis for high-stakes choices

### Meta Skills (100% Transferable)
- `@confidence-scoring` - When to ask for help, uncertainty assessment
- `@context-strategy` - Managing limited context windows efficiently
- `@error-recovery` - Handling failures autonomously

### Coding (95% Transferable)
- `@guard` - Security review, code review, convention checking
- `@qa` - Testing methodology, edge cases, regression verification
- `@self-review` - Pre-handoff quality checks
- `@debugging` - Systematic debugging methodology
- `@refactoring` - Code smells, safe structural cleanup
- `@api-design` - REST API design principles

### Marketing (90%+ Transferable)
- `@video-ai` - AI video generation with cinematography knowledge
- `@writer` - Content writing for articles, newsletters, social posts
- `@seo` - SEO optimization and technical SEO
- `@perf` - Performance marketing, ad copy, landing pages

### Design (90% Transferable)
- `@ux` - UX/UI design, user flows, accessibility

### Operations (85%+ Transferable)
- `deployment-practices` - Universal deployment principles
- `cicd-pipelines` - GitHub Actions CI/CD patterns

## How to Use

### Quick Setup (Recommended)

```bash
# In your project root
curl -sSL https://raw.githubusercontent.com/vshrinath/ai-agent-skills-golden/master/setup.sh | bash

# Or download and run manually
wget https://raw.githubusercontent.com/vshrinath/ai-agent-skills-golden/master/setup.sh
chmod +x setup.sh
./setup.sh
```

This will:
- Add skills as a git submodule
- Copy `AGENTS.md` and `CONVENTIONS.md` to your project root
- Configure all supported AI tools (Cursor, Claude, Windsurf, Copilot, Gemini, etc.)
- Create project-specific skills directory

### Manual Setup

#### As Git Submodule (Recommended)

```bash
# In your project root
git submodule add https://github.com/vshrinath/ai-agent-skills-golden.git skills

# Initialize and update
git submodule update --init --recursive

# Copy configuration files
cp skills/AGENTS.md .
cp skills/CONVENTIONS.md .

# Customize CONVENTIONS.md for your project
```

#### Direct Copy

```bash
# Copy entire library
git clone https://github.com/vshrinath/ai-agent-skills-golden.git
cp -r ai-agent-skills-golden/ your-project/skills/
rm -rf your-project/skills/.git

# Copy configuration files
cp skills/AGENTS.md .
cp skills/CONVENTIONS.md .
```

### Project Structure After Setup

```
your-project/
├── skills/              # ← Golden skills (submodule)
│   ├── product/
│   ├── coding/
│   ├── marketing/
│   ├── design/
│   ├── ops/
│   ├── meta/
│   ├── AGENTS.md
│   ├── CONVENTIONS.md
│   └── INDEX.md
├── .kiro/              # ← Project-specific overrides
│   └── skills/
│       ├── coding/
│       └── ops/
├── AGENTS.md           # ← Universal AI rules (copied from skills/)
├── CONVENTIONS.md      # ← Project patterns (customize this)
├── .cursor/            # ← Cursor configuration
├── .windsurf/          # ← Windsurf configuration
├── .github/            # ← GitHub Copilot configuration
└── src/
```

## Tool-Specific Usage

### Cursor
```typescript
// Skills loaded automatically via .cursor/rules.md
// Use @skill-name syntax in chat
@pm help me scope this feature
@dev implement user authentication
@guard review this code for security issues
```

### Claude Desktop
```bash
# Skills referenced via system prompt
Load skills: @pm, @dev, @guard, @qa

Task: Add user authentication to the dashboard
```

### Windsurf
```bash
# Use @skill-name syntax
@pm @dev @guard

I need to add user authentication. Help me scope it first, then implement securely.
```

### GitHub Copilot
```bash
# Reference configuration in chat
#file:.github/copilot-instructions.md
#file:skills/INDEX.md

Help me implement user authentication following our project patterns
```

### Gemini CLI
```bash
# Use context flags
gemini --context-file AGENTS.md \
       --context-file CONVENTIONS.md \
       --context-dir skills/ \
       "Help me implement user authentication"
```

### Antigravity
```bash
# Include skills in context
antigravity --include skills/ --include AGENTS.md --include CONVENTIONS.md
```

## Updating Skills Across All Projects

### For Submodule Users

```bash
# Update to latest skills
cd skills
git pull origin main
cd ..
git add skills
git commit -m "update: latest AI agent skills"
```

### For Direct Copy Users

```bash
# Re-copy updated skills
rm -rf skills/
cp -r /path/to/ai-agent-skills-golden/ skills/
```

## Customization

### Project-Specific Skills

Create project-specific skills in `.kiro/skills/` or similar:

```
your-project/
├── skills/              # ← Golden skills (don't modify)
└── .kiro/skills/        # ← Project overrides
    ├── coding/
    │   └── dev.md       # ← Framework-specific version
    └── ops/
        └── deploy.md    # ← Stack-specific deployment
```

### Skill Loading Order

1. Load golden skills first (general methodology)
2. Load project-specific overrides (framework/stack specifics)
3. Project overrides take precedence

## Contributing

### Adding New Skills

Skills must meet these criteria:
- **85%+ transferable** across different projects/stacks
- **Framework-agnostic** principles (examples can be framework-specific if clearly labeled)
- **Well-documented** with clear use cases and examples
- **Tested** across multiple project types

### Skill Structure

```markdown
# @skill-name — Role Title

**Philosophy:** One-line philosophy

## When to invoke
- Specific trigger conditions
- Use cases

## Responsibilities
- What this skill does
- What it doesn't do

## [Skill-specific sections]

## Handoffs
- **To `@other-skill`** → When to transition
- **From `@other-skill`** → When to receive

## Output
- What this skill produces

## Must ask before
- Actions requiring human approval
```

### Framework-Specific Examples

When including framework examples, use this pattern:

```markdown
## Universal Principles

[Framework-agnostic content]

## Framework-Specific Examples

### Django Example
```python
# Django-specific code
```

### Next.js Example
```typescript
// Next.js-specific code
```
```

## Compatibility

### AI Assistants
- ✅ Claude (Anthropic)
- ✅ Cursor
- ✅ GitHub Copilot
- ✅ Windsurf
- ✅ Any AI assistant that supports system prompts

### Project Types
- ✅ Web applications (any framework)
- ✅ Mobile applications
- ✅ Desktop applications
- ✅ APIs and microservices
- ✅ Content projects
- ✅ Marketing campaigns

### Tech Stacks
- ✅ Python (Django, Flask, FastAPI)
- ✅ JavaScript/TypeScript (React, Next.js, Node.js)
- ✅ PHP (Laravel, Symfony)
- ✅ Any modern web stack

## License

MIT License - Use freely in commercial and personal projects.

## Maintenance

This library is actively maintained. Skills are updated based on:
- Real-world usage feedback
- New AI assistant capabilities
- Emerging development patterns
- Community contributions

---

**Version:** 1.0.0  
**Last Updated:** 2026-02-27  
**Compatibility:** Universal AI assistants