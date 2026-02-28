# AGENTS.md — Rules for AI-Assisted Development

**Purpose**: These rules govern how AI assistants (Claude, Cursor, Copilot, Gemini, Windsurf, etc.) should behave when working on this codebase. They are derived from hard-won lessons across real projects where AI tools were used daily as development partners.

---

## RULE 1: SIMPLEST SOLUTION FIRST

**Always explore and propose the simplest solution possible, with relevant tradeoffs stated explicitly.**

Before writing any code:
1. State the simplest possible approach in 1-2 sentences
2. State what it costs (limitations, what you give up)
3. Only propose a more complex approach if the user explicitly says the tradeoffs are unacceptable

**Examples of violations**:
- Suggesting a pub/sub event system when a direct function call works
- Creating an abstract base class for something that has one implementation
- Adding a caching layer before confirming there's a performance problem
- Building a migration framework when a SQL script would do
- Proposing microservices when a monolith serves the current scale

**The test**: If you remove your proposed abstraction and the code still works with minor duplication, the abstraction was premature.

---

## RULE 2: TREAT ME AS AN EXPERT PEER

**I am an expert product and systems thinker who understands system design, architecture tradeoffs, and business context. I may not know every framework constraint or API quirk — that's where you help.**

How to interact:
- **Explain decisions, don't make them for me.** Present options with tradeoffs and let me choose.
- **Don't simplify or hedge.** Use precise technical language. I'll ask if I don't follow.
- **Don't assume my intent.** If I say "add caching," ask where and why before choosing Redis vs. in-memory vs. HTTP cache headers. I probably have an opinion.
- **Challenge me when I'm wrong.** If my proposed approach has a flaw, say so directly with evidence. Don't just go along with it.
- **Skip the preamble.** No "Great question!" or "That's a really interesting approach!" Just answer.

What I don't need:
- Explanations of what REST is, what a migration does, or how Git works
- "Are you sure?" when I've made a deliberate choice
- Unsolicited tutorials or background context I didn't ask for

What I do need:
- "This approach won't work because the ORM does X differently" — framework-specific gotchas
- "There's a simpler way using what's already in the codebase" — things I might not have seen
- "This will break if [condition]" — consequences I might not have considered

---

## RULE 3: READ BEFORE YOU WRITE

**Never propose changes to code you haven't read. Never assume what a file contains.**

Before modifying any file:
1. Read the file (or the relevant section — not the entire codebase "for context")
2. Understand the existing patterns and conventions
3. Match them — don't introduce new conventions

Before suggesting a new dependency:
1. Check if the functionality already exists in the codebase
2. Check if an existing dependency already provides it
3. Only then suggest something new, with justification

---

## RULE 4: ONE THING AT A TIME

**Solve the problem that was asked about. Do not fix adjacent problems, refactor surrounding code, or "improve" things that weren't mentioned.**

Specifically, do NOT:
- Rename variables for "consistency" while fixing a bug
- Add type annotations to code you're passing through
- Refactor an import structure while adding a feature
- Add error handling for hypothetical scenarios
- "Clean up" code near your change

---

## RULE 5: FAIL LOUD, NOT SILENT

**Code should fail explicitly with a clear error, never silently fall back to a default that hides the problem.**

- No hardcoded fallback URLs or credentials for configuration that should be explicit
- No bare `except: pass`, empty `catch(e) {}`, or swallowed errors
- No default values that mask missing configuration
- If a required env var is missing, crash at startup with a message naming the variable
- If an API call fails, surface the error — don't return empty results as if everything is fine

---

## RULE 6: NEVER HARDCODE SECRETS OR ENVIRONMENT-SPECIFIC VALUES

**API keys, URLs, passwords, hostnames, ports, and any environment-specific values belong in environment variables or config files. Never in source code. Not even in comments or examples.**

- Use `os.environ.get()` / `process.env.` with a descriptive variable name
- If you see a hardcoded value that should be configurable, flag it
- Example files (`.env.example`) should use obviously fake values: `YOUR_API_KEY_HERE`, not a real-looking string
- Connection strings, webhook URLs, and CDN paths are environment-specific — treat them the same as secrets

---

## RULE 7: NAME THE TRADEOFF, DOCUMENT THE DECISION

**Every technical decision has a tradeoff. State it explicitly. If you can't name what you're giving up, you haven't thought it through.**

When proposing any approach, state:
1. **What you get**: the benefit
2. **What you give up**: the cost
3. **When this breaks**: the condition under which this becomes the wrong choice

When a non-obvious choice is made, write down WHY — in a code comment, a commit message, or an ADR.

Document:
- Why you chose approach A over approach B
- What will break if this assumption changes
- What looks wrong but is intentional

Don't document:
- What the code obviously does (no `# increment counter` above `counter += 1`)
- Aspirational features that may never be built

---

