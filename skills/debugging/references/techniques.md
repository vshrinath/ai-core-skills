# @debugging — Techniques & Tools

## Debugging Techniques

### Binary Search Debugging

**Problem:** Bug is somewhere in large codebase

**Strategy:** Eliminate half the code at a time

```python
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

Explain the problem out loud (to a rubber duck, colleague, or yourself). Often, articulating the problem reveals the solution:
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

# ✅ Use item directly
for item in items:
    process(item)
```

### Null/None Handling

```python
# ❌ Crashes if user has no email
email = user.email.lower()

# ✅ Handle None case
email = user.email.lower() if user.email else None
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

```javascript
// ❌ Naive datetime (relies on server local time)
const now = new Date();

// ✅ UTC for storage and backend logic
const nowUTC = new Date().toISOString();

// ✅ Convert to user's timezone only at display layer
const formatter = new Intl.DateTimeFormat('en-US', { timeZone: user.timezone });
const userTime = formatter.format(new Date(nowUTC));
```

### String Encoding

```python
# ❌ Assumes ASCII
text = response.content.decode()  # Crashes on non-ASCII

# ✅ Specify encoding
text = response.content.decode('utf-8', errors='replace')
```

---

## Debugging Tools

### Interactive Debuggers

```python
# Python
breakpoint()  # Python 3.7+

# JavaScript/Node
debugger;
```

**Common Commands:** step over, step into, continue, evaluate (inspect variable values)

### Application Profilers & Toolbars

Most major frameworks have debugging middleware (Django Debug Toolbar, Laravel Debugbar, Rack Mini Profiler).

**What they show:** SQL queries (with EXPLAIN), template rendering time, cache hits/misses, memory usage.

### Browser DevTools

- **Console**: View JS errors, test snippets, inspect variables
- **Network**: View API requests/responses, status codes, request timing
- **Sources**: Set breakpoints, step through code, watch variables
- **Performance**: Record page load, identify slow functions

### Production Debugging

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
```

**Rules for production:**
1. Never use debugger (blocks all requests)
2. Add logging, deploy, observe (don't guess)
3. Reproduce in staging first (if possible)
4. Have rollback plan ready (before making changes)
5. Monitor after changes (watch error rates)

---

## Further Reading

- [Debugging: The 9 Indispensable Rules](https://debuggingrules.com/)
- [Python Debugging with pdb](https://realpython.com/python-debugging-pdb/)
- [Chrome DevTools Documentation](https://developer.chrome.com/docs/devtools/)
