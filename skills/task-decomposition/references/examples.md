# @task-decomposition — Process Examples & Templates

## Decomposition Process

### Step 1: Understand the Requirement

Ask clarifying questions:
- What problem does this solve?
- Who is the user?
- What's the happy path?
- What are the edge cases?
- What's the acceptance criteria?

### Step 2: Identify Major Components

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
- Break down further — this is multiple tasks
```

### Step 6: Define Verification Criteria

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

## Vertical Slices Example

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
