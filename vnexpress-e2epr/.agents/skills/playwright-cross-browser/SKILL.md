---
name: playwright-cross-browser
description: "Use when running or configuring Playwright tests across Chromium, Firefox, and WebKit/Safari, especially when the user requires full browser mode instead of headless mode."
argument-hint: "[project or test filter]"
user-invocable: true
disable-model-invocation: false
---

# Playwright Cross-Browser Full Browser Testing

## Required configuration

Use visible browsers for local runs:

```ts
use: {
  baseURL: 'https://vnexpress.net',
  headless: false,
}
```

Configure the three Playwright projects:

```ts
projects: [
  { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
  { name: 'webkit', use: { ...devices['Desktop Safari'] } },
]
```

Use `workers: 1` for local full-browser runs when multiple visible browser windows exhaust memory or CPU. A suite timeout of `60000` milliseconds gives Firefox and pages with background network activity enough time to finish.

## Install and run

```bash
npx playwright install chromium firefox webkit
npx playwright test
```

Run one engine at a time when diagnosing failures:

```bash
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

## Safari note

Playwright does not launch the installed Safari application on Windows. The `webkit` project is the closest available Safari engine. Do not claim that a WebKit pass is equivalent to testing Safari on macOS or iOS.

## Environment note

`headless: false` requires an interactive desktop session. It will not work in a headless CI environment unless the CI job provides a display server or uses a separate headless configuration.