## RULE 8: DON'T GUESS AT REQUIREMENTS

**If a request is ambiguous, ask one clarifying question rather than assuming the most complex interpretation.**

AI tends to interpret ambiguous requests expansively:
- "Add search" becomes a full-text search engine with facets, filters, autocomplete, and analytics
- "Add auth" becomes OAuth, JWT, session management, role-based access, and audit logging
- "Make it faster" becomes a rewrite of the entire data access layer

Instead, ask:
- "Do you need full-text search or is filtering the existing list sufficient?"
- "Are we protecting the whole app or specific routes?"
- "Which page or operation is slow? Let me profile it first."

---

## RULE 9: DON'T AUTO-INSTALL DEPENDENCIES

**Never run `pip install`, `npm install`, `cargo add`, or modify dependency files without explicit approval.**

Before proposing a new dependency, state:
1. **What it does** and why the existing stack can't handle it
2. **How widely used it is** (downloads, maintenance status, last update)
3. **What it pulls in** (transitive dependencies, bundle size impact)
4. **Whether it's a runtime or dev dependency**

If the need is one-time or narrow, prefer:
- A small utility function over a library
- A stdlib solution over a third-party package
- A script over a permanent dependency

---

## RULE 10: WORKING STATE AT EVERY STEP

**Every change should leave the system in a working state. If a migration requires multiple steps, each step should be independently deployable.**

- Feature flags over big-bang migrations
- Incremental changes that can be merged independently over one massive PR
- If a refactor requires 10 file changes, ensure the system works after each logical batch
- Never leave dead code "for later cleanup" — if you're replacing something, remove the old thing in the same change or document exactly when it will be removed

---

## RULE 11: SCOPE YOUR CONFIDENCE

**Be explicit about what you know vs. what you're inferring vs. what you're guessing.**

Use language like:
- "I can see in the code that..." (verified)
- "Based on the patterns in this codebase, I think..." (inference)
- "I'm not sure about this — you should verify..." (guess)

Never:
- Present a guess as fact
- Claim a fix "should work" without testing or explaining the assumption
- Generate a config file from memory without checking current versions
- Cite a library API without confirming it exists in the installed version

---

## RULE 12: ASK BEFORE DELETING

**Never delete files, functions, database columns, routes, or API endpoints without confirming.**

Something that looks unused might be:
- Called dynamically (reflection, string-based dispatch, template tags)
- Referenced in configuration, scripts, or cron jobs outside the codebase
- Used by an external consumer (API clients, webhooks, integrations)
- Part of an in-progress migration where both old and new coexist intentionally

If you're confident something is dead code, say so and explain your evidence — but wait for confirmation.

---

## RULE 13: MATCH THE PROJECT'S EXISTING PATTERNS

**Adopt the project's conventions. Don't import your own preferences.**

Before writing anything, check:
- File naming, quote style, indentation
- Test location and naming patterns
- Import style: absolute or relative? Sorted how?
- Error handling pattern: exceptions? Result types? Error codes?
- Logging: structured? `print`? Framework logger?

If the project is inconsistent, match the pattern in the file you're editing, not the one you prefer.

---

## RULE 14: COMMIT MESSAGES ARE FOR HUMANS SIX MONTHS FROM NOW

**Every commit message should explain what changed and why, in a format that's useful when scanning `git log` months later.**

Format:
```
<type>: <what changed — plain English, specific>

<Why this change was needed. 1-2 sentences.>
```

Types: `fix`, `feat`, `refactor`, `docs`, `chore`, `test`

Good:
- `fix: search returns 500 when index is empty, now falls back to DB query`
- `feat: add bookmark toggle to article header, syncs with auth provider`
- `refactor: split 82KB API file into per-content-type modules`

Bad:
- `update files`
- `fix bug`
- `WIP`
- `address review comments`

---

## RULE 15: MAINTAIN CHANGELOG ON EVERY COMMIT

**Every commit must append to `CHANGELOG.md`. This is non-negotiable.**

Format:

```markdown
## [YYYY-MM-DD] — <short description>

**Commit**: `<short hash>` on branch `<branch>`

### What changed
- <bullet 1: what was added, fixed, or changed>
- <bullet 2>

### Why
<1-2 sentences on the motivation>

### Files touched
- `path/to/file1` — <what changed in this file>
- `path/to/file2` — <what changed in this file>
```

Rules:
- **Append, never overwrite.** New entries go at the top of the file, below the header.
- **One entry per commit.** If a commit touches multiple features, list them all in one entry.
- **Be specific, not vague.** "Fixed search" is useless. "Fixed search returning empty results when index is empty instead of falling back to database query" is useful.
- **Include file paths.** This makes it possible to trace back from changelog to code.

If `CHANGELOG.md` doesn't exist, create it.

---

## RULE 16: NO FILE SPRAWL — DOCS GO IN /docs, NOWHERE ELSE

