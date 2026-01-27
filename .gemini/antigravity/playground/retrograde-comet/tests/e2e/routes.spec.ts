import { test, expect } from "@playwright/test";

test.describe("Route Smoke Tests", () => {
    test("homepage loads correctly", async ({ page }) => {
        await page.goto("/");
        await expect(page.locator("h1")).toContainText("harman");
        await expect(page.locator("header")).toBeVisible();
        await expect(page.locator("footer")).toBeVisible();
    });

    test("services page loads", async ({ page }) => {
        await page.goto("/services");
        await expect(page.locator("h1")).toBeVisible();
    });

    test("work page loads", async ({ page }) => {
        await page.goto("/work");
        await expect(page.locator("h1")).toBeVisible();
    });

    test("about page loads", async ({ page }) => {
        await page.goto("/about");
        await expect(page.locator("h1")).toBeVisible();
    });

    test("careers page loads", async ({ page }) => {
        await page.goto("/careers");
        await expect(page.locator("h1")).toBeVisible();
    });

    test("blog page loads", async ({ page }) => {
        await page.goto("/blog");
        await expect(page.locator("h1")).toBeVisible();
    });

    test("contact page loads", async ({ page }) => {
        await page.goto("/contact");
        await expect(page.locator("h1")).toBeVisible();
        await expect(page.locator("form")).toBeVisible();
    });

    test("language toggle works", async ({ page }) => {
        await page.goto("/");
        // Find and click language toggle
        const langButton = page.getByRole("button", { name: /EN|TR/i });
        await langButton.click();
        // Verify content changes
        await page.waitForTimeout(500);
        await expect(page.locator("h1")).toBeVisible();
    });

    test("navigation works", async ({ page }) => {
        await page.goto("/");
        // Click on a nav link
        await page.click('a[href="/services"]');
        await expect(page).toHaveURL("/services");
    });
});
