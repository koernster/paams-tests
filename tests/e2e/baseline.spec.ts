import { test, expect } from '@playwright/test';

test('baseline: page title and screenshot', async ({ page }) => {
  await page.goto('/');
  const title = await page.title();
  const hasExpectedTitle = /MTCM|DoPlace|Login/i.test(title);
  expect(hasExpectedTitle, `Expected title to contain MTCM, DoPlace, or Login but got: "${title}"`).toBe(true);
  await page.screenshot({ path: 'test-results/baseline.png' });
});
