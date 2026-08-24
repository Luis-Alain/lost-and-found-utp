# Documentacion tecnica

Esta carpeta contiene las decisiones y procedimientos tecnicos del proyecto Lost & Found UTP.

## Documentos

| Documento | Descripcion | Estado |
|---|---|---|
| [01 - Decisiones de arquitectura](./01-decisiones-arquitectura.md) | Criterios del stack y limites actuales del prototipo | Vigente |
| [02 - Estructura del monorepo](./02-estructura-monorepo.md) | Workspaces, aplicaciones y paquetes | Vigente |
| [03 - Base de datos](./03-base-de-datos.md) | Drizzle ORM, PostgreSQL/Supabase y migraciones | En progreso |
| [04 - Proxy de desarrollo](./04-proxy-desarrollo.md) | Acceso del frontend a la API durante desarrollo | Pendiente de implementar |
| [05 - Despliegue](./05-despliegue.md) | Estrategia propuesta para AWS Elastic Beanstalk | Planificado |
| [06 - Modulo 0: tareas](./06-modulo-0-tareas.md) | Fundacion de datos y criterios de finalizacion | Pendiente |

## Estado del proyecto

El backend expone actualmente `GET /` y `GET /health`. El frontend renderiza una pantalla minima y la base de datos ya tiene un esquema Drizzle con entidades para usuarios, roles, reportes, categorias, devoluciones, identidades y auditoria.

Autenticacion, endpoints de negocio, almacenamiento de imagenes, proxy, despliegue y pruebas automatizadas siguen pendientes. Los documentos deben actualizarse cuando esas partes se implementen.
