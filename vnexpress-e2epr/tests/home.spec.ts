import { test, expect } from '@playwright/test';

test.describe('Trang chủ VnExpress', () => {
  test('tải thành công và hiển thị nội dung chính', async ({ page }) => {
    const response = await page.goto('/', { waitUntil: 'domcontentloaded' });

    expect(response).not.toBeNull();
    expect(response?.ok()).toBeTruthy();
    await expect(page).toHaveTitle(/VnExpress/i);
    await expect(page.locator('body')).toBeVisible();
  });

  test('có thương hiệu và các liên kết điều hướng chính', async ({ page }) => {
    await page.goto('/', { waitUntil: 'domcontentloaded' });

    await expect(page.locator('a[href="/"]').first()).toBeVisible();
    const navigationLinks = page.locator('a[href^="/"]:not([href="/"])');
    await expect(navigationLinks.first()).toBeAttached();
  });
});
