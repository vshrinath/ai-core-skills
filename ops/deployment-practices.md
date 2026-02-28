# Deployment Practices — Universal Principles

**Philosophy:** Build artifacts should be deterministic, reproducible, and fail fast when misconfigured.

## When to use this guide
- Setting up Docker builds for any language/framework
- Establishing dependency management practices
- Configuring environment variables and secrets
- Optimizing build performance and image size
- Ensuring production-ready container security

## Core Principles

### 1. Multi-Stage Docker Builds

**Why:** Separate build-time dependencies from runtime dependencies. Reduces image size by 50-80%, improves security, faster deployments.

**Pattern:**
```dockerfile
# Stage 1: Builder — includes compilers, build tools
FROM base-image AS builder
RUN install build dependencies
COPY dependency-lock-file .
RUN compile/install dependencies

# Stage 2: Runtime — only runtime libraries
FROM base-image AS runtime
RUN install runtime dependencies only
COPY --from=builder /compiled-artifacts /app
COPY application-code /app
```

**What to exclude from runtime:**
- Compilers (gcc, g++, build-essential)
- Build tools (make, cmake, pkg-config)
- Development headers (-dev packages)
- Package managers used only for building

**What to include in runtime:**
- Shared libraries needed by compiled dependencies
- Runtime interpreters (python, node, php)
- Application code
- Configuration files

---

### 2. Dependency Locking

**Why:** Prevent "works on my machine" issues. Transitive dependencies can update between builds, breaking production.

**Pattern:**
1. **Source file** (human-maintained): Lists direct dependencies with loose version constraints
2. **Lock file** (machine-generated): Pins exact versions of all dependencies (direct + transitive)
3. **Never edit lock files manually**
4. **Commit lock files to version control**

**Workflow:**
```bash
# 1. Edit source file (add/remove/update dependencies)
# 2. Regenerate lock file
# 3. Commit both files
# 4. CI/CD installs from lock file only
```

**When to regenerate lock files:**
- Adding a new dependency
- Updating a dependency version
- Security vulnerability in transitive dependency
- Quarterly maintenance (update all dependencies)

---

### 3. Environment Variable Validation

**Why:** Fail fast at startup if critical configuration is missing. Silent fallbacks hide problems until production breaks.

**Pattern:**
```python
# At application startup (settings.py, config.php, etc.)
REQUIRED_VARS = ['DATABASE_URL', 'SECRET_KEY', 'API_KEY']

for var in REQUIRED_VARS:
    if not os.environ.get(var):
        raise ValueError(f"{var} environment variable is not set")
```

**Rules:**
- Required variables: Crash if missing (no defaults)
- Optional variables: Provide sensible defaults with comments
- Never hardcode secrets or environment-specific values
- Document all variables in `.env.example`

**Variable naming convention:**
```
SERVICE_FEATURE_DETAIL

Examples:
DATABASE_URL
REDIS_CACHE_URL
SEARCH_API_KEY
STORAGE_BUCKET_NAME
EMAIL_SMTP_HOST
```

---

### 4. .dockerignore Optimization

**Why:** Faster builds, smaller context transfers, prevents leaking secrets into images.

**What to exclude:**
- Version control (`.git/`, `.gitignore`)
- IDE artifacts (`.vscode/`, `.idea/`)
- Language caches (`__pycache__/`, `node_modules/`, `vendor/`)
- Build artifacts (`dist/`, `build/`, `.next/`)
- Test files and coverage reports
- Documentation that's not needed at runtime
- Local environment files (`.env`, `.env.local`)
- Logs and temporary files

**Pattern:**
```dockerignore
# VCS
.git
.gitignore

# Language caches
__pycache__/
*.pyc
node_modules/

# Build artifacts
dist/
build/

# Environment
.env
.env.local

# Docs (unless needed at runtime)
docs/
*.md
```

---

### 5. Non-Root Container User

**Why:** Security best practice. Limits damage if container is compromised.

**Pattern:**
```dockerfile
# Create non-root user
RUN useradd -ms /bin/bash appuser

# Set ownership of application files
COPY --chown=appuser:appuser . /app

# Switch to non-root user
USER appuser

# Application runs as appuser, not root
```

**What this prevents:**
- Privilege escalation attacks
- Accidental modification of system files
- Container breakout exploits

---

### 6. Settings Hierarchy

**Why:** Avoid duplicating configuration. Clear separation between environments.

