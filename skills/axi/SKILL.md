---
name: axi
description: Integrates live observability (CLIs, status scripts, evidence folders) for agent execution
department: Meta Office
---

# Agent eXperience Interface (AXI) Skill

**When to use this skill:**
- You are bootstrapping a new project and need to set up live observability.
- You are building a complex data pipeline and need to ensure agents can debug it later.
- You notice agents are "flying blind" and making raw database queries or complex API calls to understand system state.

## The AXI Philosophy

Markdown artifacts (`spec.md`, `tech-spec.md`) are perfect for **planning and handoffs**. However, during **execution**, agents need live observability into running systems, databases, and background workers. AXI provides this through three pillars:

### 1. Agent CLIs (Task-Oriented Object Notation)
Agents should not write raw SQL or complex `curl` commands to understand system state.
- **Action**: Build read-only CLIs (e.g., `./cli <domain> list`) that query the database or state directly.
- **Format**: Output strictly in **TOON (Task-Oriented Object Notation)**—dense YAML/JSON blocks without conversational fluff, UI spinners, or interactive prompts.
- *Example*: `./project-cli users list --status=active` should instantly return `[{ id: "123", email: "..." }]`.

### 2. Evidence Folders
When building background workers, parsers, or AI pipelines, intermediate state is often lost, making it impossible for future agents to debug.
- **Action**: Create a test harness (e.g., `test:evidence`) that runs the pipeline and dumps raw inputs, intermediate outputs, and final artifacts into a local `.evidence/` folder.
- **Benefit**: Future agents can run the harness and read the exact text/JSON the pipeline saw, rather than guessing where a failure occurred.

### 3. Ambient Context (Zero-Boot)
Agents lose context when switching sessions.
- **Action**: Build a lightweight `./status` script that prints the current environment variables, bound ports, active processes, and high-level health metrics.
- **Benefit**: This acts as a "session hook" so agents instantly know the environment state without scraping `ps aux` or reading `.env` files.

## Your Responsibilities as `@axi`

1. **Audit for Blindspots**: Review the current project architecture. Are there databases or background processes that an agent cannot easily inspect?
2. **Build the CLI**: Propose and build the `./cli` (or equivalent) in the project root.
3. **Format for Machines**: Ensure all logs and CLI outputs from your tools use TOON. Strip out `ora` spinners, clear-screen (`\x1Bc`) commands, and interactive prompts if an `--agent` flag is passed.

## Output

You do not produce a single markdown artifact. Instead, you produce **executable code** (CLIs, status scripts, evidence test harnesses) that makes the project fundamentally "agent-readable."
