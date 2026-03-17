# @api-design — Patterns & Reference

## URL Design

### Resource Naming

```
✅ Good
/api/articles/
/api/users/
/api/comments/
/api/articles/{id}/comments/

❌ Bad
/api/article/          # Use plural
/api/get-articles/     # Don't use verbs
/api/Articles/         # Use lowercase
/api/article_list/     # Use hyphens, not underscores
```

### Nested Resources

```
✅ Good (shallow nesting)
/api/articles/{id}/comments/
/api/users/{id}/articles/

❌ Bad (deep nesting)
/api/users/{id}/articles/{id}/comments/{id}/replies/

✅ Better (flat with filters)
/api/comments/?article_id={id}
/api/replies/?comment_id={id}
```

### Query Parameters

```
Filtering:  /api/articles/?category=tech&status=published
Sorting:    /api/articles/?sort=-published_date
Pagination: /api/articles/?page=2&page_size=20
Search:     /api/articles/?q=django
Fields:     /api/articles/?fields=id,title,author
```

---

## Request/Response Format

### Request Body (POST/PUT/PATCH)

```json
POST /api/articles/
Content-Type: application/json

{
  "title": "My Article",
  "content": "Article content here",
  "category": "tech",
  "tags": ["django", "python"],
  "published": true
}
```

### Response Format

```json
// Success (200 OK)
{
  "id": 123,
  "title": "My Article",
  "created_at": "2024-02-19T10:30:00Z",
  "updated_at": "2024-02-19T10:30:00Z",
  "author": {
    "id": 456,
    "name": "John Doe"
  }
}

// Error (400 Bad Request)
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "title": ["This field is required"],
      "category": ["Invalid category"]
    }
  }
}

// Error (404 Not Found)
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Article not found"
  }
}
```

### Pagination Response

```json
{
  "count": 150,
  "next": "/api/articles/?page=3&page_size=20",
  "previous": "/api/articles/?page=1&page_size=20",
  "results": [ ... ]
}
```

---

## Error Handling

### Standard Error Format

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": {},
    "request_id": "abc123"
  }
}
```

### Error Codes (Python example)

```python
class ErrorCode:
    VALIDATION_ERROR = "VALIDATION_ERROR"
    NOT_FOUND = "NOT_FOUND"
    UNAUTHORIZED = "UNAUTHORIZED"
    FORBIDDEN = "FORBIDDEN"
    RATE_LIMIT_EXCEEDED = "RATE_LIMIT_EXCEEDED"
    INTERNAL_ERROR = "INTERNAL_ERROR"

return Response({
    "error": {
        "code": ErrorCode.VALIDATION_ERROR,
        "message": "Invalid input data",
        "details": serializer.errors
    }
}, status=400)
```

---

## Versioning

### URL Versioning (Recommended)

```
/api/v1/articles/
/api/v2/articles/
```

**Pros:** Clear, easy to route and deprecate. **Cons:** URL changes between versions.

### When to Version

```
✅ Version when:
- Breaking changes (removing fields, changing types)
- Major behavior changes
- Incompatible authentication changes

❌ Don't version for:
- Adding new optional fields
- Adding new endpoints
- Bug fixes or performance improvements
```

### Backward Compatibility

```json
// ✅ Backward compatible (add optional field — old clients ignore it)
{ "id": 123, "title": "Article", "new_field": "value" }

// ❌ Breaking change (remove field — old clients break)
{ "id": 123 }

// ❌ Breaking change (type change — was number, now string)
{ "id": "123", "title": "Article" }
```

---

## Authentication & Authorization

### Authentication Methods

```
1. Token-based (JWT):  Authorization: Bearer <token>
2. API Key:            X-API-Key: <key>
3. OAuth 2.0:          Authorization: Bearer <access_token>
4. Session (cookies):  Cookie: sessionid=<id>
```

### Permission Levels

```python
# Public (no auth)
GET /api/articles/

# Authenticated (any logged-in user)
POST /api/articles/

# Owner only
PUT /api/articles/{id}/  # Only if request.user == article.author

# Admin only
DELETE /api/users/{id}/  # Only if request.user.is_admin
```

---

## Rate Limiting

### Response Headers

```
HTTP/1.1 200 OK
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1613592000

# When exceeded (429 Too Many Requests)
HTTP/1.1 429 Too Many Requests
Retry-After: 3600
{
  "error": { "code": "RATE_LIMIT_EXCEEDED", "message": "Rate limit exceeded. Try again in 1 hour." }
}
```

---

## Documentation (OpenAPI/Swagger)

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0

paths:
  /api/articles/:
    get:
      summary: List articles
      parameters:
        - name: page
          in: query
          schema: { type: integer }
        - name: category
          in: query
          schema: { type: string }
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: object
                properties:
                  count: { type: integer }
                  results:
                    type: array
                    items: { $ref: '#/components/schemas/Article' }
```

### Curl Examples

```bash
# List articles
curl -X GET "https://api.example.com/api/articles/?page=1&category=tech"

# Create article
curl -X POST "https://api.example.com/api/articles/" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"title": "My Article", "content": "Content", "category": "tech"}'
```

---

## Common Mistakes

### ❌ Exposing Internal IDs / inconsistent structure

```json
{ "database_id": 456, "user_id": 789 }    // Don't expose internal IDs
```

```json
// ✅ Use consistent prefixed IDs
{ "id": "art_123", "author": { "id": "usr_456" } }
```

### ❌ No Pagination

```python
GET /api/articles/  # Returns all 10,000 articles
```

```python
# ✅ Always paginate
GET /api/articles/?page=1&page_size=20
```

---

## Further Reading

- [REST API Design Best Practices](https://restfulapi.net/)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [OpenAPI Specification](https://swagger.io/specification/)
