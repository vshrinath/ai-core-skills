# @debugging — Systematic Debugging

**Philosophy:** Debugging is hypothesis testing, not random code changes. Understand the problem before attempting a fix.

## When to invoke
- Bug reports (production or development)
- Unexpected behavior or errors
- Intermittent failures
- Performance degradation
- After failed deployment

## Responsibilities
- Reproduce the issue reliably
- Form and test hypotheses systematically
- Identify root cause (not just symptoms)
- Verify fix doesn't introduce regressions
- Document findings for future reference

---

## The Debugging Process

### 1. Reproduce the Issue

**You can't fix what you can't reproduce.**

```
Steps to reproduce:
1. [Exact steps]
2. [With specific data]
3. [In specific environment]

Expected: [What should happen]
Actual: [What actually happens]
Frequency: [Always / Sometimes / Rarely]
```

**If intermittent:**
- Note patterns (time of day, specific users, data conditions)
- Increase logging around suspected area
- Try to find minimal reproduction case

### 2. Gather Information

**Collect evidence before forming theories.**

**What to gather:**
- Error messages (full stack trace)
- Logs (application, server, database)
- Request/response data
- User actions leading to error
- Environment (browser, OS, device)
- Recent changes (deployments, config, data)

**Tools:**
- Application logs
- Browser DevTools (Console, Network, Performance)
- Database query logs
- Server logs (nginx, gunicorn)
- Error tracking (Sentry, Rollbar)

### 3. Form Hypothesis

**Based on evidence, what could cause this?**

```
Hypothesis: The error occurs because [specific reason]

Evidence supporting:
- [Observation 1]
- [Observation 2]

Evidence against:
- [Observation 3]

Test: [How to verify this hypothesis]
```

**Common hypothesis patterns:**
- "If X is true, then Y should happen"
- "This only fails when [condition]"
- "This worked before [change], so [change] likely caused it"

### 4. Test Hypothesis

**Design an experiment to prove/disprove.**

```python
# Add logging to test hypothesis
import logging
logger = logging.getLogger(__name__)

def problematic_function(data):
    logger.info(f"Input data: {data}")  # What are we receiving?
    
    result = process(data)
    logger.info(f"Processed result: {result}")  # What did we produce?
    
    return result
```

**Testing strategies:**
- Add print statements / logging
- Use debugger breakpoints
- Simplify inputs (minimal test case)
- Change one variable at a time
- Compare working vs broken scenarios

### 5. Fix and Verify

**Once root cause is found:**

1. Write a test that reproduces the bug
2. Implement fix
3. Verify test passes
4. Check for regressions (run full test suite)
5. Deploy to staging and verify
6. Document the fix

---

## Debugging Techniques

### Binary Search Debugging

**Problem:** Bug is somewhere in large codebase

**Strategy:** Eliminate half the code at a time

```python
# Original code (bug somewhere in here)
def complex_function(data):
    step1 = process_step1(data)
    step2 = process_step2(step1)
    step3 = process_step3(step2)
    step4 = process_step4(step3)
    return step4

# Test midpoint
def complex_function(data):
    step1 = process_step1(data)
    step2 = process_step2(step1)
    print(f"Midpoint: {step2}")  # Is data correct here?
    step3 = process_step3(step2)
    step4 = process_step4(step3)
    return step4

# If correct at midpoint → bug is in step3 or step4
# If incorrect at midpoint → bug is in step1 or step2
# Repeat until found
```

### Rubber Duck Debugging

**Explain the problem out loud (to a rubber duck, colleague, or yourself).**

Often, articulating the problem reveals the solution:
- "So when the user clicks submit, we validate the form..."
- "Wait, we're not validating the email field!"

### Differential Debugging

**Compare working vs broken scenarios.**

```
Working:
- User A, Chrome, Desktop
- Data: {id: 1, name: "Test"}
- Result: Success

Broken:
- User B, Safari, Mobile
- Data: {id: 2, name: "Test"}
- Result: Error

Difference: User ID? Browser? Device? Data?
Test each difference individually.
```

### Time Travel Debugging

**When did it break?**

