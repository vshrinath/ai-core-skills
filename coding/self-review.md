# @self-review — Pre-Handoff Quality Check

**Philosophy:** Catch your own mistakes before others do. The best code review is the one you don't need.

## When to invoke
- After completing implementation
- Before requesting code review
- Before merging to main branch
- After fixing bugs
- Before deploying to production

## Responsibilities
- Review own code for common mistakes
- Verify tests pass and cover edge cases
- Check adherence to conventions
- Validate security and performance
- Ensure documentation is updated

---

## Self-Review Checklist

### 1. Does It Work?

- [ ] All tests pass locally
- [ ] Manual testing completed for happy path
- [ ] Edge cases tested
- [ ] Error cases tested
- [ ] Works in development environment
- [ ] No console errors or warnings

**Test:**
```bash
# Run full test suite
pytest  # or npm test, go test, etc.

# Check for warnings
# No "DeprecationWarning", "TODO", or "FIXME" in output

# Manual testing
# Actually use the feature like a user would
```

### 2. Is It Correct?

- [ ] Logic is sound
- [ ] No off-by-one errors
- [ ] Null/None values handled
- [ ] Edge cases covered
- [ ] Race conditions prevented
- [ ] Timezone handling correct
- [ ] String encoding handled

**Common mistakes to check:**
```
# ❌ Off-by-one — iterating to len-1 misses the last item
for i in range(0, length - 1): ...   # should be range(0, length)

# ❌ Null not handled — calling methods on a value that may be null/nil/None
user.email.toLowerCase()   # crashes if email is null

# ❌ Race condition — two processes can both pass the check before either writes
if not lock_exists():
    set_lock()   # gap between check and set

# ❌ Timezone naive — datetime without timezone info produces wrong results
now = current_time()   # which timezone?
```

### 3. Is It Secure?

- [ ] No hardcoded secrets
- [ ] User input validated
- [ ] SQL injection prevented
- [ ] XSS prevented
- [ ] Authentication required (if needed)
- [ ] Authorization checked (if needed)
- [ ] Sensitive data encrypted
- [ ] No secrets in logs

**Security checklist:**
```python
# ✓ Parameterized queries
cursor.execute("SELECT * FROM users WHERE id = %s", [user_id])

# ✓ Input validation
if not email or '@' not in email:
    raise ValueError("Invalid email")

# ✓ Authentication
@permission_classes([IsAuthenticated])

# ✓ Authorization
if request.user.id != resource.owner_id:
    return Response(status=403)
```

### 4. Is It Performant?

- [ ] No N+1 queries (backend)
- [ ] Indexes exist on filtered columns (backend)
- [ ] Large datasets paginated (backend)
- [ ] Expensive operations cached (backend)
- [ ] No unnecessary data loaded (backend)
- [ ] Frontend bundle size reasonable (see `@frontend-perf`)
- [ ] Images optimized (see `@frontend-perf`)

**Performance checklist:**
```
# Backend (see @performance for details)
# ✓ Eager-load related records to avoid N+1 queries
# ✓ Paginate large result sets — never return unbounded lists
# ✓ Cache expensive queries with a TTL
# ✓ Select only the fields you need, not SELECT *

# Frontend (see @frontend-perf for details)
# ✓ Specify image dimensions to prevent layout shift
# ✓ Code-split heavy components so they don't block initial load
# ✓ Lazy-load below-fold images and components
```

### 5. Is It Readable?

- [ ] Variable names are clear
- [ ] Function names describe what they do
- [ ] No magic numbers
- [ ] No deep nesting (< 3 levels)
- [ ] Functions are small (< 50 lines)
- [ ] Comments explain "why", not "what"
- [ ] No commented-out code

**Readability checklist:**
```python
# ❌ Unclear
def calc(x, y, z):
    return x * y * z * 0.1

# ✅ Clear
def calculate_discount(price, quantity, discount_rate):
    return price * quantity * discount_rate

# ❌ Magic number
if user.age < 18:

# ✅ Named constant
MINIMUM_AGE = 18
if user.age < MINIMUM_AGE:
```

