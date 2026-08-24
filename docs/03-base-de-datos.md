# Base de datos

## Tecnologia y conexion

La persistencia usa PostgreSQL administrado por Supabase y Drizzle ORM. El cliente runtime se encuentra en `packages/db/src/client.ts` y conecta mediante `DATABASE_URL`.

Se recomienda separar las conexiones:

- `DATABASE_URL`: URL del pooler para el runtime de la aplicacion.
- `DIRECT_URL`: URL directa para operaciones administrativas y migraciones.

La configuracion actual de `drizzle.config.ts` usa `DATABASE_URL_SESSION`, no `DIRECT_URL`. Esta discrepancia debe corregirse antes de depender de los comandos de migracion.

Ejemplo conceptual de `packages/db/.env`:

```dotenv
DATABASE_URL=postgresql://...:6543/postgres
DIRECT_URL=postgresql://...:5432/postgres
```

No se deben versionar credenciales. El archivo `.env.example` mencionado por el README aun debe crearse.

## Entidades

- `roles`: catalogo de roles del sistema.
- `usuarios`: usuarios institucionales y su rol.
- `identidades_usuario`: vincula un usuario con un proveedor externo y su identificador.
- `categorias`: categorias de objetos encontrados.
- `reportes`: objeto reportado, fotografia, ubicacion y estado.
- `devoluciones`: evidencia de la entrega del objeto a su receptor.
- `registros_auditoria`: historial de cambios y acciones relevantes.

Los estados de `reportes` son `PENDIENTE`, `ACTIVO` y `DEVUELTO`. La tabla de devoluciones tiene una relacion unica con cada reporte.

## Integridad y seguridad

El esquema define claves foraneas, indices y restricciones de unicidad. Debe verificarse la restriccion compuesta de `identidades_usuario` para que la unicidad sea `(proveedor, identificador_externo)`.

Aunque el diseño contempla Row Level Security, las politicas no estan documentadas ni implementadas en este repositorio. La autorizacion debe aplicarse en el backend antes de exponer operaciones.

## Migraciones

Comandos disponibles desde `packages/db`:

```bash
bun run db:generate
bun run db:migrate
bun run db:push
bun run db:studio
```

La migracion existente parece un baseline generado a partir de una base previa y su SQL esta comentado. Antes de usar `db:migrate` en un entorno nuevo se debe confirmar si el baseline ya fue aplicado y definir el procedimiento de inicializacion.
