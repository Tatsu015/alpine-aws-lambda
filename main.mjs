import { handler } from './playwright.mjs';

(async () => {
    const res = await handler(null)
    console.log(res)
    return res
})();