### 6. Is It Tested?

- [ ] Unit tests exist
- [ ] Tests cover happy path
- [ ] Tests cover edge cases
- [ ] Tests cover error cases
- [ ] Test names are descriptive
- [ ] Tests are independent
- [ ] No flaky tests

**Test coverage checklist:**
```python
# Happy path
def test_create_user_success():
    user = create_user("john@example.com", "password123")
    assert user.email == "john@example.com"

# Edge case
def test_create_user_with_empty_email():
    with pytest.raises(ValueError):
        create_user("", "password123")

# Error case
def test_create_user_with_duplicate_email():
    create_user("john@example.com", "password123")
    with pytest.raises(IntegrityError):
        create_user("john@example.com", "password456")
```

### 7. Is It Documented?

- [ ] README updated (if needed)
- [ ] API documentation updated
- [ ] Complex logic explained in comments
- [ ] Migration notes (if schema changed)
- [ ] Changelog or release notes updated (if the project maintains one)
- [ ] Docstrings for public functions

**Documentation checklist:**
```python
# ✓ Docstring for public function
def calculate_discount(price: float, quantity: int) -> float:
    """
    Calculate discount amount for bulk orders.
    
    Args:
        price: Unit price
        quantity: Number of items
        
    Returns:
        Discount amount (10% for orders > 10 items)
    """
    if quantity > 10:
        return price * quantity * 0.1
    return 0

# ✓ Comment for non-obvious logic
# We use exponential backoff here because the API rate limits
# aggressively after 3 failed attempts
for attempt in range(5):
    try:
        return api_call()
    except RateLimitError:
        time.sleep(2 ** attempt)
```

### 8. Does It Follow Conventions?

- [ ] Matches project code style
- [ ] Follows naming conventions
- [ ] Uses project patterns
- [ ] No new patterns without justification
- [ ] Linting passes
- [ ] Formatting consistent

**Convention checklist:**
```python
# Check project conventions
# - File naming: snake_case or kebab-case?
# - Import order: stdlib, third-party, local?
# - Quote style: single or double?
# - Line length: 80 or 120?

# Run linter
ruff check .  # or eslint, golangci-lint, etc.

# Run formatter
black .  # or prettier, gofmt, etc.
```

### 9. Is It Maintainable?

- [ ] No duplicated code
- [ ] Functions have single responsibility
- [ ] Classes have single responsibility
- [ ] Dependencies are minimal
- [ ] No circular dependencies
- [ ] Easy to modify in future

**Maintainability checklist:**
```python
# ❌ Duplicated code
def create_user(name, email):
    user = User()
    user.name = name
    user.email = email
    user.created_at = timezone.now()
    user.save()

def create_admin(name, email):
    user = User()
    user.name = name
    user.email = email
    user.created_at = timezone.now()
    user.is_admin = True
    user.save()

# ✅ DRY (Don't Repeat Yourself)
def create_user(name, email, is_admin=False):
    return User.objects.create(
        name=name,
        email=email,
        created_at=timezone.now(),
        is_admin=is_admin
    )
```

### 10. Is It Safe to Deploy?

- [ ] Backward compatible (or feature flagged)
- [ ] Database migrations are reversible
- [ ] No breaking API changes (or versioned)
- [ ] Rollback plan exists
- [ ] Monitoring/logging added
- [ ] Error handling in place

**Deployment safety checklist:**
```python
# ✓ Feature flag for risky changes
if settings.FEATURE_NEW_SEARCH_ENABLED:
    return new_search(query)
else:
    return old_search(query)

# ✓ Backward compatible migration
# Step 1: Add new field (nullable)
# Step 2: Backfill data
# Step 3: Make field non-nullable
# Step 4: Remove old field

# ✓ Logging for debugging
logger.info(f"Processing payment for user {user.id}, amount {amount}")
```

---

## Self-Review Process

### Step 1: Read Your Own Code

**Pretend you're reviewing someone else's code.**

```
Questions to ask:
- Would I understand this in 6 months?
- Is this the simplest solution?
- What could go wrong?
- What edge cases am I missing?
- Is this secure?
- Is this performant?
```

