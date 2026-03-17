# @guard — Code Review Checklist

## Security
- [ ] No hardcoded secrets or API keys
- [ ] User input is validated and sanitized
- [ ] SQL injection prevented (use parameterized queries)
- [ ] XSS prevented (escape output, use framework protections)
- [ ] CSRF protection enabled
- [ ] Authentication required for protected endpoints
- [ ] Authorization checked (user can access this resource?)
- [ ] Sensitive data encrypted (passwords, tokens)
- [ ] No secrets in logs or error messages
- [ ] Rate limiting on public endpoints

## Correctness
- [ ] Logic is correct and handles edge cases
- [ ] No off-by-one errors
- [ ] Null/None values handled
- [ ] Error cases handled (don't assume success)
- [ ] Race conditions prevented
- [ ] Timezone handling correct
- [ ] String encoding handled (UTF-8)
- [ ] Floating point precision considered (use Decimal for money)

## Performance
- [ ] No N+1 queries (use select_related/prefetch_related) — backend
- [ ] Indexes exist on filtered/sorted columns — backend
- [ ] Large datasets paginated — backend
- [ ] Expensive operations cached — backend
- [ ] Database queries optimized — backend
- [ ] No unnecessary data loaded — backend
- [ ] Images optimized (modern formats, lazy loading) — frontend (see `@frontend-perf`)
- [ ] Bundle size reasonable — frontend (see `@frontend-perf`)
- [ ] No unnecessary re-renders — frontend (see `@frontend-perf`)

## Code Quality
- [ ] Functions are small and focused (< 50 lines)
- [ ] Variables and functions have clear names
- [ ] No magic numbers (use named constants)
- [ ] No deep nesting (< 3 levels)
- [ ] No duplicated code
- [ ] Comments explain "why", not "what"
- [ ] No commented-out code
- [ ] No TODO comments without tickets

## Testing
- [ ] Tests exist for new functionality
- [ ] Tests cover edge cases
- [ ] Tests are readable and maintainable
- [ ] No flaky tests
- [ ] Test data is realistic
- [ ] Mocks are used appropriately

## Error Handling
- [ ] Errors fail loud, not silent (Rule 5)
- [ ] No bare except/catch blocks
- [ ] Error messages are helpful
- [ ] Errors are logged appropriately
- [ ] User-facing errors are friendly

## Database
- [ ] Migrations are backward-compatible
- [ ] No data loss in migrations
- [ ] Indexes added for new queries
- [ ] Foreign key constraints defined
- [ ] on_delete behavior specified
- [ ] No raw SQL without justification

## API Design
- [ ] Consistent with existing endpoints
- [ ] Proper HTTP methods used
- [ ] Appropriate status codes returned
- [ ] Error responses follow standard format
- [ ] Backward compatible (or versioned)
- [ ] Documented (OpenAPI/Swagger)

## Frontend
- [ ] No console.log in production code
- [ ] Accessibility considered (ARIA labels, keyboard nav)
- [ ] Loading states shown
- [ ] Error states handled
- [ ] Mobile responsive
- [ ] Images optimized
- [ ] No hardcoded text (use i18n)

## Documentation
- [ ] README updated if needed
- [ ] API documentation updated
- [ ] Complex logic explained in comments
- [ ] Migration notes if schema changed
- [ ] CHANGELOG.md updated

---

## Review Severity Levels

### Critical (Must Fix)
- Security vulnerabilities
- Data loss risks
- Breaking changes without migration
- Hardcoded secrets

### High (Should Fix)
- Performance issues (N+1 queries, missing indexes, large bundle sizes)
- Missing error handling
- Incorrect logic
- Missing tests for critical paths

### Medium (Consider Fixing)
- Code duplication
- Unclear naming
- Missing documentation
- Minor performance issues

### Low (Nice to Have)
- Code style inconsistencies
- Minor refactoring opportunities
- Additional test coverage

---

## When to Approve

**Approve when:**
- All critical and high severity issues resolved
- Tests pass and cover new functionality
- Code follows project conventions
- Security concerns addressed
- Performance is acceptable
- Documentation updated

**Request changes when:**
- Critical or high severity issues exist
- Tests are missing or failing
- Security vulnerabilities present
- Breaking changes without migration plan
- Code is unclear or overly complex

**Comment (no approval needed) when:**
- Low severity issues only
- Suggestions for future improvements
- Questions about approach
