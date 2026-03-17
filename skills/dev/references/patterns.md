# @dev — Implementation Patterns

## Conditional Dependency Loading

For optional or heavy dependencies (monitoring, analytics, dev tools), use lazy loading with feature flags to avoid bundling issues.

**When to use:**
- Optional monitoring/analytics (Sentry, Datadog, Google Analytics)
- Dev-only tools (React DevTools, debug panels)
- Heavy libraries not always needed
- Dependencies that cause build issues on certain platforms

**Don't use for:**
- Core dependencies (React, database drivers)
- Dependencies needed at build time
- Simple utilities (just import them normally)

### TypeScript/Next.js Example

```typescript
// lib/monitoring/sentry.ts
const sentryEnabled = process.env.NEXT_PUBLIC_ENABLE_SENTRY === "true";

type SentryLike = {
  captureException: (error: unknown) => void;
};

let sentryModulePromise: Promise<SentryLike | null> | null = null;

async function loadSentry(): Promise<SentryLike | null> {
  if (!sentryEnabled) return null;

  if (!sentryModulePromise) {
    sentryModulePromise = (async () => {
      try {
        // Dynamic import avoids static analysis issues
        const dynamicImport = new Function(
          "moduleName",
          "return import(moduleName);"
        ) as (moduleName: string) => Promise<SentryLike>;

        return await dynamicImport("@sentry/nextjs");
      } catch (error) {
        if (process.env.NODE_ENV === "development") {
          console.warn("[sentry] Failed to load:", error);
        }
        return null;
      }
    })();
  }

  return sentryModulePromise;
}

export async function captureException(error: unknown): Promise<void> {
  const sentry = await loadSentry();
  if (!sentry) return; // Graceful degradation
  sentry.captureException(error);
}
```

**Benefits:**
- Smaller bundle size when feature disabled
- Avoids build errors from optional dependencies
- Works even if dependency not installed
- No runtime errors if module missing

**Use cases:** Optional monitoring/analytics, platform-specific dependencies, dev-only features, A/B testing different implementations.
