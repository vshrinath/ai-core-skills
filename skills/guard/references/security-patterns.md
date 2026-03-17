# @guard — Common Security Patterns

## SQL Injection

```javascript
// ❌ Vulnerable
const query = `SELECT * FROM users WHERE username = '${username}'`;
db.query(query);

// ✅ Safe (parameterized)
db.query("SELECT * FROM users WHERE username = ?", [username]);
```

## XSS (Cross-Site Scripting)

```javascript
// ❌ Vulnerable
element.innerHTML = userInput;

// ✅ Safe (escaped)
element.textContent = userInput;
// Or use framework escaping (React, Vue, HTML templates)
```

## CSRF (Cross-Site Request Forgery)

```javascript
// ❌ Missing CSRF protection
app.post('/api/account', (req, res) => {
    deleteUserAccount(req.user.id);
});

// ✅ CSRF protected
app.post('/api/account', csrfProtection, (req, res) => {
    deleteUserAccount(req.user.id);
});
```

## Authentication Bypass

```javascript
// ❌ No authentication check
app.get('/api/users/:id/profile', async (req, res) => {
    const user = await db.users.findById(req.params.id);
    return res.json(user);
});

// ✅ Authentication & Authorization required
app.get('/api/users/:id/profile', requireAuth, async (req, res) => {
    if (req.user.id !== req.params.id && !req.user.isAdmin) {
        return res.status(403).json({ error: 'Forbidden' });
    }
    const user = await db.users.findById(req.params.id);
    return res.json(user);
});
```

---

## Further Reading

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
- [Code Review Best Practices](https://google.github.io/eng-practices/review/)
