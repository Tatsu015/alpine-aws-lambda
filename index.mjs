import { scrape } from "./playwright.mjs";

export const handler = async (event) => {
  const txt = await scrape(event);

  const response = {
    statusCode: 200,
    body: JSON.stringify(txt),
  };
  return response;
};
