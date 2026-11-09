# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: resident.spec.ts >> Resident Portal (http://localhost:5173) >> Authenticated Resident can navigate tabs, filter advisories, and view inbox
- Location: e2e\resident.spec.ts:91:7

# Error details

```
Error: expect(locator).toContainText(expected) failed

Locator: locator('h1')
Expected pattern: /Maria|Good day|community/i
Received string:  "Join your municipal alert network."
Timeout: 10000ms

Call log:
  - Expect "toContainText" locator('h1') with timeout 10000ms
  - waiting for locator('h1')
    22 × locator resolved to <h1 class="mb-4 text-3xl font-extrabold leading-tight tracking-tight text-white sm:text-4xl">Join your municipal alert network.</h1>
       - unexpected value "Join your municipal alert network."

```

```yaml
- heading "Join your municipal alert network." [level=1]
```

# Test source

```ts
  11  |       }
  12  |     });
  13  |     page.on('pageerror', err => {
  14  |       consoleErrors.push(`[Page Error] ${err.message}`);
  15  |     });
  16  |     page.on('requestfailed', req => {
  17  |       networkErrors.push(`[Request Failed] ${req.method()} ${req.url()} - ${req.failure()?.errorText}`);
  18  |     });
  19  |   });
  20  | 
  21  |   test('Page loads and shows branding, navigation, and auth forms', async ({ page }) => {
  22  |     await page.goto('http://localhost:5173');
  23  |     await expect(page).toHaveTitle(/Community Alert System \(CAS\)|Resident/i);
  24  | 
  25  |     // Verify brand
  26  |     const brand = page.locator('header a');
  27  |     await expect(brand).toBeVisible();
  28  | 
  29  |     // Verify sign in form fields
  30  |     const emailInput = page.locator('input[name="email"]');
  31  |     const passwordInput = page.locator('input[name="password"]');
  32  |     const submitButton = page.locator('button[type="submit"], button:has-text("Sign in"), button:has-text("Access")');
  33  | 
  34  |     await expect(emailInput).toBeVisible();
  35  |     await expect(passwordInput).toBeVisible();
  36  |     await expect(submitButton.first()).toBeVisible();
  37  |   });
  38  | 
  39  |   test('Sign in fails with invalid credentials and displays error alert', async ({ page }) => {
  40  |     await page.goto('http://localhost:5173');
  41  |     await page.fill('input[name="email"]', 'wrong-resident@example.com');
  42  |     await page.fill('input[name="password"]', 'WrongPassword123!');
  43  |     await page.click('button:has-text("Access"), button:has-text("Sign in")');
  44  | 
  45  |     const alert = page.locator('[role="alert"]');
  46  |     await expect(alert).toBeVisible();
  47  |     await expect(alert).toContainText(/incorrect|invalid/i);
  48  |   });
  49  | 
  50  |   test('Registration validation works: password mismatch & successful registration', async ({ page }) => {
  51  |     await page.goto('http://localhost:5173');
  52  | 
  53  |     // Switch to register mode
  54  |     const registerBtn = page.locator('button:has-text("Register"), button:has-text("Create an account")').first();
  55  |     await registerBtn.click();
  56  | 
  57  |     // Check register form fields
  58  |     await expect(page.locator('input[name="name"]')).toBeVisible();
  59  |     await expect(page.locator('input[name="phoneNumber"]')).toBeVisible();
  60  |     await expect(page.locator('input[name="address"]')).toBeVisible();
  61  |     await expect(page.locator('input[name="barangay"]')).toBeVisible();
  62  | 
  63  |     const uniqueEmail = `testresident_${Date.now()}@example.com`;
  64  | 
  65  |     // Fill form with mismatched passwords
  66  |     await page.fill('input[name="name"]', 'Juan Dela Cruz');
  67  |     await page.fill('input[name="phoneNumber"]', '09171234567');
  68  |     await page.fill('input[name="email"]', uniqueEmail);
  69  |     await page.fill('input[name="address"]', 'Zone 2, Balulang');
  70  |     await page.fill('input[name="barangay"]', 'Balulang');
  71  |     await page.selectOption('select[name="district"]', { index: 1 });
  72  |     await page.fill('input[name="password"]', 'Password123!');
  73  |     await page.fill('input[name="confirmPassword"]', 'MismatchPassword123!');
  74  |     await page.check('input[name="termsAccepted"]');
  75  | 
  76  |     await page.click('button:has-text("Complete"), button:has-text("Register"), button:has-text("Create")');
  77  | 
  78  |     // Should show password mismatch error
  79  |     const alert = page.locator('[role="alert"]');
  80  |     await expect(alert).toBeVisible();
  81  |     await expect(alert).toContainText(/match|password/i);
  82  | 
  83  |     // Fix password and submit
  84  |     await page.fill('input[name="confirmPassword"]', 'Password123!');
  85  |     await page.click('button:has-text("Complete"), button:has-text("Register"), button:has-text("Create")');
  86  | 
  87  |     // Should transition to dashboard
  88  |     await expect(page.locator('.portal-sidebar, header .avatar, h1').first()).toBeVisible({ timeout: 10000 });
  89  |   });
  90  | 
  91  |   test('Authenticated Resident can navigate tabs, filter advisories, and view inbox', async ({ page }) => {
  92  |     // Register fresh user for testing logged-in state
  93  |     await page.goto('http://localhost:5173');
  94  |     await page.locator('button:has-text("Register"), button:has-text("Create an account")').first().click();
  95  | 
  96  |     const uniqueEmail = `flowresident_${Date.now()}@example.com`;
  97  |     await page.fill('input[name="name"]', 'Maria Santos');
  98  |     await page.fill('input[name="phoneNumber"]', '09189876543');
  99  |     await page.fill('input[name="email"]', uniqueEmail);
  100 |     await page.fill('input[name="address"]', 'Carmen Valley');
  101 |     await page.fill('input[name="barangay"]', 'Carmen');
  102 |     await page.selectOption('select[name="district"]', { index: 1 });
  103 |     await page.fill('input[name="password"]', 'Password123!');
  104 |     await page.fill('input[name="confirmPassword"]', 'Password123!');
  105 |     await page.check('input[name="termsAccepted"]');
  106 |     await page.check('input[name="smsAlerts"]');
  107 | 
  108 |     await page.click('button:has-text("Complete"), button:has-text("Register"), button:has-text("Create")');
  109 | 
  110 |     // Verify Overview page loaded
> 111 |     await expect(page.locator('h1')).toContainText(/Maria|Good day|community/i);
      |                                      ^ Error: expect(locator).toContainText(expected) failed
  112 | 
  113 |     // Navigate to Local advisories
  114 |     const advisoriesNav = page.locator('.portal-sidebar button:has-text("Local advisories")');
  115 |     await advisoriesNav.click();
  116 |     await expect(page.locator('h1')).toContainText(/Local advisories/i);
  117 | 
  118 |     // Test quick filter buttons
  119 |     const filterButtons = page.locator('button:has-text("CEPALCO"), button:has-text("Water District")');
  120 |     if (await filterButtons.count() > 0) {
  121 |       await filterButtons.first().click();
  122 |     }
  123 | 
  124 |     // Navigate to Utility services
  125 |     const servicesNav = page.locator('.portal-sidebar button:has-text("Utility services")');
  126 |     await servicesNav.click();
  127 |     await expect(page.locator('h1')).toContainText(/Utility services/i);
  128 | 
  129 |     // Navigate to Profile & settings
  130 |     const profileNav = page.locator('.portal-sidebar button:has-text("Profile & settings")');
  131 |     await profileNav.click();
  132 |     await expect(page.locator('h1')).toContainText(/Profile/i);
  133 | 
  134 |     // Edit profile field and save
  135 |     await page.fill('input[name="address"]', 'Updated Address St.');
  136 |     await page.click('button:has-text("Save Profile Changes")');
  137 | 
  138 |     // Navigate to Virtual SMS inbox
  139 |     await page.setViewportSize({ width: 800, height: 900 });
  140 |     const inboxShortcut = page.getByRole('button', { name: 'Virtual SMS inbox' });
  141 |     await expect(inboxShortcut).toBeVisible();
  142 |     await inboxShortcut.click();
  143 |     await expect(page.locator('h1')).toContainText(/Virtual SMS Inbox/i);
  144 | 
  145 |     // Sign out
  146 |     const signOutBtn = page.locator('.portal-sidebar button:has-text("Sign out")');
  147 |     await signOutBtn.click();
  148 |     await expect(page.locator('input[name="email"]')).toBeVisible();
  149 |   });
  150 | 
  151 |   test.afterEach(async () => {
  152 |     // Print diagnostic errors found during execution
  153 |     if (consoleErrors.length > 0) {
  154 |       console.log('=== Resident Portal Console Errors ===\n' + consoleErrors.join('\n'));
  155 |     }
  156 |     if (networkErrors.length > 0) {
  157 |       console.log('=== Resident Portal Network Failures ===\n' + networkErrors.join('\n'));
  158 |     }
  159 |   });
  160 | });
  161 | 
```