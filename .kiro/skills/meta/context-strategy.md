# @context-strategy — Managing Limited Context

**Philosophy:** Context is expensive. Load what you need, when you need it. Summarize and release.

## When to invoke
- Before starting any task
- When context window is filling up
- When navigating large codebases
- When working across multiple files
- When context feels overwhelming

## Responsibilities
- Load only relevant files
- Summarize and release context
- Navigate codebases efficiently
- Avoid context thrashing
- Maintain focus on current task

---

## Core Principles

### 1. Just-In-Time Loading

**Don't preload "for context". Load when you actually need it.**

```
❌ Bad (preemptive loading):
1. Read entire codebase "to understand the system"
2. Load all related files "just in case"
3. Read documentation "for background"
4. Now start the task (context is full!)

✅ Good (just-in-time):
1. Understand the task
2. Load only the file you're modifying
3. Load dependencies as you encounter them
4. Summarize and release when done
```

### 2. Surgical Reads

**Read specific sections, not entire files.**

```
# ❌ Read entire 2000-line file
read('models.py')   # loads everything

# ✅ Read a specific line range if you know where the relevant code is
read('models.py', offset=45, limit=80)   # only lines 45–125

# ✅ Search for the symbol first, then read only that file
grep('class Article')   # find the file
read('models.py', offset=45, limit=80)   # read just that class

# ✅ When a file is large and you only need one function,
#    search for the function name to find its line number,
#    then read a tight window around it
```

### 3. Summarize and Release

**After understanding, summarize key points and release the raw content.**

```
Process:
1. Read file
2. Extract key information
3. Summarize in 3-5 bullet points
4. Release the full file content from context
5. Keep only the summary

Example:
Read: models.py (500 lines)
Summary:
- Article model has title, content, author (ForeignKey)
- Published articles: status='published'
- Slug is auto-generated from title
- Has created_at, updated_at timestamps

[Release full file content, keep summary]
```

---

## Context Budget

### Typical Context Limits

```
Model context windows:
- GPT-4: 128K tokens (~96K words)
- Claude: 200K tokens (~150K words)
- Gemini: 1M tokens (~750K words)

Practical limits (with tool use):
- Reserve 20% for output
- Reserve 20% for system prompts
- Usable: ~60% of total

Effective capacity:
- GPT-4: ~60K words
- Claude: ~90K words
- Gemini: ~450K words
```

### File Size Estimates

```
Typical file sizes:
- Small file: 100-500 lines (~2-10K words)
- Medium file: 500-2000 lines (~10-40K words)
- Large file: 2000+ lines (~40K+ words)

Context cost:
- 10 small files = ~20-100K words
- 5 medium files = ~50-200K words
- 2 large files = ~80K+ words
```

### Budget Allocation

```
For a typical task:
- Task description: 5%
- Current file: 20%
- Related files: 30%
- Documentation: 10%
- Tool outputs: 15%
- Response generation: 20%
```

---

## Navigation Strategies

### Strategy 1: Top-Down (New Codebase)

```
1. Read README (understand project)
2. Read directory structure (understand organization)
3. Read entry point (understand flow)
4. Read specific file for task
5. Read dependencies as needed

Example: Adding a feature
1. README → understand tech stack
2. Directory structure → find where features live
3. Similar feature → understand pattern
4. Implement new feature
```

### Strategy 2: Bottom-Up (Specific Task)

```
1. Identify file to modify
2. Read that file
3. Read direct dependencies
4. Implement change
5. Read tests to understand expectations

Example: Fixing a bug
1. Read file with bug
2. Read function with bug
3. Understand what it should do
4. Fix bug
5. Read/write tests
```

### Strategy 3: Breadth-First (Understanding System)

```
1. Read high-level architecture docs
2. Read main components (one file each)
3. Summarize each component
4. Understand how they interact
5. Dive deep into relevant component

Example: Understanding authentication
1. Read auth docs
2. Read auth middleware (summary)
3. Read user model (summary)
4. Read login view (detailed)
5. Implement change
```

---

## Efficient File Reading

### Use Search Before Reading

Search narrows the target before you spend context reading:

```
# Find where a symbol is defined
glob / file search: '**/models.py'
grep: 'class Article'          # → tells you the file and line

# Find where something is used
grep: 'Article.objects.create' # → all call sites across the codebase

# Then read only the relevant file and section
read: 'models.py' lines 45–120
```

### Read Sections, Not Files

```
# ❌ Read 2000-line file entirely
read('models.py')

# ✅ Read only the section you need
read('models.py', offset=45, limit=80)    # specific class
read('settings.py', offset=100, limit=50) # specific config block
```

### Skim Structure First for Unknown Codebases

When navigating an unfamiliar codebase, list directory structure (1–2 levels deep) before opening any files. This tells you where things live without spending context on file contents.


---

## Context Management Patterns

### Pattern 1: Load-Process-Release

