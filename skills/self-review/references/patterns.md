# @self-review — Common Findings & Anti-Patterns

## Common Self-Review Findings

### Security Issues

```javascript
// Found: Hardcoded secret
const API_KEY = "sk-1234567890";

// Fixed: Use environment variable
const API_KEY = process.env.API_KEY;
if (!API_KEY) {
    throw new Error("API_KEY environment variable required");
}
```

### Performance Issues

```javascript
// Found: N+1 query
const articles = await db.articles.findMany();
for (const article of articles) {
    const author = await db.authors.findUnique({ where: { id: article.authorId } });
    console.log(author.name); // Hits DB for every article
}

// Fixed: Eager loading
const articles = await db.articles.findMany({ include: { author: true } });
for (const article of articles) {
    console.log(article.author.name); // No additional queries
}
```

### Logic Errors

```javascript
// Found: Off-by-one error
for (let i = 0; i < items.length - 1; i++) {
    process(items[i]); // Misses last item!
}

// Fixed: Correct range / direct iteration
for (const item of items) {
    process(item);
}
```

### Missing Error Handling

```javascript
// Found: No error handling
const data = JSON.parse(responseText);

// Fixed: Handle errors
try {
    const data = JSON.parse(responseText);
    return data;
} catch (error) {
    logger.error(`Invalid JSON response: ${error.message}`);
    return null;
}
```

---

## Self-Review Anti-Patterns

### ❌ "It works on my machine"
- Doesn't test in clean environment
- Doesn't check if dependencies are documented
- Assumes everyone has same setup

### ✅ Test in Clean Environment
- Run in Docker container
- Check dependencies are in requirements.txt
- Verify setup instructions work

---

### ❌ "Tests pass, ship it"
- Doesn't read the code
- Doesn't check for obvious issues
- Doesn't verify edge cases

### ✅ Read Your Code
- Review every line changed
- Check for common mistakes
- Verify edge cases are handled

---

### ❌ "I'll fix it later"
- Leaves TODO comments without tickets
- Leaves debug code (console.log, print)
- Leaves commented-out code

### ✅ Fix It Now
- Remove TODOs or create tickets
- Remove debug code
- Remove commented-out code

---

## Further Reading

- [Code Review Best Practices](https://google.github.io/eng-practices/review/)
- [Self-Review Checklist](https://github.com/mgreiler/code-review-checklist)
- [The Art of Readable Code](https://www.oreilly.com/library/view/the-art-of/9781449318482/)
- [Clean Code](https://www.oreilly.com/library/view/clean-code-a/9780136083238/)
