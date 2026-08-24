# Despliegue

## Estrategia objetivo

El destino previsto es AWS Elastic Beanstalk usando una plataforma Docker. Supabase aloja PostgreSQL y Storage; Elastic Beanstalk ejecuta la API. El frontend puede publicarse como archivos estaticos en un hosting compatible con Vite o servirse mediante una capa web separada.

## Estado actual

El repositorio no incluye `Dockerfile`, `Dockerrun.aws.json`, configuracion de Elastic Beanstalk, pipeline CI/CD ni un servidor de archivos estaticos para `apps/web`. Esta estrategia es, por tanto, un objetivo y no un procedimiento ejecutable aun.

## Requisitos antes de desplegar

- Definir el proceso de build y el artefacto de produccion del backend.
- Fijar la version de Bun y las dependencias mediante `bun.lock`.
- Configurar `PORT` para el puerto proporcionado por Elastic Beanstalk.
- Inyectar `DATABASE_URL` y los secretos de autenticacion como variables seguras.
- Configurar dominios, HTTPS, logs y health checks.
- Completar autenticacion, autorizacion y politicas de acceso antes de exponer datos.
- Ejecutar migraciones de forma controlada, usando la conexion directa y un backup previo.

## Health check

La ruta actual `GET /health` responde JSON con estado `ok` y puede ser usada como punto de comprobacion inicial. Debe ampliarse para comprobar dependencias criticas cuando el servidor use la base de datos.

## Ambientes

Se recomienda separar desarrollo, prueba y produccion, con proyectos o bases de datos independientes y credenciales diferentes. Nunca se deben incluir archivos `.env` ni secretos en la imagen o en Git.
