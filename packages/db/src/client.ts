import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";

const client = postgres(process.env.DATABASE_URL!, { prepare: false });
// prepare: false es obligatorio en modo "Transaction" del pooler de Supabase

export const db = drizzle({ client });
