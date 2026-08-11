import { integer, pgTable, varchar, timestamp } from "drizzle-orm/pg-core";

export const itemsTable = pgTable("items", {
  id: integer().primaryKey().generatedAlwaysAsIdentity(),
  title: varchar({ length: 255 }).notNull(),
  description: varchar({ length: 1000 }),
  createdAt: timestamp().defaultNow().notNull(),
});