**Pattern:**
```
settings/
├── base.py          # Shared settings, env var parsing
├── development.py   # Local dev overrides
├── staging.py       # Staging overrides
└── production.py    # Production overrides
```

**Base settings:**
- Environment variable parsing helpers
- Required variable validation
- Shared configuration (installed apps, middleware)

**Environment-specific settings:**
- Import base settings
- Override only what differs (DEBUG, ALLOWED_HOSTS, logging)
- Never duplicate base configuration

---

### 7. Reproducible Dependency Compilation

**Why:** Dependencies compiled on macOS may not work on Linux production. Compile in the same environment as production.

**Pattern:**
Use Docker to compile lock files, ensuring same OS/Python/tools as production:

```bash
# Compile dependencies in ephemeral container
docker run --rm -v "$(pwd):/app" -w /app python:3.11-slim bash -c \
  "pip install pip-tools && pip-compile requirements.in"
```

**Benefits:**
- Same Python version as production
- Same OS (Linux) as production
- Same system libraries as production
- No "compiled on Mac, deployed to Linux" issues

---

### 8. Health Checks

**Why:** Container orchestrators need to know if your app is healthy. Restart unhealthy containers automatically.

**Pattern:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1
```

**What to check:**
- HTTP endpoint responds (200 OK)
- Database connection works
- Critical external services reachable
- Application is ready to serve traffic

---

### 9. Explicit Dependency Versions in Source Files

**Why:** Avoid breaking changes from major version updates. Control when you upgrade.

**Pattern:**
```
# Good: Explicit major version constraint
Django>=4.2,<5.0
requests>=2.28,<3.0

# Bad: Unconstrained (any version)
Django
requests

# Bad: Overly specific (defeats lock file purpose)
Django==4.2.28
```

**Rules:**
- Pin major version, allow minor/patch updates
- Lock file handles exact versions
- Update major versions deliberately, with testing

---

### 10. Separate Build and Runtime Dependencies

**Why:** Development tools shouldn't be in production. Smaller images, fewer vulnerabilities.

**Pattern:**
- **Build dependencies:** Needed to compile/build (compilers, build tools)
- **Runtime dependencies:** Needed to run the application
- **Development dependencies:** Needed for local development only (linters, test frameworks)

**Example split:**
```
# Build: gcc, make, python-dev
# Runtime: python, libpq (postgres client library)
# Development: pytest, black, mypy
```

---

## Language-Specific Implementations

See language-specific guides for detailed examples:
- [Python/Django](./deploy-python-django.md)
- [PHP/Composer](./deploy-php-composer.md) — Add when needed
- [Node.js/npm](./deploy-nodejs-npm.md) — Add when needed

---

## Checklist: Production-Ready Dockerfile

- [ ] Multi-stage build (builder + runtime)
- [ ] Dependencies installed from lock file
- [ ] .dockerignore excludes unnecessary files
- [ ] Non-root user created and used
- [ ] Health check defined
- [ ] Environment variables validated at startup
- [ ] No secrets hardcoded in image
- [ ] Build dependencies excluded from runtime stage
- [ ] Image size optimized (< 500MB for most apps)
- [ ] Reproducible builds (same inputs = same output)

---

## Common Mistakes

### ❌ Installing build tools in runtime stage
```dockerfile
FROM python:3.11
RUN apt-get install gcc build-essential  # Don't do this
RUN pip install -r requirements.txt
```

### ✅ Use multi-stage build
```dockerfile
FROM python:3.11 AS builder
RUN apt-get install gcc build-essential
RUN pip install -r requirements.txt

FROM python:3.11 AS runtime
COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
```

---

### ❌ No dependency locking
```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt  # Versions can drift
```

### ✅ Use lock file
```dockerfile
COPY requirements.txt .  # Generated from requirements.in via pip-compile
RUN pip install --no-deps -r requirements.txt  # Exact versions only
```

---

### ❌ Silent fallback for missing config
```python
API_KEY = os.environ.get('API_KEY', 'default-key-12345')
```

### ✅ Fail fast
```python
API_KEY = os.environ.get('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY environment variable is required")
```

---

### ❌ Running as root
```dockerfile
COPY . /app
CMD ["python", "app.py"]  # Runs as root
```

### ✅ Non-root user
```dockerfile
RUN useradd -ms /bin/bash appuser
USER appuser
CMD ["python", "app.py"]  # Runs as appuser
```

---

## Further Reading

- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [12-Factor App: Config](https://12factor.net/config)
- [12-Factor App: Dependencies](https://12factor.net/dependencies)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
