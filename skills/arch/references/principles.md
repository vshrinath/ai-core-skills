# @arch — Production-Grade Design Principles

**Apply these when designing systems for production or when prototypes transition to real users. Skip during early validation unless explicitly building for scale.**

## When to Apply
- ✅ Production systems
- ✅ Prototypes with real user data
- ✅ Shared infrastructure (affects other teams)
- ❌ Throwaway prototypes
- ❌ Local experiments
- ❌ Proof-of-concept demos

---

## 1. Async-First for External Dependencies

**Never block user requests for operations touching databases, file systems, or external APIs.**

Pattern: User action → Acknowledge → Queue background task

Examples:
- User clicks "Submit" → Return 202 Accepted → Background worker processes
- Badge award triggered → Event fired → Worker grants badge asynchronously
- File upload → Store reference → Background task processes file

**When to apply:**
- Operations taking >2 seconds
- Systems with >100 concurrent users
- Any operation that could fail due to external service downtime

**Prototype exception:** Synchronous is fine for early validation with <10 users.

---

## 2. Idempotent Operations

**Every system change must be safely re-runnable without side effects.**

Pattern: Check state → Already done? Exit 0 : Do work

Implementation:
- Use upserts: `INSERT ... ON CONFLICT UPDATE`
- Add unique constraints on natural keys
- Background tasks check completion before starting work
- Exit code 0 when "already complete" (not an error)

**When to apply:**
- Background jobs and cron tasks
- Retry logic and queue consumers
- Migration scripts
- Any operation that might run twice (network failures, manual re-runs)

**Prototype exception:** If you're dropping the database daily, this can wait.

---

## 3. Observability as a Feature

**Build monitoring into feature delivery. Don't wait for complaints.**

Pattern: Structured logging + Metrics + Alerting thresholds

Implementation:
- Use structured logging (JSON) for all background tasks and critical paths
- Log context for debugging without SSH: user ID, request ID, input parameters
- Define success/failure metrics before building the feature
- Set alerting thresholds: "Rule X failed 5 times in 10 minutes"

**When to apply:**
- Anything running unattended
- Systems serving external users
- Background workers and scheduled tasks
- Critical user flows (auth, payments, data loss scenarios)

**Prototype exception:** `print()` and manual testing are fine until you have users you can't directly observe.

### Request ID Propagation (Distributed Tracing)

**Every request should have a unique ID that flows through all systems for debugging.**

Pattern: Generate or accept request ID → Propagate through logs and services → Return in response

**Implementation (Backend - Python/Django example):**
```python
# middleware/logging_middleware.py
import uuid
import contextvars
from django.utils.deprecation import MiddlewareMixin

request_id_context = contextvars.ContextVar('request_id', default='-')

class RequestLoggingMiddleware(MiddlewareMixin):
    def process_request(self, request):
        request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
        request_id_context.set(request_id)
        request.id = request_id

    def process_response(self, request, response):
        if hasattr(request, 'id'):
            response['X-Request-ID'] = request.id
        return response

class RequestContextLogFilter(logging.Filter):
    def filter(self, record):
        record.request_id = request_id_context.get()
        return True
```

**Implementation (Frontend - Next.js example):**
```typescript
// lib/api/client.ts
import { v4 as uuidv4 } from 'uuid';

async function apiCall(url: string, options: RequestInit = {}) {
  const requestId = uuidv4();
  const response = await fetch(url, {
    ...options,
    headers: { ...options.headers, 'X-Request-ID': requestId },
  });
  return response;
}
```

**When to apply:**
- Multi-service architectures
- Production systems with >100 users
- Any system where debugging requires correlating logs across services

**Prototype exception:** Single-service apps with <10 users can skip this.

---

## 4. Zero-Trust Secrets

**Treat your server like a hostile environment. Hardcode nothing.**

Pattern: Secrets management + Least privilege

Implementation:
- No hardcoded credentials, API keys, or connection strings—not even in comments
- Use environment variables as minimum; prefer secrets management (Vault, Docker Secrets)
- Database connections use least-privilege users, never root/admin
- Secrets rotatable without code changes
- Each service gets only the secrets it needs

**When to apply:**
- Anything committed to version control
- Anything deployed to shared infrastructure
- Any system handling user data or external integrations

**Prototype exception:** `.env` files are adequate for local-only development. Upgrade before first deploy.

---

## 5. Build Sequence: Logic → API → UI

**Applies to all projects, all stages. No exceptions.**

Pattern: Core logic testable via CLI/tests → Integration layer → Visual layer

Sequence:
1. **Core Logic**: Business rules, data transformations, validation—runnable via unit tests or CLI
2. **API/Integration**: How does this logic talk to the rest of the world? REST endpoints, GraphQL resolvers, message handlers
3. **UI/Theme**: The visual skin—forms, buttons, styling

**Red flag:** Writing CSS before you have tests for the underlying logic.

**Why this matters:**
- Tight feedback loops (test logic without clicking through UI)
- Logic is reusable across interfaces (web, mobile, CLI, API)
- UI changes don't require retesting business logic
- Forces clear separation of concerns
