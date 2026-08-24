# Estructura del monorepo

## Arbol principal

```text
lost-and-found-utp/
├── apps/
│   ├── server/       # API HTTP con Bun y Hono
│   └── web/          # SPA con Vite y React
├── packages/
│   ├── db/           # Esquema, cliente y migraciones Drizzle
│   └── shared/       # Tipos, DTOs y validadores compartidos
├── docs/             # Documentacion tecnica
├── package.json      # Workspaces y scripts de Turborepo
└── turbo.json        # Configuracion de tareas del monorepo
```

## Aplicaciones

### `apps/server`

Es el servicio HTTP. Actualmente crea una instancia de Hono y expone:

- `GET /`: respuesta JSON de identificacion de la API.
- `GET /health`: respuesta JSON `{ "status": "ok" }`.

El proceso escucha en `PORT` o, por defecto, en el puerto `3000`.

### `apps/web`

Es la aplicacion React compilada con Vite. Tiene configurados Tailwind, React y dependencias para TanStack Router/Query, pero la pantalla actual solo muestra `Hello, World!`.

## Paquetes

### `packages/db`

Contiene `src/schema.ts`, `src/relations.ts`, `src/client.ts` y la carpeta `drizzle/` con el historial de migraciones. El cliente usa `DATABASE_URL` y desactiva `prepare` para funcionar con el modo Transaction del pooler de Supabase.

### `packages/shared`

Es el punto destinado a los contratos compartidos entre frontend y backend. Actualmente no contiene DTOs ni esquemas de negocio finalizados.

## Comandos

Desde la raiz:

```bash
bun install
bun run dev
bun run build
bun run lint
```

`dev`, `build` y `lint` se delegan a Turborepo. Solo los paquetes que tienen el script correspondiente ejecutaran esa tarea.
