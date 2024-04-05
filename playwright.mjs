import { chromium } from "playwright-chromium";

const UserAgent =
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36";
const LaunchOption = {
  executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH,
  headless: true,
};

export const scrape = async (event) => {
  const browser = await chromium.launch(LaunchOption);
  const context = await browser.newContext({ userAgent: UserAgent });
  const page = await context.newPage();

  await page.goto("https://example.com");
  const txt = await page.locator("body").innerText();

  console.log(">> RUN SUCCESS!");
  console.log("<< RUN END!");
  await page.close();
  await context.close();
  await browser.close();

  console.log(txt);
  return txt;
};