**AI tools must not create files outside the project's established structure. Documentation goes in `/docs/`. Period.**

Specifically:
- **Do not create** markdown files in the project root (except `README.md`, `AGENTS.md`, `CHANGELOG.md`)
- **Do not create** random `.md` files alongside source code
- **Do not create** documentation files unless explicitly asked to
- **If you need to document something**, append to an existing doc in `/docs/` or ask where it should go

File creation rules:
1. **Source code files**: Only create if the feature requires it. Prefer editing existing files.
2. **Documentation files**: Only in `/docs/`. Only when explicitly requested.
3. **Configuration files**: Only at project root or in established config directories.
4. **Test files**: Only in established test directories, matching existing naming patterns.
5. **Temporary/scratch files**: Never.

---

## RULE 17: CONTEXT WINDOW DISCIPLINE

**Be surgical with what you load into context. Don't read 15 files "for background" when the task touches 2.**

- Read only the files relevant to the current task
- Read specific functions or sections, not entire large files unless necessary
- Don't preemptively load "related" files that might be useful — load them when you actually need them
- If you need to understand a pattern, read one example file, not all of them
- When context is getting long, summarize what you've learned and release the raw content

---

## RULE 18: GOAL-DRIVEN EXECUTION

**Define verifiable success criteria before starting. Loop until verified.**

Transform vague tasks into testable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan with verification:
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]

Strong success criteria enable independent iteration. Weak criteria ("make it work") require constant clarification.

---

## SKILLS SYSTEM

This project uses role-based skills for AI-assisted development. Load only the skills you need for the current task.

### Available Skills by Domain

**Product & Planning** — `skills/product/`:
- `@pm` — Feature scoping, requirements, acceptance criteria
- `@task-decomposition` — Breaking features into small, testable tasks
- `@decision-framework` — Architecture decisions, build vs. buy, technical debt

**Coding** — `skills/coding/`:
- `@arch` — Architectural decisions, system design, service boundaries
- `@dev` — Any implementation task — backend, frontend, or both
- `@guard` — Code review, security audit, convention drift check
- `@qa` — Testing, edge cases, regression verification
- `@self-review` — Pre-handoff quality check before requesting code review
- `@debugging` — Bug investigation, intermittent failures, root cause analysis
- `@refactoring` — Code smells, safe structural cleanup, tech debt reduction
- `@api-design` — Designing or reviewing API endpoints and contracts
- `@data-modeling` — Schema design, model relationships, migrations
- `@performance` — Backend performance: slow queries, caching, API optimization
- `@frontend-performance` — Frontend performance: Core Web Vitals, bundle size, image optimization

**Marketing** — `skills/marketing/`:
- `@video-ai` — AI video generation with cinematography knowledge
- `@video` — Remotion-specific video production (React/TypeScript compositions)
- `@writer` — Articles, newsletters, social posts, email campaigns
- `@seo` — Meta tags, structured data, technical SEO
- `@perf` — Ad copy, landing pages, UTM tracking, A/B tests

**Design** — `skills/design/`:
- `@ux` — User flows, component states, accessibility, form design

**Operations** — `skills/ops/`:
- `deployment-practices` — Universal deployment principles
- `cicd-pipelines` — GitHub Actions CI/CD setup

**Meta (Autonomous Operation)** — `skills/meta/`:
- `@confidence-scoring` — Assessing confidence level, determining when to ask for help
- `@context-strategy` — Managing limited context window, efficient file navigation
- `@error-recovery` — Handling test/build/deployment failures autonomously

### Workflow Examples

**Building a feature:**
```
@pm → @ux → @arch → @dev → @guard → @qa
```

**Small coding fix:**
```
@debugging → @guard
```

**Content/marketing:**
```
@writer → @seo
```

**High-stakes decision:**
```
@decision-framework → @arch → @dev
```

**Skip any step that doesn't apply. Load only the skills you'll actually use.**

### Handoff Triggers

| From | To | When |
|------|----|------|
| `@pm` | `@ux` or `@arch` | Requirements finalized — ready for design or architecture |
| `@ux` | `@arch` or `@dev` | Design specs complete — ready for architecture or implementation |
| `@arch` | `@dev` | Architecture finalized — implementation plan ready |
| `@dev` | `@self-review` | Implementation complete — ready for self-check |
| `@self-review` | `@guard` | Self-review passed — ready for code review |
| `@guard` | `@qa` | Security/sanity checks pass — ready for testing |
| `@guard` | `@dev` | Issues found — needs fixes |
| `@qa` | `@dev` | Tests fail — needs fixes |

### Project-Specific Configuration

See `CONVENTIONS.md` in the project root for:
- Tech stack details
- Code style and patterns
- Project structure
- Testing framework
- Known intentional quirks
- What requires asking before doing
