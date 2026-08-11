import { Hono } from "hono";

const app = new Hono();

app.get("/", (c) => c.json({ message: "Lost and Found API" }));

app.get("/health", (c) => c.json({ status: "ok" }));

const port = Number(Bun.env.PORT ?? 3000);

Bun.serve({
  fetch: app.fetch,
  port,
});

console.log(`Server running on http://localhost:${port}`);
