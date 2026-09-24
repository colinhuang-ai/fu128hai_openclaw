---
name: playwright-project-setup
description: "Use when creating or initializing a Playwright test project, installing Playwright browsers, configuring TypeScript, or adding smoke tests for a web application."
argument-hint: "[application URL or test scenario]"
user-invocable: true
disable-model-invocation: false
---

# Playwright Project Setup

## Goal

Create or maintain a small, maintainable Playwright Test project for the application under test.

## Setup checklist

1. Confirm the project uses `@playwright/test`, TypeScript, and `@types/node`.
2. Keep tests under `tests/` and configuration in `playwright.config.ts`.
3. Use `baseURL` for the target application so tests can navigate with relative paths.
4. Install the required browser engines:

   ```bash
   npx playwright install chromium firefox webkit
   ```

5. Prefer stable assertions such as HTTP status, page title, visible body content, accessible names, and durable links.
6. Avoid selectors based on article text, generated classes, or implementation details that change frequently.

## VnExpress defaults

For this project, the default target is `https://vnexpress.net`. Smoke tests should cover:

- the home page returns a successful response;
- the title contains `VnExpress`;
- the body is visible;
- the home link is visible;
- at least one other internal link is present.

## Validation

Run the typecheck and tests after changes:

```bash
npx tsc --noEmit
npx playwright test
```
