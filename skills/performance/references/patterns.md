# @performance — Patterns & Reference

## API Performance

### Parallel vs Sequential Requests

```
# Pseudocode — applies to any language
# ❌ Sequential (total time = sum of all requests)
user = fetch_user(id)
posts = fetch_posts(user.id)
comments = fetch_comments(user.id)

# ✅ Parallel (total time = slowest request)
user, posts, comments = await_all([
    fetch_user(id),
    fetch_posts(id),
    fetch_comments(id)
])
```

### Pagination

Always paginate large result sets. Never return unbounded lists.

```
# Cursor-based pagination (preferred for real-time data)
articles = Article.filter(id__gt=cursor).limit(20)

# Offset-based pagination (simpler, but slower for large offsets)
articles = Article.offset(page * page_size).limit(page_size)
```

### Background Jobs

Move slow operations out of the request/response cycle:
- Email sending
- Image processing
- Report generation
- External API calls that can be async
- Bulk data imports

---

## Database Performance

### N+1 Query Problem

**Problem:** Executing one query per item in a loop instead of one query for all items.

```
# ❌ N+1
articles = load_all_articles()
for article in articles:
    print(article.author.name)  # Hits DB every iteration
```

**Fix:** Use eager loading (JOIN or separate batch query).

```
# ✅ Eager loading
articles = load_articles_with_authors()  # 1 query (JOIN)
for article in articles:
    print(article.author.name)  # No additional query
```

**Rule of thumb:**
- For `has-one` / `belongs-to` relations → JOIN (SQL `LEFT JOIN`)
- For `has-many` / `many-to-many` → separate batched query

### Query Optimization Patterns

```
# Load only the fields you need (pseudocode)
articles = Article.select('id', 'title', 'published_date')  # Not SELECT *

# Use count at the database level
count = Article.count()  # Not len(Article.all())

# Use existence check, not count
exists = Article.exists(slug=slug)  # Not Article.count(slug=slug) > 0

# Aggregate at the database level
total_views = Article.sum('views')  # Not sum(a.views for a in articles)
```

### Connection Pooling

Keep database connections alive across requests. Configure `CONN_MAX_AGE` / `pool_size` in your framework. Most production apps should have this enabled.

---

## Caching Strategy

### When to Cache

**Cache when:**
- Data changes infrequently (< once per hour)
- Computation or query is expensive (> 100ms)
- Data is accessed frequently (> 10 requests/minute per key)
- External API calls — always cache with a TTL

**Don't cache when:**
- Data changes frequently or is user-specific per-request
- Computation is cheap (< 10ms)
- Cache invalidation logic would be more complex than the problem
- Data must be fresh (financial data, inventory)

### Cache Layers

```
┌─────────────────┐
│  Browser Cache  │  Static assets — long TTL, versioned URLs (see @frontend-perf)
└────────┬────────┘
         │
┌────────▼────────┐
│   CDN Cache     │  Static assets + public API responses — medium TTL
└────────┬────────┘
         │
┌────────▼────────┐
│  App Cache      │  Database query results, computed values — short TTL
│  (Redis/Memcached/in-memory)
└────────┬────────┘
         │
┌────────▼────────┐
│    Database     │  Source of truth
└─────────────────┘
```

### Cache Invalidation Rules

- Always set a TTL — never cache without expiry
- Use user-specific cache keys: `user:{id}:profile`, not `user:profile`
- Invalidate on write: when data changes, delete or update relevant cache keys
- Prefer shorter TTLs + stale-while-revalidate over long TTLs serving stale data

---

## Framework-Specific Notes

### Django (Python)

```python
# Eager loading
articles = Article.objects.select_related('author')       # FK/OneToOne (JOIN)
articles = Article.objects.prefetch_related('tags')       # M2M/reverse FK (separate query)

# Load only needed fields
articles = Article.objects.only('id', 'title', 'published_date')
articles = Article.objects.defer('content')  # Skip large field

# Aggregate at DB level
from django.db.models import Sum, Count
total = Article.objects.aggregate(Sum('views'))['views__sum']
count = Article.objects.count()
exists = Article.objects.filter(slug=slug).exists()

# Caching
from django.core.cache import cache
result = cache.get('trending')
if result is None:
    result = compute_trending()
    cache.set('trending', result, 3600)  # 1 hour TTL

# Connection pooling
DATABASES = {'default': {'CONN_MAX_AGE': 600, 'CONN_HEALTH_CHECKS': True}}
```

---

## Further Reading

- [Django Database Optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/)
- [Use The Index, Luke](https://use-the-index-luke.com/) — database index deep dive
- [High Performance Browser Networking](https://hpbn.co/)
