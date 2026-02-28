# @error-recovery — Handling Failures Autonomously

**Philosophy:** Failures are learning opportunities. Analyze, adapt, retry. Know when to escalate.

## When to invoke
- When tests fail
- When builds fail
- When deployments fail
- When unexpected errors occur
- When stuck on a problem

## Responsibilities
- Analyze failure root cause
- Determine if retry will help
- Implement fix autonomously
- Know when to escalate
- Learn from failures

---

## Core Principles

### 1. Understand Before Fixing

**Never fix blindly. Always understand the root cause.**

```
❌ Bad (guess and check):
Test fails → Try random fix → Still fails → Try another fix → ...

✅ Good (analyze first):
Test fails → Read error message → Understand cause → Fix root cause → Verify
```

### 2. Fix Root Cause, Not Symptoms

**Treat the disease, not the symptoms.**

```
❌ Symptom fix:
Error: "KeyError: 'user_id'"
Fix: Add try/except to catch KeyError

✅ Root cause fix:
Error: "KeyError: 'user_id'"
Analysis: user_id is missing from request data
Fix: Validate request data, return 400 if user_id missing
```

### 3. Retry Smart, Not Hard

**Some failures are transient, some are permanent.**

```
Retry for:
- Network timeouts
- Rate limits
- Temporary service outages
- Database connection errors

Don't retry for:
- Syntax errors
- Logic errors
- Missing dependencies
- Invalid credentials
```

---

## Failure Types & Recovery Strategies

### 1. Test Failures

**Symptom:** Tests fail after code change

**Analysis:**
```
1. Read the error message completely
2. Identify which test failed
3. Understand what the test expects
4. Understand what the code actually does
5. Identify the mismatch
```

**Recovery:**
```python
# Test failure example
def test_create_user():
    user = create_user("john@example.com", "password123")
    assert user.email == "john@example.com"
    assert user.is_active == True  # FAILS

# Analysis:
# - Test expects is_active to be True
# - Code sets is_active to False by default
# - Root cause: Default value is wrong

# Fix:
class User(models.Model):
    email = models.EmailField()
    is_active = models.BooleanField(default=True)  # Changed from False
```

**When to retry:**
- Never retry without fixing
- Fix the code, then run tests again

### 2. Build Failures

**Symptom:** Build fails (compilation, linting, type errors)

**Analysis:**
```
1. Read the build error
2. Identify the file and line number
3. Understand what the error means
4. Check if it's a syntax error, type error, or missing dependency
```

**Recovery:**
```python
# Build error example
Error: NameError: name 'Article' is not defined

# Analysis:
# - Article is used but not imported
# - Root cause: Missing import

# Fix:
from myapp.models import Article  # Add import
```

**When to retry:**
- After fixing the error
- Run build again to verify

### 3. Deployment Failures

