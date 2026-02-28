# @task-decomposition — Breaking Down Work

**Philosophy:** Make the change easy, then make the easy change. Large features are risky; small incremental changes are safe.

## When to invoke
- Planning new features or epics
- Breaking down vague requirements
- Estimating work effort
- Identifying dependencies
- Planning parallel work streams

## Responsibilities
- Decompose large features into small, testable tasks
- Identify dependencies between tasks
- Estimate effort for agentic development
- Determine what can be done in parallel
- Define verification criteria for each task

---

## Core Principles

### 1. Vertical Slices Over Horizontal Layers

**Bad (horizontal):** Build all models → all views → all templates → all tests
- Nothing works until everything is done
- Hard to test incrementally
- High risk of integration issues

**Good (vertical):** Build one complete feature slice at a time
- Each slice is independently deployable
- Can test and validate immediately
- Reduces integration risk

```
Example: User registration feature

❌ Horizontal (risky):
1. Create all database models (User, Profile, Session)
2. Create all API endpoints (register, login, logout, profile)
3. Create all frontend pages (signup, login, profile)
4. Write all tests

✅ Vertical (safe):
1. Basic registration (model + API + form + test)
2. Email verification (extend model + API + email + test)
3. Profile creation (new model + API + page + test)
4. Login/logout (session + API + pages + test)
```

### 2. Small, Independently Testable Tasks

**Each task should:**
- Be completable in 1-4 hours
- Have clear acceptance criteria
- Be independently testable
- Leave system in working state
- Be independently deployable (with feature flag if needed)

```
❌ Too large:
"Implement user authentication system"
(Could take days, unclear scope)

✅ Right size:
"Add User model with email and password fields"
"Create POST /api/register endpoint with validation"
"Add email verification token to User model"
"Implement email sending for verification"
```

### 3. Dependencies First, Features Second

**Identify blockers before starting work.**

```
Task dependency graph:

[Database schema] ← Must be done first
    ↓
[API endpoint] ← Depends on schema
    ↓
[Frontend form] ← Depends on API
    ↓
[Tests] ← Can be done anytime after API exists
```

