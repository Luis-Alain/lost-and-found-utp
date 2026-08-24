# Lost & Found UTP

**Sistema web para la gestión y recuperación de objetos extraviados en un entorno universitario**

Proyecto de investigación desarrollado en la Universidad Tecnológica de Panamá, a presentarse en el **Congreso Tecnológico CONTECS 2026**.

---

## 📋 Resumen del proyecto

En el Centro Regional de Veraguas de la Universidad Tecnológica de Panamá, la gestión de objetos extraviados se realiza sin un mecanismo institucionalizado para registrar, dar seguimiento y documentar su devolución. La difusión depende principalmente de canales informales, como grupos de mensajería instantánea, lo que limita la visibilidad de los objetos encontrados y dificulta su trazabilidad.

El objetivo de este trabajo es **Desarrollar un sistema web que centralice el registro, custodia, publicación, reclamación y devolución de objetos extraviados** en el entorno universitario, sustituyendo la dependencia de canales informales por un flujo estructurado y auditable.

### Roles del sistema

| Rol | Función principal |
|---|---|
| **Estudiante** | Registra un objeto encontrado mediante un formulario y una fotografía; consulta sus propios reportes y el feed público de objetos activos. |
| **Personal de seguridad** | Confirma la recepción física del objeto, activa su publicación en el feed, y gestiona la verificación y devolución al propietario. |
| **Administrador** | Gestiona usuarios, categorías, y consulta el historial de auditoría del sistema. |

### Flujo general

```
Estudiante encuentra objeto
        │
        ▼
Crea reporte (foto + descripción)  →  estado PENDIENTE
        │
        ▼
Entrega física en garita de seguridad
        │
        ▼
Seguridad confirma recepción  →  estado ACTIVO  →  visible en feed público
        │
        ▼
Propietario identifica su objeto y acude a seguridad
        │
        ▼
Seguridad verifica y registra la devolución  →  estado DEVUELTO
        │
        ▼
Se retira del feed público, se conserva para auditoría
```

### Alcance actual
El resultado esperado es un **prototipo funcional** que estructure y dé trazabilidad al proceso de recuperación de pertenencias, validado mediante pruebas unitarias y una evaluación piloto con estudiantes. El trabajo será presentado como parte del Congreso Tecnológico CONTECS 2026.

### Autenticación institucional

El sistema está diseñado para integrarse con **Microsoft Entra ID**, permitiendo a los usuarios autenticarse con su correo institucional. Debido a que el acceso al tenant institucional está sujeto a la aprobación formal del proyecto, la fase actual de desarrollo utiliza un mecanismo de autenticación temporal, construido de forma que la migración a Microsoft Entra ID no requiera modificar la estructura de datos ni la lógica de negocio del sistema.

---

## 🛠️ Documentación técnica

> Esta sección está dirigida al equipo de desarrollo. La documentación de decisiones de arquitectura, base de datos, y despliegue vive en [`docs/`](./docs).

### Stack tecnológico