**Symptom:** Deployment fails (migration errors, service won't start)

**Analysis:**
```
1. Check deployment logs
2. Identify the failure point
3. Check if it's a migration issue, dependency issue, or config issue
4. Verify environment variables are set
```

**Recovery:**
```bash
# Deployment error example
Error: django.db.utils.OperationalError: no such column: articles_article.new_field

# Analysis:
# - Code expects new_field to exist
# - Migration hasn't run yet
# - Root cause: Migration order issue

# Fix:
# 1. Ensure migration is in the deployment
# 2. Run migrations before deploying code
# 3. Or use feature flag to enable new code after migration
```

**When to retry:**
- After fixing the issue
- Verify in staging first

### 4. Runtime Errors

**Symptom:** Code crashes in production

**Analysis:**
```
1. Read the error message and stack trace
2. Identify the line that crashed
3. Understand what data caused the crash
4. Check if it's a null value, type mismatch, or logic error
```

**Recovery:**
```python
# Runtime error example
Error: AttributeError: 'NoneType' object has no attribute 'lower'

# Code:
email = user.email.lower()

# Analysis:
# - user.email is None
# - Code doesn't handle None case
# - Root cause: Missing null check

# Fix:
email = user.email.lower() if user.email else None
# Or:
if not user.email:
    raise ValueError("Email is required")
email = user.email.lower()
```

**When to retry:**
- After fixing the code
- Deploy fix to production

---

## Error Analysis Framework

### Step 1: Read the Error Message

**Extract key information:**
```
Error message components:
1. Error type (KeyError, ValueError, AttributeError)
2. Error message ("'user_id' not found")
3. File and line number (views.py:45)
4. Stack trace (call chain leading to error)
```

### Step 2: Reproduce Locally

**Can you make it fail on demand?**
```
1. Identify the input that causes failure
2. Create a test case that reproduces it
3. Run the test locally
4. Verify it fails the same way
```

### Step 3: Form Hypothesis

**What do you think is wrong?**
```
Hypothesis template:
"The error occurs because [specific reason].
If I [specific fix], it should [expected outcome]."

Example:
"The error occurs because user.email is None.
If I add a null check, it should handle None gracefully."
```

### Step 4: Test Hypothesis

**Verify your theory:**
```
1. Implement the fix
2. Run the test
3. Does it pass?
   - Yes → Hypothesis confirmed, fix is correct
   - No → Hypothesis wrong, try different approach
```

### Step 5: Verify Fix

**Ensure fix doesn't break anything else:**
```
1. Run full test suite
2. Check for regressions
3. Test edge cases
4. Deploy to staging
5. Verify in production
```

---

## Retry Logic

### When to Retry

```python
# ✓ Retry for transient errors
try:
    response = requests.get(url, timeout=5)
except requests.Timeout:
    # Retry with exponential backoff
    for attempt in range(3):
        time.sleep(2 ** attempt)
        try:
            response = requests.get(url, timeout=5)
            break
        except requests.Timeout:
            if attempt == 2:
                raise

# ✓ Retry for rate limits
try:
    api_call()
except RateLimitError as e:
    retry_after = e.retry_after
    time.sleep(retry_after)
    api_call()

# ❌ Don't retry for permanent errors
try:
    user = User.objects.get(id=user_id)
except User.DoesNotExist:
    # Don't retry - user doesn't exist
    return None
```

### Exponential Backoff

```python
def retry_with_backoff(func, max_attempts=5):
    for attempt in range(max_attempts):
        try:
            return func()
        except TransientError as e:
            if attempt == max_attempts - 1:
                raise
            wait_time = 2 ** attempt  # 1s, 2s, 4s, 8s, 16s
            time.sleep(wait_time)
```

---

## Escalation Criteria

### Escalate Immediately When:

```
1. Security issue discovered
   - Vulnerability found
   - Data breach risk
   - Credentials exposed

2. Data loss risk
   - Migration will delete data
   - Backup failed
   - Corruption detected

3. Production outage
   - Service is down
   - Critical feature broken
   - Users can't access system

4. Stuck for > 2 hours
   - Tried multiple approaches
   - No progress made
   - Don't understand the problem

5. Uncertain about approach
   - Multiple valid solutions
   - High risk decision
   - Architectural impact
```

### Escalation Template

```
Subject: [URGENT/BLOCKED] [Brief description]

Status: [Blocked / Need guidance / Production issue]

Issue:
[Describe the problem in 2-3 sentences]

What I've tried:
1. [Attempt 1] → [Result]
2. [Attempt 2] → [Result]
3. [Attempt 3] → [Result]

Current hypothesis:
[What you think is wrong]

Impact:
[What's affected, how many users, severity]

Recommended action:
[What you think should be done]

Need help with:
[Specific question or decision needed]
```

---

## Learning from Failures

### Post-Failure Analysis

```
After fixing an error, document:

1. What failed?
   [Specific error or failure]

2. Why did it fail?
   [Root cause]

3. How was it fixed?
   [Solution implemented]

4. How to prevent in future?
   [Process improvement, test added, etc.]

Example:
1. What: Test failed - user.email.lower() crashed
2. Why: user.email was None, no null check
3. How: Added null check before calling .lower()
4. Prevent: Added test for None email case
```

### Pattern Recognition

```
Track common failure patterns:

Pattern: "AttributeError: 'NoneType' object has no attribute X"
Cause: Missing null check
Fix: Add null check or validation
Prevention: Always validate input

Pattern: "KeyError: 'field_name'"
Cause: Missing field in dict/request
Fix: Use .get() with default or validate input
Prevention: Validate request data

Pattern: "N+1 query detected"
Cause: Missing select_related/prefetch_related
Fix: Add eager loading
Prevention: Check queries in tests
```

---

## Recovery Checklist

### When Error Occurs
- [ ] Read error message completely
- [ ] Identify error type and location
- [ ] Reproduce error locally
- [ ] Form hypothesis about cause
- [ ] Implement fix
- [ ] Verify fix works
- [ ] Run full test suite
- [ ] Check for regressions

### Before Retrying
- [ ] Understand why it failed
- [ ] Know what changed
- [ ] Have confidence fix is correct
- [ ] Have verification plan

### Before Escalating
- [ ] Tried multiple approaches
- [ ] Documented what was tried
- [ ] Identified specific blocker
- [ ] Prepared clear question

---

## Common Mistakes

### ❌ Fixing Without Understanding
```
[Test fails]
[Changes random code]
[Test passes by accident]
[Doesn't understand why]
[Breaks again later]
```

### ✅ Understand Then Fix
```
[Test fails]
[Reads error message]
[Understands root cause]
[Fixes root cause]
[Verifies fix]
[Adds test to prevent regression]
```

---

### ❌ Infinite Retry Loop
```
[Error occurs]
[Retries immediately]
[Error occurs again]
[Retries immediately]
[Repeats forever]
```

### ✅ Smart Retry with Backoff
```
[Error occurs]
[Checks if transient]
[Waits with exponential backoff]
[Retries up to max attempts]
[Escalates if still failing]
```

---

### ❌ Hiding Errors
```
try:
    risky_operation()
except Exception:
    pass  # Silently ignore all errors
```

### ✅ Handle Errors Appropriately
```
try:
    risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    # Handle or re-raise
    raise
```

---

## Further Reading

- [Error Handling Best Practices](https://docs.python.org/3/tutorial/errors.html)
- [Exponential Backoff](https://en.wikipedia.org/wiki/Exponential_backoff)
- [Circuit Breaker Pattern](https://martinfowler.com/bliki/CircuitBreaker.html)
- [Debugging Strategies](https://www.oreilly.com/library/view/the-art-of/9781593271749/)
