---
name: api-design
description: Designs or reviews API endpoints, request/response contracts, and versioning. Ensures consistency, clarity, and backward compatibility. WHEN to use it - designing new API endpoints, versioning existing APIs, reviewing API changes, documenting API behavior, or planning deprecation.
license: MIT
metadata:
  category: coding
  handoff-from:
    - arch
  handoff-to:
    - dev
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @api-design — API Design Principles

**Philosophy:** APIs are contracts. Design for clarity, consistency, and evolution.

**Before producing any output, read `CONVENTIONS.md` for stack, code style, and project-specific patterns.**

## When to invoke
- Designing new API endpoints
- Versioning existing APIs
- Reviewing API changes
- Documenting API behavior
- Planning API deprecation

## Responsibilities
- Design clear, consistent API interfaces
- Plan for backward compatibility
- Define error response formats
- Document API contracts
- Consider versioning strategy

---

## Core Principles

### 1. Consistency
Use consistent patterns across all endpoints. Same URL structure, same HTTP methods, same response shapes.

### 2. Resource-Oriented
URLs represent resources, not actions. Use nouns, not verbs. HTTP methods express the action.

### 3. HTTP Methods
- `GET` — Retrieve (safe, idempotent)
- `POST` — Create (not idempotent)
- `PUT` — Replace (idempotent)
- `PATCH` — Partial update
- `DELETE` — Remove (idempotent)

### 4. Meaningful Status Codes
- `200` OK, `201` Created, `204` No Content
- `400` Bad Request, `401` Unauthorized, `403` Forbidden, `404` Not Found, `409` Conflict, `422` Validation Failed
- `500` Server Error, `502` Bad Gateway, `503` Unavailable

---

## Detailed Patterns

Load `references/patterns.md` for:
- URL design examples (naming, nesting, query parameters)
- Request/response JSON formats with examples
- Error handling with standard error format and error codes
- Versioning strategies and backward compatibility rules
- Authentication methods (JWT, API key, OAuth, session)
- Rate limiting headers and responses
- OpenAPI/Swagger documentation template and curl examples

---

## Best Practices

1. Use nouns, not verbs in URLs
2. Return the created resource on POST (201 with body)
3. Support partial updates via PATCH
4. Use ISO 8601 for dates (`2024-02-19T10:30:00Z`)
5. Always paginate list endpoints
6. Use HTTPS only
7. Version from day one (`/api/v1/`)
8. Use consistent ID format across resources
9. Consistent response structure for both success and errors

---

## Artifact

Document the API contract inline in `tech-spec.md` (from `@arch`) or as a standalone OpenAPI/Swagger spec. Include:
- Endpoint list with HTTP methods
- Request/response schemas
- Error codes and formats
- Versioning notes
- Authentication requirements
