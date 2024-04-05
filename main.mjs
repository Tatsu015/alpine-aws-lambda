import { f } from "./playwright.mjs";

(async () => {
  const res = await f();
  console.log(res);
  return res;
})();
