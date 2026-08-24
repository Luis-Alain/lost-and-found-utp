# Modulo 0: fundacion de datos

## Objetivo

Dejar lista la base de datos, el paquete Drizzle y los contratos iniciales para que los modulos de autenticacion y reportes puedan construirse sobre una base reproducible.

## Tareas

| ID | Tarea | Estado |
|---|---|---|
| MOD0-01 | Corregir la unicidad compuesta de `identidades_usuario` | Pendiente de verificar |
| MOD0-02 | Alinear `schema.ts` con la base existente | Parcial: esquema presente |
| MOD0-03 | Definir relaciones tipadas de Drizzle | Parcial: relaciones presentes |
| MOD0-04 | Alinear `drizzle.config.ts` y variables de entorno | Pendiente |
| MOD0-05 | Establecer el baseline de migraciones | Pendiente |
| MOD0-06 | Crear seed idempotente de roles y categorias | Pendiente |
| MOD0-07 | Definir generacion unica de codigo de reporte | Pendiente |
| MOD0-08 | Decidir la estrategia para `updated_at` | Opcional, pendiente |
| MOD0-09 | Exportar correctamente el paquete `db` | Pendiente de validar |
| MOD0-10 | Actualizar esta documentacion al cerrar el modulo | Pendiente |

## Criterios de finalizacion

- Las URLs usadas por runtime y migraciones tienen nombres y propositos documentados.
- El esquema y las relaciones reflejan la base real sin cambios destructivos.
- La migracion baseline no recrea tablas existentes accidentalmente.
- Roles y categorias pueden sembrarse varias veces sin duplicarse.
- La generacion de codigos de reporte verifica colisiones.
- `apps/server` puede importar `db` y tipos desde el workspace.
- Hay una prueba reproducible de conexion o una validacion equivalente sin exponer secretos.
- Este documento y `docs/README.md` reflejan el estado final.

## Orden recomendado

1. Confirmar el esquema desplegado en Supabase.
2. Corregir nombres de variables y preparar el archivo de ejemplo.
3. Resolver el baseline y probarlo en una base descartable.
4. Implementar seed y generacion de codigos.
5. Validar exports, tipos y consultas del paquete `db`.
6. Actualizar estados y evidencias de verificacion.