**Parallel work opportunities:**
- Frontend mockup (doesn't need real API)
- Documentation (can be written early)
- Test scaffolding (can be written before implementation)

---

## Decomposition Process

### Step 1: Understand the Requirement

**Ask clarifying questions:**
- What problem does this solve?
- Who is the user?
- What's the happy path?
- What are the edge cases?
- What's the acceptance criteria?

```
Example: "Add search functionality"

Clarifications needed:
- Search what? (articles, users, both?)
- Full-text or simple filter?
- Real-time or on-submit?
- Pagination needed?
- Filters/facets needed?
```

### Step 2: Identify Major Components

**Break into logical chunks:**

```
Example: Article search feature

Components:
1. Backend: Search indexing
2. Backend: Search API endpoint
3. Frontend: Search input UI
4. Frontend: Results display
5. Testing: Search accuracy
6. Documentation: API docs
```

### Step 3: Break Components into Tasks

**Each component → multiple small tasks:**

```
Backend: Search API endpoint
├── Task 1: Create /api/search endpoint (basic)
├── Task 2: Add pagination to search results
├── Task 3: Add filtering (category, date)
├── Task 4: Add sorting options
└── Task 5: Add rate limiting

Frontend: Search input UI
├── Task 1: Create search input component
├── Task 2: Add debouncing (300ms delay)
├── Task 3: Add loading state
├── Task 4: Add error handling
└── Task 5: Add keyboard shortcuts (Cmd+K)
```

### Step 4: Identify Dependencies

**Map what blocks what:**

```
Dependency graph:

[Search indexing] ← Must exist first
    ↓
[Search API endpoint] ← Needs index
    ↓
[Search UI] ← Needs API
    ↓
[Results display] ← Needs API response format

Parallel work:
- [Search UI mockup] (can start immediately)
- [Documentation] (can start immediately)
- [Test data generation] (can start immediately)
```

### Step 5: Estimate Effort

**Agentic development time estimates:**

```
Simple (30 min - 1 hour):
- Add field to model
- Create simple API endpoint
- Add basic UI component
- Write unit test

Medium (1-2 hours):
- Add model with relationships
- Create API with validation
- Add UI with state management
- Write integration test

Complex (2-4 hours):
- Add model with complex logic
- Create API with authentication/authorization
- Add UI with complex interactions
- Write E2E test

Very Complex (4+ hours):
- Break down further
- Likely needs multiple tasks
```

### Step 6: Define Verification Criteria

**How do we know it's done?**

```
Task: "Create POST /api/search endpoint"

Acceptance criteria:
✓ Endpoint accepts query parameter
✓ Returns paginated results (20 per page)
✓ Returns 400 for invalid input
✓ Returns 200 with empty results if no matches
✓ Response time < 500ms for typical query
✓ Unit tests pass
✓ API documentation updated
```

---

## Task Template

```markdown
## Task: [Short description]

**Component:** [Backend/Frontend/Database/Testing]
**Estimated effort:** [30min/1h/2h/4h]
**Dependencies:** [List of tasks that must be done first]
**Blocks:** [List of tasks that depend on this]

### Description
[1-2 sentences explaining what needs to be done]

### Acceptance Criteria
- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [Specific, testable criterion 3]

### Implementation Notes
- [Any technical details, gotchas, or considerations]

### Verification
- [ ] Tests pass
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Deployed to staging
```

---

## Example: Complete Feature Breakdown

**Feature:** User can bookmark articles

### Task 1: Add Bookmark model
- **Effort:** 1 hour
- **Dependencies:** None
- **Acceptance:**
  - [ ] Bookmark model with user_id, article_id, created_at
  - [ ] Unique constraint on (user_id, article_id)
  - [ ] Migration created and tested
  - [ ] Model tests pass

### Task 2: Create bookmark API endpoints
- **Effort:** 2 hours
- **Dependencies:** Task 1
- **Acceptance:**
  - [ ] POST /api/bookmarks/ creates bookmark
  - [ ] DELETE /api/bookmarks/{id}/ removes bookmark
  - [ ] GET /api/bookmarks/ lists user's bookmarks
  - [ ] Authentication required
  - [ ] Returns 409 if bookmark exists
  - [ ] API tests pass

### Task 3: Add bookmark button to article card
- **Effort:** 1 hour
- **Dependencies:** Task 2
- **Acceptance:**
  - [ ] Bookmark icon shows on article cards
  - [ ] Filled icon if bookmarked, outline if not
  - [ ] Click toggles bookmark state
  - [ ] Optimistic UI update
  - [ ] Error handling if API fails
  - [ ] Component tests pass

### Task 4: Create bookmarks page
- **Effort:** 2 hours
- **Dependencies:** Task 2, Task 3
- **Acceptance:**
  - [ ] /bookmarks route shows user's bookmarks
  - [ ] Paginated list of bookmarked articles
  - [ ] Can remove bookmark from list
  - [ ] Empty state if no bookmarks
  - [ ] Loading state while fetching
  - [ ] Page tests pass

**Total effort:** 6 hours
**Can be done in parallel:** Task 3 mockup (while Task 2 is in progress)

---

## Parallel vs Sequential Work

### Identify Parallel Opportunities

```
Sequential (must be done in order):
1. Database schema
2. API endpoint
3. Frontend integration

Parallel (can be done simultaneously):
- Frontend mockup (with fake data)
- Documentation
- Test data generation
- UI design/styling
```

### When to Parallelize

**Parallelize when:**
- Tasks have no dependencies
- Tasks touch different parts of codebase
- One task is waiting (API review, design feedback)

**Don't parallelize when:**
- Tasks have dependencies
- Tasks touch same files (merge conflicts)
- Context switching cost is high

---

## Estimation for Agentic Development

### Time Multipliers

```
Base estimate (human developer):
- Simple task: 2 hours
- Medium task: 4 hours
- Complex task: 8 hours

Agentic multiplier:
- Simple: 0.5x (1 hour) — Agent is faster for boilerplate
- Medium: 0.75x (3 hours) — Agent needs some iteration
- Complex: 1.0x (8 hours) — Agent needs multiple attempts

Uncertainty multiplier:
- Clear requirements: 1.0x
- Some ambiguity: 1.5x
- Very unclear: 2.0x (or ask for clarification first)
```

### Confidence Levels

```
High confidence (90%+):
- Similar to previous work
- Clear requirements
- Well-understood tech stack
- Estimate: Use base estimate

Medium confidence (70-90%):
- Some new territory
- Minor ambiguity
- Estimate: Add 25% buffer

Low confidence (< 70%):
- Unfamiliar tech
- Unclear requirements
- Estimate: Add 50% buffer or ask for clarification
```

---

## Red Flags (Task Too Large)

**Break down further if:**
- Estimate > 4 hours
- Acceptance criteria > 10 items
- Description > 3 sentences
- Multiple "and" in task title
- Touches > 5 files
- Requires > 2 different skills (@dev + @ops)

```
❌ Too large:
"Implement user authentication and authorization system with email verification and password reset"

✅ Broken down:
1. Add User model with email/password
2. Create registration endpoint
3. Add email verification
4. Create login endpoint
5. Add JWT token generation
6. Create password reset flow
7. Add authorization middleware
```

---

## Checklist: Good Task Decomposition

- [ ] Each task is 1-4 hours
- [ ] Each task has clear acceptance criteria
- [ ] Dependencies are identified
- [ ] Parallel work opportunities identified
- [ ] Each task leaves system in working state
- [ ] Each task is independently testable
- [ ] Estimates include confidence level
- [ ] Verification criteria defined

---

## Common Mistakes

### ❌ Waterfall Decomposition
```
1. Design everything
2. Build everything
3. Test everything
4. Deploy everything
```

### ✅ Iterative Decomposition
```
1. Build minimal feature (design + build + test + deploy)
2. Add enhancement (design + build + test + deploy)
3. Add another enhancement (design + build + test + deploy)
```

---

### ❌ Technical Decomposition
```
1. Create all models
2. Create all views
3. Create all templates
```

### ✅ Feature Decomposition
```
1. User can register (model + view + template)
2. User can login (extend model + view + template)
3. User can reset password (extend model + view + template)
```

---

### ❌ No Dependencies Identified
```
Tasks in random order, discover blockers during work
```

### ✅ Dependencies Mapped
```
Critical path identified, parallel work planned
```

---

## Further Reading

- [User Story Mapping](https://www.jpattonassociates.com/user-story-mapping/)
- [Vertical Slices](https://www.industriallogic.com/blog/vertical-slices/)
- [INVEST Criteria for User Stories](https://en.wikipedia.org/wiki/INVEST_(mnemonic))
- [Agile Estimation Techniques](https://www.atlassian.com/agile/project-management/estimation)