```bash
# Git bisect: Binary search through commits
git bisect start
git bisect bad  # Current commit is broken
git bisect good v1.0.0  # This version worked

# Git will checkout midpoint commit
# Test if bug exists
git bisect bad  # or git bisect good

# Repeat until git identifies the breaking commit
```

### Logging Strategy

**Strategic logging reveals data flow.**

```python
# ❌ Useless logging
logger.info("Processing data")

# ✅ Useful logging
logger.info(f"Processing {len(items)} items for user {user.id}")

# ❌ Too much logging
for item in items:
    logger.debug(f"Item: {item}")  # Floods logs

# ✅ Aggregate logging
logger.info(f"Processed {len(items)} items, {errors} errors")
if errors:
    logger.error(f"Failed items: {failed_items[:5]}")  # Sample only
```

**Log levels:**
- `DEBUG`: Detailed diagnostic info (development only)
- `INFO`: General informational messages
- `WARNING`: Something unexpected but handled
- `ERROR`: Error occurred, operation failed
- `CRITICAL`: System-level failure

---

## Common Bug Patterns

### Off-by-One Errors

```python
# ❌ Excludes last item
for i in range(len(items) - 1):
    process(items[i])

# ✅ Includes all items
for i in range(len(items)):
    process(items[i])

# ✅ Better: Use item directly
for item in items:
    process(item)
```

### Null/None Handling

```python
# ❌ Crashes if user has no email
email = user.email.lower()

# ✅ Handle None case
email = user.email.lower() if user.email else None

# ✅ Use get() with default
email = getattr(user, 'email', '').lower()
```

### Race Conditions

```python
# ❌ Check-then-act (race condition)
if not cache.get('lock'):
    cache.set('lock', True)
    process_data()  # Two processes might both enter here

# ✅ Atomic operation
if cache.add('lock', True, timeout=60):  # add() is atomic
    try:
        process_data()
    finally:
        cache.delete('lock')
```

### Timezone Issues

```python
# ❌ Naive datetime (no timezone)
from datetime import datetime
now = datetime.now()  # What timezone?

# ✅ Timezone-aware datetime
from django.utils import timezone
now = timezone.now()  # Always UTC

# ✅ Convert to user's timezone for display
from django.utils.timezone import localtime
user_time = localtime(now, user.timezone)
```

### String Encoding

```python
# ❌ Assumes ASCII
text = response.content.decode()  # Crashes on non-ASCII

# ✅ Specify encoding
text = response.content.decode('utf-8')

# ✅ Handle errors
text = response.content.decode('utf-8', errors='replace')
```

---

## Debugging Tools

### Python Debugger (pdb)

```python
# Add breakpoint
import pdb; pdb.set_trace()

# Or use built-in breakpoint() (Python 3.7+)
breakpoint()

# Commands:
# n (next): Execute next line
# s (step): Step into function
# c (continue): Continue execution
# p variable: Print variable value
# l (list): Show current code
# q (quit): Exit debugger
```

### Django Debug Toolbar

```python
# settings.py
INSTALLED_APPS += ['debug_toolbar']
MIDDLEWARE += ['debug_toolbar.middleware.DebugToolbarMiddleware']
INTERNAL_IPS = ['127.0.0.1']

# Shows:
# - SQL queries (with EXPLAIN)
# - Template rendering time
# - Cache hits/misses
# - Signal calls
# - Request/response headers
```

### Browser DevTools

**Console:**
- View JavaScript errors
- Test code snippets
- Inspect variables

**Network:**
- View API requests/responses
- Check status codes
- Inspect headers
- Measure request timing

**Sources:**
- Set breakpoints in JavaScript
- Step through code
- Watch variables

**Performance:**
- Record page load
- Identify slow functions
- Analyze rendering bottlenecks

### Logging

```python
# Django settings
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': 'debug.log',
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'myapp': {
            'handlers': ['console', 'file'],
            'level': 'DEBUG',
        },
    },
}

# Usage
import logging
logger = logging.getLogger(__name__)

logger.debug("Detailed diagnostic info")
logger.info("General info")
logger.warning("Something unexpected")
logger.error("Error occurred", exc_info=True)  # Include stack trace
```

---

## Production Debugging

### Rules for Production