```
1. Load file
2. Extract needed information
3. Summarize key points
4. Release file content
5. Keep summary

Example:
Load: settings.py
Extract: DATABASE_URL, SECRET_KEY, DEBUG
Summary: "Uses PostgreSQL, requires SECRET_KEY env var, DEBUG=False in prod"
Release: settings.py content
Keep: Summary
```

### Pattern 2: Incremental Loading

```
1. Start with minimal context
2. Load more as needed
3. Release what's no longer needed
4. Repeat

Example: Implementing a feature
1. Load: Feature spec
2. Load: Similar feature (for pattern)
3. Release: Similar feature (keep pattern summary)
4. Load: File to modify
5. Implement
6. Release: File (keep change summary)
7. Load: Test file
8. Write tests
```

### Pattern 3: Focused Sessions

```
1. Define clear goal
2. Load only files for that goal
3. Complete goal
4. Release all context
5. Start next goal fresh

Example: Multi-step task
Session 1: Add model field
- Load: models.py
- Add field
- Release all

Session 2: Add API endpoint
- Load: views.py, serializers.py
- Add endpoint
- Release all

Session 3: Add tests
- Load: tests.py
- Write tests
- Release all
```

---

## When Context is Full

### Signs Context is Full

```
- Responses are slow
- Responses are truncated
- Losing track of earlier information
- Repeating questions
- Confusion about what's been done
```

### Recovery Strategies

```
1. Summarize current state
   - What have we done?
   - What's left to do?
   - What are the key findings?

2. Release all file contents
   - Keep only summaries
   - Keep only current task context

3. Start fresh session
   - Copy summary to new session
   - Load only current file
   - Continue work

4. Break task into smaller pieces
   - Complete current piece
   - Release context
   - Start next piece fresh
```

---

## Context Optimization Techniques

### 1. Use Summaries

```
Instead of keeping full file:
"models.py (500 lines): Article model with title, content, author FK, 
status field, auto-generated slug, timestamps"

Instead of full conversation:
"Previous work: Added Article model, created API endpoint, wrote tests. 
All tests pass. Ready for review."
```

### 2. Use References

```
Instead of loading full file:
"See Article model in models.py line 45-120"

Instead of repeating code:
"Use same pattern as create_user() in views.py"
```

### 3. Use Diffs

```
Instead of full file:
"Changed line 45: status = 'draft' → status = 'published'"

Instead of full context:
"Modified 3 files: models.py (+5 lines), views.py (+20 lines), tests.py (+15 lines)"
```

### 4. Use Caching

```
For repeated information:
"Tech stack: Django 4.2, PostgreSQL, Redis (cached from README)"

For patterns:
"Follow standard CRUD pattern (cached from conventions)"
```

---

## Codebase Navigation Checklist

### Before Loading Files
- [ ] Understand the task clearly
- [ ] Identify which files need modification
- [ ] Check if similar code exists (for patterns)
- [ ] Plan what to load and in what order

### While Working
- [ ] Load files just-in-time
- [ ] Read specific sections, not entire files
- [ ] Summarize after reading
- [ ] Release content after summarizing
- [ ] Track context usage

### After Completing Task
- [ ] Summarize what was done
- [ ] Release all file contents
- [ ] Keep only task summary
- [ ] Document key decisions

---

## Common Mistakes

### ❌ Reading Everything Upfront
```
[Reads 20 files "for context"]
[Context is full before starting]
[Can't load files actually needed]
```

### ✅ Just-In-Time Loading
```
[Reads only current file]
[Loads dependencies as needed]
[Plenty of context available]
```

---

### ❌ Never Releasing Context
```
[Loads file 1]
[Loads file 2]
[Loads file 3]
[Context fills up]
[Can't load file 4]
```

### ✅ Load-Summarize-Release
```
[Loads file 1, summarizes, releases]
[Loads file 2, summarizes, releases]
[Loads file 3, summarizes, releases]
[Context stays manageable]
```

---

### ❌ Reading Full Files
```
[Reads 2000-line file]
[Only needs 1 function]
[Wasted 1900 lines of context]
```

### ✅ Surgical Reads
```
[Reads specific function]
[Uses 100 lines of context]
[Efficient use of context]
```

---

## Tools for Context Management

### File Reading
- **Read with offset/limit** — read a specific line range instead of the whole file
- **Grep / content search** — find which file contains what you need before reading
- **Glob / file search** — locate files by name pattern before reading
- **Directory listing** — skim structure (1–2 levels) to orient in an unfamiliar codebase

### Context Tracking
- Track how many files are loaded
- Track total lines read
- Estimate context usage
- Release when > 50% full

### Summarization
- After reading each file
- After completing each task
- Before switching contexts
- When context feels full

---

## Further Reading

- [Working Memory in Software Development](https://www.researchgate.net/publication/220425899_Working_Memory_in_Software_Development)
- [Cognitive Load Theory](https://en.wikipedia.org/wiki/Cognitive_load)
- [Information Foraging Theory](https://en.wikipedia.org/wiki/Information_foraging)
