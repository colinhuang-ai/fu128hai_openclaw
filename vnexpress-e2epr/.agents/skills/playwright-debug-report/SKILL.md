---
name: playwright-debug-report
description: "Use when diagnosing Playwright test failures, reviewing screenshots, videos, traces, HTML reports, selectors, timeouts, or browser-specific behavior."
argument-hint: "[failed test or project name]"
user-invocable: true
disable-model-invocation: false
---

# Playwright Failure Diagnosis and Reports

## Failure workflow

1. Re-run only the failing test or browser project.
2. Preserve the failing screenshot, video, trace, and error context in `test-results/`.
3. Open the HTML report when the failure needs a timeline or attachment review:

   ```bash
   npx playwright show-report
   ```

4. Check whether the failure is caused by navigation, a selector, an assertion, a timeout, or browser-specific behavior.
5. Prefer a durable locator based on role, accessible name, stable attributes, or URL structure.
6. Do not fix a flaky test by adding arbitrary `waitForTimeout`; wait for a locator, response, or meaningful page state.
7. Re-run the same focused command after each local fix, then run the full browser matrix.

## Useful commands

```bash
npx playwright test tests/home.spec.ts --project=firefox
npx playwright test tests/home.spec.ts --headed
npx playwright show-report
npx tsc --noEmit
```

## Common project-specific issues

- If visible runs consume too many resources, set `workers: 1`.
- If Firefox needs more time to close after a news page loads background resources, use a suite timeout of `60000` milliseconds.
- If a category slug or generated CSS class changes, assert on a durable internal link instead.
- If WebKit fails while Chromium and Firefox pass, inspect browser-specific layout, navigation, and unsupported API assumptions before weakening the assertion.
