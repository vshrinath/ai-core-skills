# CONVENTIONS.md — Project-Specific Patterns

**Purpose**: This file defines project-specific conventions that AI assistants should follow. Copy this template to your project root and customize for your stack.

---

## Tech Stack

### Backend
- **Framework**: [Django/Flask/FastAPI/Express/Laravel/etc.]
- **Database**: [PostgreSQL/MySQL/SQLite/MongoDB/etc.]
- **ORM**: [Django ORM/SQLAlchemy/Prisma/Eloquent/etc.]
- **API**: [REST/GraphQL/tRPC/etc.]
- **Authentication**: [JWT/Session/OAuth/etc.]

### Frontend
- **Framework**: [React/Vue/Angular/Svelte/etc.]
- **Meta-framework**: [Next.js/Nuxt/SvelteKit/etc.]
- **Styling**: [Tailwind/CSS Modules/Styled Components/etc.]
- **State Management**: [Redux/Zustand/Pinia/etc.]

### Infrastructure
- **Deployment**: [Docker/Vercel/Netlify/AWS/etc.]
- **Database**: [PostgreSQL/MySQL/etc.]
- **Cache**: [Redis/Memcached/etc.]
- **Search**: [Elasticsearch/Meilisearch/etc.]
- **Storage**: [S3/Cloudinary/etc.]

---

## Code Style

### File Naming
```
# Backend (Python example)
snake_case.py
test_snake_case.py

# Frontend (JavaScript example)
PascalCase.tsx (components)
camelCase.ts (utilities)
kebab-case.css (styles)
```

### Import Style
```python
# Python example
from django.db import models
from .models import User
import json
```

```typescript
// TypeScript example
import React from 'react';
import { User } from '@/types';
import { api } from '../lib/api';
```

### Code Formatting
- **Indentation**: [2 spaces/4 spaces/tabs]
- **Line length**: [80/100/120 characters]
- **Quotes**: [single/double quotes]
- **Semicolons**: [required/optional]

---

## Project Structure

```
project-root/
├── [backend-folder]/          # Backend code
│   ├── models/
│   ├── views/
│   ├── serializers/
│   └── tests/
├── [frontend-folder]/         # Frontend code
│   ├── components/
│   ├── pages/
│   ├── lib/
│   └── __tests__/
├── docs/                      # Documentation
├── scripts/                   # Utility scripts
├── .env.example              # Environment variables
├── AGENTS.md                 # AI assistant rules
├── CONVENTIONS.md            # This file
└── README.md
```

---

## Database Conventions

### Model Naming
```python
# Example: Django
class User(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'users'
```

### Migration Naming
```
# Example patterns
0001_initial.py
0002_add_user_email_field.py
0003_create_article_model.py
```

---

## API Conventions

### URL Patterns
```
# REST example
GET    /api/users/           # List users
POST   /api/users/           # Create user
GET    /api/users/{id}/      # Get user
PUT    /api/users/{id}/      # Update user
DELETE /api/users/{id}/      # Delete user
```

### Response Format
```json
{
  "data": {...},
  "meta": {
    "count": 100,
    "page": 1,
    "per_page": 20
  },
  "errors": []
}
```

---

## Testing Conventions

### Test File Location
```
# Backend tests
app/
├── models.py
├── views.py
└── tests/
    ├── test_models.py
    └── test_views.py

# Frontend tests
components/
├── Button.tsx
└── __tests__/
    └── Button.test.tsx
```

### Test Naming
```python
# Python example
class TestUserModel:
    def test_user_creation_with_valid_data(self):
        pass
    
    def test_user_creation_with_invalid_email_raises_error(self):
        pass
```

### Test Data
```python
# Use factories/fixtures
@pytest.fixture
def user():
    return User.objects.create(
        email='test@example.com',
        username='testuser'
    )
```

---

## Environment Variables

### Required Variables
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost/dbname

# API Keys
SECRET_KEY=your-secret-key
API_KEY=your-api-key

# External Services
REDIS_URL=redis://localhost:6379
SEARCH_HOST=http://localhost:9200
```

### Environment Files
- `.env.local` - Local development
- `.env.staging` - Staging environment
- `.env.production` - Production environment
- `.env.example` - Template with fake values

---

## Deployment

### Docker
```dockerfile
# Multi-stage build pattern
FROM node:18-alpine AS builder
# Build steps...