1. **Never use debugger in production** (blocks all requests)
2. **Add logging, deploy, observe** (don't guess)
3. **Reproduce in staging first** (if possible)
4. **Have rollback plan ready** (before making changes)
5. **Monitor after changes** (watch error rates)

### Safe Production Debugging

```python
# ❌ Debugger (blocks all requests)
import pdb; pdb.set_trace()

# ✅ Logging (non-blocking)
logger.error(f"Unexpected state: {data}", extra={
    'user_id': user.id,
    'request_path': request.path,
})

# ✅ Feature flag for verbose logging
if settings.DEBUG_USER_ID == user.id:
    logger.info(f"Debug info for user {user.id}: {data}")

# ✅ Sentry breadcrumbs
import sentry_sdk
sentry_sdk.add_breadcrumb(
    category='debug',
    message='Processing payment',
    level='info',
    data={'amount': amount, 'user_id': user.id}
)
```

### Reading Production Logs

```bash
# Tail logs in real-time
tail -f /var/log/myapp/app.log

# Filter for errors
grep ERROR /var/log/myapp/app.log

# Count error types
grep ERROR /var/log/myapp/app.log | cut -d' ' -f5 | sort | uniq -c | sort -rn

# Find errors for specific user
grep "user_id=123" /var/log/myapp/app.log | grep ERROR

# AWS CloudWatch
aws logs tail /ecs/myapp-production --follow --filter-pattern "ERROR"
```

---

## Debugging Checklist

### Before Starting
- [ ] Can you reproduce the issue?
- [ ] Do you have the full error message?
- [ ] Do you have relevant logs?
- [ ] What changed recently?
- [ ] Does it work in a different environment?

### During Debugging
- [ ] Have you formed a hypothesis?
- [ ] Have you tested the hypothesis?
- [ ] Are you changing one thing at a time?
- [ ] Are you documenting your findings?
- [ ] Have you ruled out obvious causes?

### After Fixing
- [ ] Did you write a test that reproduces the bug?
- [ ] Does the test pass with your fix?
- [ ] Did you run the full test suite?
- [ ] Did you test in staging?
- [ ] Did you document the root cause?

---

## When to Ask for Help

**Ask for help when:**
- Stuck for > 2 hours with no progress
- Issue is outside your expertise (infrastructure, security)
- Production is down (escalate immediately)
- You've exhausted all hypotheses

**Before asking:**
- Document what you've tried
- Provide reproduction steps
- Share relevant logs/errors
- State your current hypothesis

**How to ask:**
```
Problem: [One sentence description]

Steps to reproduce:
1. [Step 1]
2. [Step 2]

Expected: [What should happen]
Actual: [What happens]

What I've tried:
- [Attempt 1] → [Result]
- [Attempt 2] → [Result]

Current hypothesis: [Your theory]

Logs: [Relevant error messages]
```

---

## Common Mistakes

### ❌ Changing Multiple Things at Once
```python
# Changed 3 things, which one fixed it?
# Now you don't know what the actual problem was
```

### ✅ Change One Thing at a Time
```python
# Test hypothesis 1: Is it the data?
# Test hypothesis 2: Is it the query?
# Test hypothesis 3: Is it the cache?
```

---

### ❌ Debugging by Guessing
```python
# "Let's try adding a sleep() and see if that helps"
# "Maybe we need to clear the cache?"
```

### ✅ Form Hypothesis First
```python
# "If the issue is a race condition, adding a lock should fix it"
# Test: Add lock, verify fix
```

---

### ❌ Ignoring Error Messages
```python
# "It says 'KeyError: user_id' but I'll just add a try/except"
```

### ✅ Read and Understand Errors
```python
# KeyError means the key doesn't exist
# Why doesn't it exist? Is the data malformed?
# Fix the root cause, not the symptom
```

---

## Further Reading

- [Debugging: The 9 Indispensable Rules](https://debuggingrules.com/)
- [The Art of Debugging](https://www.oreilly.com/library/view/the-art-of/9781593271749/)
- [Python Debugging with pdb](https://realpython.com/python-debugging-pdb/)
- [Chrome DevTools Documentation](https://developer.chrome.com/docs/devtools/)
