# CONVENTIONS.md — Project-Specific Patterns

**Purpose**: Defines project-specific conventions that AI assistants should follow. Customize this file for your stack before using the factory. It is loaded on every session start alongside `AGENTS.md`.

> **How to use**: Replace every `[bracketed]` placeholder with your actual choices. Remove sections that don't apply. The more specific this file is, the more accurately the factory's skills will operate.

---

## Tech Stack

### Backend
- **Framework**: [Django / Flask / FastAPI / Express / Laravel]
- **Database**: [PostgreSQL / MySQL / SQLite / MongoDB]
- **ORM**: [Django ORM / SQLAlchemy / Prisma / Eloquent]
- **API style**: [REST / GraphQL / tRPC]
- **Authentication**: [JWT / Session / OAuth]

### Frontend
- **Framework**: [React / Vue / Angular / Svelte]
- **Meta-framework**: [Next.js / Nuxt / SvelteKit]
- **Styling**: [Tailwind / CSS Modules / Styled Components]
- **State management**: [Redux / Zustand / Pinia]

### Infrastructure
- **Deployment**: [Docker / Vercel / Netlify / AWS / Railway]
- **Cache**: [Redis / Memcached / none]
- **Search**: [Elasticsearch / Meilisearch / Algolia / none]
- **Storage**: [S3 / Cloudinary / none]

---

## Code Style

- **Indentation**: [2 spaces / 4 spaces / tabs]
- **Line length**: [80 / 100 / 120 characters]
- **Quotes**: [single / double]
- **Semicolons**: [required / optional]
- **File naming**: [snake_case / camelCase / kebab-case] for [backend / frontend]

---

## Project Structure

```
project-root/
├── [backend-folder]/
├── [frontend-folder]/
├── docs/
├── scripts/
├── .env.example
├── AGENTS.md
├── CONVENTIONS.md
└── README.md
```

---

## Testing Conventions

- **Test location**: [co-located / separate `tests/` directory]
- **Test naming**: [describe what the test does, not what function it calls]
- **Test data**: [factories / fixtures / inline]
- **Framework**: [pytest / Jest / Vitest / RSpec]

---

## Environment Variables

### Required for local development
```bash
# Fill in your actual variable names
DATABASE_URL=
SECRET_KEY=
API_KEY=
REDIS_URL=         # if used
SEARCH_HOST=       # if used
```

### Environment files
- `.env.local` — local development
- `.env.staging` — staging
- `.env.production` — production
- `.env.example` — template with placeholder values (commit this, not the others)

---

## What Requires Asking Before Doing

### Always ask before
- Modifying database schema (migrations)
- Adding new dependencies
- Changing authentication/authorization logic
- Modifying CI/CD pipeline
- Changing environment variables in production

### Never do without explicit permission
- Deleting files or database tables
- Modifying production configuration
- Changing API contracts (breaking changes)
- Installing global packages
- Modifying security settings

---

## Known Intentional Quirks

*Document unusual patterns here so agents don't "fix" them.*

```
# Example format:
# Pattern: [what it looks like]
# Why: [reason this was intentional]
```

---

## Customization Checklist

- [ ] Replace all `[bracketed]` placeholders with actual choices
- [ ] Update the project structure tree to match reality
- [ ] Fill in the required environment variables
- [ ] Add any known intentional quirks
- [ ] Remove sections that don't apply
- [ ] Remove this checklist when done