### Step 2: Run All Checks

```bash
# Tests
pytest

# Linting
ruff check .

# Type checking
mypy .

# Security scan
bandit -r .

# Formatting
black --check .
```

### Step 3: Manual Testing

```
Test scenarios:
1. Happy path (everything works)
2. Empty input
3. Invalid input
4. Boundary conditions (0, -1, max value)
5. Concurrent access (if applicable)
6. Slow network (if applicable)
```

### Step 4: Review Changes

```bash
# View your changes
git diff

# Check what files changed
git status

# Review each file
# - Does every change belong in this PR?
# - Any debug code left in?
# - Any commented-out code?
# - Any console.log or print statements?
```

### Step 5: Write Self-Review Notes

```markdown
## Self-Review Notes

### What I Changed
- [Brief description]

### Why
- [Reason for change]

### Testing Done
- [x] Unit tests pass
- [x] Manual testing completed
- [x] Edge cases tested

### Confidence Level
- 85% - Mostly confident, but uncertain about [specific thing]

### Questions for Reviewer
1. Is [approach] the right way to handle [scenario]?
2. Should we add [additional feature]?

### Known Issues
- [Issue 1] - Will fix in follow-up PR
- [Issue 2] - Acceptable trade-off because [reason]
```

---

## Common Self-Review Findings

### Security Issues
```python
# Found: Hardcoded secret
API_KEY = "sk-1234567890"

# Fixed: Use environment variable
API_KEY = os.environ.get('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY environment variable required")
```

### Performance Issues
```python
# Found: N+1 query
articles = Article.objects.all()
for article in articles:
    print(article.author.name)  # Hits DB each time

# Fixed: Use select_related
articles = Article.objects.select_related('author').all()
for article in articles:
    print(article.author.name)  # No additional queries
```

### Logic Errors
```python
# Found: Off-by-one error
for i in range(len(items) - 1):
    process(items[i])  # Misses last item!

# Fixed: Correct range
for i in range(len(items)):
    process(items[i])

# Better: Use item directly
for item in items:
    process(item)
```

### Missing Error Handling
```python
# Found: No error handling
data = json.loads(response.text)

# Fixed: Handle errors
try:
    data = json.loads(response.text)
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON response: {e}")
    return None
```

---

## When to Skip Self-Review

**Never.** Always do self-review.

Even for trivial changes:
- Typo fix → Check you didn't introduce new typos
- Version bump → Check you updated all places
- Config change → Check syntax is valid

---

## Self-Review Anti-Patterns

### ❌ "It works on my machine"
```
[Doesn't test in clean environment]
[Doesn't check if dependencies are documented]
[Assumes everyone has same setup]
```

### ✅ Test in Clean Environment
```
[Run in Docker container]
[Check dependencies are in requirements.txt]
[Verify setup instructions work]
```

---

### ❌ "Tests pass, ship it"
```
[Doesn't read the code]
[Doesn't check for obvious issues]
[Doesn't verify edge cases]
```

### ✅ Read Your Code
```
[Review every line]
[Check for common mistakes]
[Verify edge cases are handled]
```

---

### ❌ "I'll fix it later"
```
[Leaves TODO comments]
[Leaves debug code]
[Leaves commented-out code]
```

### ✅ Fix It Now
```
[Remove TODOs or create tickets]
[Remove debug code]
[Remove commented-out code]
```

---

## Checklist: Ready for Review

- [ ] All self-review checks passed
- [ ] Tests pass locally
- [ ] Linting passes
- [ ] Manual testing completed
- [ ] Documentation updated
- [ ] Commit message is clear
- [ ] PR description is complete
- [ ] Confidence level documented
- [ ] Questions for reviewer prepared

---

## Further Reading

- [Code Review Best Practices](https://google.github.io/eng-practices/review/)
- [Self-Review Checklist](https://github.com/mgreiler/code-review-checklist)
- [The Art of Readable Code](https://www.oreilly.com/library/view/the-art-of/9781449318482/)
- [Clean Code](https://www.oreilly.com/library/view/clean-code-a/9780136083238/)
