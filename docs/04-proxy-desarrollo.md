# Proxy de desarrollo

## Objetivo

Durante el desarrollo, la SPA de Vite debe poder llamar a la API sin repetir el host del backend ni depender de configuraciones distintas entre navegador y produccion. La convencion propuesta es usar rutas relativas como `/api/health` desde el frontend.

## Estado actual

El proxy no esta configurado en `apps/web/vite.config.ts`. El backend tampoco monta actualmente sus rutas bajo `/api`; solo expone `/` y `/health`.

Por eso, no se debe asumir que `/api/*` funciona hasta completar ambas partes.

## Implementacion prevista

1. Mover o montar las rutas de negocio de Hono bajo el prefijo `/api`.
2. Configurar `server.proxy` en Vite para reenviar `/api` al servidor local, por ejemplo `http://localhost:3000`.
3. Usar URLs relativas en el cliente web.
4. Mantener en produccion un unico dominio o configurar un proxy equivalente en el servidor frontal.

## Verificacion

Con ambos procesos activos, una peticion del navegador a `/api/health` debe llegar al backend y devolver el estado de salud. CORS no debe usarse como sustituto del proxy ni de la autenticacion.