| Capa | Tecnología |
|---|---|
| Runtime backend | [Bun](https://bun.sh) |
| Framework backend | [Hono](https://hono.dev) |
| Frontend | [Vite](https://vitejs.dev) + [React](https://react.dev) |
| Routing frontend | [TanStack Router](https://tanstack.com/router) |
| Data fetching | [TanStack Query](https://tanstack.com/query) + cliente RPC de Hono |
| ORM | [Drizzle ORM](https://orm.drizzle.team) |
| Base de datos | [Supabase](https://supabase.com) (PostgreSQL) |
| Almacenamiento de imágenes | Supabase Storage |
| Orquestador de monorepo | [Turborepo](https://turbo.build) |
| Despliegue | AWS Elastic Beanstalk (plataforma Docker) |

Las decisiones detrás de cada elección (por qué Bun sobre Node, por qué no gRPC, por qué Docker en EB, etc.) están documentadas en [`docs/01-decisiones-arquitectura.md`](./docs/01-decisiones-arquitectura.md).

### Estructura del monorepo

```
lost-and-found-utp/
├── apps/
│   ├── server/          # Bun + Hono — API HTTP
│   └── web/              # Vite + React + TanStack Router — SPA
├── packages/
│   ├── db/                # Drizzle schema + cliente de conexión a Supabase
│   └── shared/             # Schemas de Zod / DTOs compartidos entre frontend y backend
├── docs/                    # Documentación de arquitectura, base de datos, despliegue y tareas
├── scripts/                  # Scripts de automatización (GitHub Projects, rulesets, etc.)
├── package.json              # Workspaces de Bun
└── turbo.json                 # Configuración de Turborepo
```

Detalle completo en [`docs/02-estructura-monorepo.md`](./docs/02-estructura-monorepo.md).

### Requisitos previos

- [Bun](https://bun.sh) `>= 1.1`
- Cuenta de [Supabase](https://supabase.com)

### Instalación

```bash
git clone git@github.com:Luis-Alain/lost-and-found-utp.git
cd lost-and-found-utp
bun install
```

### Variables de entorno

Copia el archivo de ejemplo dentro de `packages/db` y complétalo con las credenciales de tu proyecto de Supabase:

```bash
cp packages/db/.env.example packages/db/.env
```

```bash
# packages/db/.env
DATABASE_URL=postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres   # pooler — runtime
DIRECT_URL=postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:5432/postgres     # directa — migraciones
```

Ver [`docs/03-base-de-datos.md`](./docs/03-base-de-datos.md) para el detalle de por qué se usan dos URLs distintas.

### Comandos principales

Desde la raíz del monorepo (orquestados con Turborepo):

```bash
bun run dev       # levanta apps/server y apps/web en paralelo
bun run build     # build de producción de todos los paquetes
bun run lint      # lint de todos los paquetes
```

Desde `packages/db`, gestión de la base de datos:

```bash
bun run db:generate   # genera migraciones a partir del schema de Drizzle
bun run db:migrate    # aplica migraciones pendientes
bun run db:push       # sincroniza el schema directamente (desarrollo rápido)
bun run db:studio     # abre Drizzle Studio para explorar la base de datos
```

### Flujo de trabajo y ramas

El repositorio tiene un ruleset activo sobre `main`:

- Todo cambio entra por **Pull Request** — no se permite push directo a `main`.
- Se requiere **al menos 1 aprobación** antes de mergear (ver [`scripts/ruleset-main.json`](./scripts/ruleset-main.json) para el detalle exacto de las reglas).
- No se permite force-push ni borrado de `main`.
- Historial lineal: se mergea por **squash** o **rebase**, no por merge commit.

### Documentación completa

| Documento | Contenido |
|---|---|
| [`docs/01-decisiones-arquitectura.md`](./docs/01-decisiones-arquitectura.md) | Stack elegido y justificación técnica |
| [`docs/02-estructura-monorepo.md`](./docs/02-estructura-monorepo.md) | Workspaces, Turborepo, estructura de carpetas |
| [`docs/03-base-de-datos.md`](./docs/03-base-de-datos.md) | Drizzle ORM + Supabase, migraciones |
| [`docs/04-proxy-desarrollo.md`](./docs/04-proxy-desarrollo.md) | Proxy de Vite hacia Hono en desarrollo |
| [`docs/05-despliegue.md`](./docs/05-despliegue.md) | Estrategia de despliegue en AWS Elastic Beanstalk |
| [`docs/06-modulo-0-tareas.md`](./docs/06-modulo-0-tareas.md) | Desglose de tareas del Módulo 0 |

---

## 👥 Autores

Proyecto desarrollado por:

- **Luis Alaín** — luis.alain@utp.ac.pa · [@Luis-Alain](https://github.com/Luis-Alain)
- **Jean Gómez** — jean.gomez1@utp.ac.pa
- **Rolando Mora** — rolando.mora@utp.ac.pa

Universidad Tecnológica de Panamá.

## 📄 Licencia
Este proyecto está bajo la [Licencia MIT](LICENSE).

Copyright © 2026 [Luis Alain](https://github.com/Luis-Alain)
