# Decisiones de arquitectura

## Objetivo

Construir un sistema web para registrar, custodiar, publicar, reclamar y devolver objetos extraviados en el Centro Regional de Veraguas de la Universidad Tecnologica de Panama.

## Decisiones

| Area | Decision | Motivo |
|---|---|---|
| Runtime | Bun | Proporciona runtime, gestor de paquetes y herramientas de desarrollo en una sola plataforma. Es el runtime definido por el repositorio. |
| API | Hono sobre Bun | Mantiene una API HTTP pequena, tipada y portable, con soporte para middleware y rutas. |
| Frontend | Vite + React | Permite construir una SPA con desarrollo rapido y una salida estatica para produccion. |
| Datos del frontend | TanStack Query y TanStack Router | Estan declarados como dependencias para resolver cache de datos y routing cuando se construya la SPA. Todavia no se usan en `apps/web/src/main.tsx`. |
| Persistencia | PostgreSQL en Supabase | Ofrece PostgreSQL administrado y servicios complementarios como Storage. |
| ORM | Drizzle ORM | El esquema se expresa en TypeScript y permite generar y ejecutar migraciones. |
| Monorepo | Workspaces de Bun + Turborepo | Permite compartir tipos y coordinar tareas entre aplicaciones y paquetes. |
| Despliegue | AWS Elastic Beanstalk con Docker | Es la estrategia objetivo para ejecutar el backend en una plataforma administrada. Aun no hay Dockerfile ni configuracion de EB. |

## Autenticacion

La integracion objetivo es Microsoft Entra ID mediante un adaptador. Mientras se obtiene acceso al tenant institucional, se preve un proveedor temporal. Ningun proveedor de autenticacion esta implementado actualmente, por lo que no deben publicarse endpoints de negocio sin autorizacion.

## Principios

- El backend es la frontera de autorizacion y validacion.
- Los DTOs y validadores reutilizables deben vivir en `packages/shared`.
- La informacion sensible de los reportes y de las devoluciones no debe exponerse en el feed publico.
- Cada mutacion relevante debe dejar un registro de auditoria.
- Las transiciones de estado deben ser explicitas: `PENDIENTE` -> `ACTIVO` -> `DEVUELTO`.