FROM node:18-alpine AS runner
# Runtime steps...
```

### CI/CD
```yaml
# GitHub Actions example
name: CI/CD
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: npm test
```

---

## Error Handling

### Backend Errors
```python
# Example: Django
from rest_framework.views import exception_handler

def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)
    if response is not None:
        custom_response_data = {
            'error': response.data,
            'status_code': response.status_code
        }
        response.data = custom_response_data
    return response
```

### Frontend Errors
```typescript
// Example: React Error Boundary
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }
    return this.props.children;
  }
}
```

---

## Logging

### Log Levels
- **DEBUG**: Detailed information for debugging
- **INFO**: General information about application flow
- **WARNING**: Something unexpected happened
- **ERROR**: Serious problem occurred
- **CRITICAL**: Very serious error occurred

### Log Format
```python
# Example: Structured logging
import logging
import json

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_entry = {
            'timestamp': self.formatTime(record),
            'level': record.levelname,
            'message': record.getMessage(),
            'module': record.module,
        }
        return json.dumps(log_entry)
```

---

## Security

### Authentication
```python
# Example: JWT token validation
from rest_framework_simplejwt.authentication import JWTAuthentication

class CustomJWTAuthentication(JWTAuthentication):
    def authenticate(self, request):
        # Custom authentication logic
        pass
```

### Input Validation
```python
# Example: Serializer validation
from rest_framework import serializers

class UserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()
    
    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists")
        return value
```

---

## Performance

### Database Queries
```python
# Use select_related for ForeignKey
users = User.objects.select_related('profile').all()

# Use prefetch_related for ManyToMany
users = User.objects.prefetch_related('groups').all()

# Avoid N+1 queries
articles = Article.objects.select_related('author').all()
```

### Caching
```python
# Example: Redis caching
from django.core.cache import cache

def get_user_profile(user_id):
    cache_key = f'user_profile_{user_id}'
    profile = cache.get(cache_key)
    if profile is None:
        profile = UserProfile.objects.get(user_id=user_id)
        cache.set(cache_key, profile, timeout=3600)
    return profile
```

---

## Known Intentional Quirks

### Why We Do X Instead of Y
```python
# Example: Custom user model
# We use email as username because our users don't have usernames
AUTH_USER_MODEL = 'accounts.User'

class User(AbstractBaseUser):
    email = models.EmailField(unique=True)
    USERNAME_FIELD = 'email'
```

### Temporary Workarounds
```python
# TODO: Remove this hack when Django 5.0 is released
# Workaround for: https://github.com/django/django/issues/12345
if settings.DEBUG:
    # Temporary fix for development
    pass
```

---

## What Requires Asking Before Doing

### Always Ask Before
- Modifying database schema (migrations)
- Adding new dependencies
- Changing authentication/authorization logic
- Modifying CI/CD pipeline
- Changing environment variables in production

### Never Do Without Permission
- Deleting files or database tables
- Modifying production configuration
- Changing API contracts (breaking changes)
- Installing global packages
- Modifying security settings

---

## AI Assistant Specific Notes

### Preferred Patterns
- Use type hints in Python
- Prefer composition over inheritance
- Write tests before implementation (TDD)
- Use environment variables for configuration
- Follow REST conventions for APIs

### Avoid These Patterns
- Global variables
- Hardcoded configuration
- Circular imports
- Deep inheritance hierarchies
- Monolithic functions (>50 lines)

---

## Project-Specific Skills

### Load These Skills for This Project
```
# Core workflow
@pm → @ux → @arch → @dev → @guard → @qa → @ops

# Framework-specific skills (customize path)
@dev-django        # .kiro/skills/coding/dev-django.md
@ops-aws          # .kiro/skills/ops/ops-aws.md
```

### Custom Skills Location
- Project-specific skills: `.kiro/skills/`
- Framework overrides: `.kiro/skills/coding/`
- Deployment overrides: `.kiro/skills/ops/`

---

## Customization Instructions

1. **Replace all `[bracketed]` placeholders** with your actual tech stack
2. **Update code examples** to match your framework and patterns
3. **Add project-specific sections** as needed
4. **Remove sections** that don't apply to your project
5. **Keep this file updated** as conventions evolve

This file should be the single source of truth for how AI assistants should work with your specific project.