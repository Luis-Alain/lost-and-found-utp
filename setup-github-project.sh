set -euo pipefail

OWNER="Luis-Alain"
REPO="lost-and-found-utp"
PROJECT_NUMBER=1

REPO_FULL="${OWNER}/${REPO}"

echo "==> Verificando autenticación de gh CLI..."
gh auth status

echo "==> Usando Project existente #$PROJECT_NUMBER (owner: $OWNER)..."
PROJECT_JSON=$(gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json)
PROJECT_ID=$(echo "$PROJECT_JSON" | jq -r '.id')
echo "    Project id: $PROJECT_ID"

echo "==> Creando labels necesarios (si no existen)..."
LABELS=(
  "modulo-0:0E8A16:Modulo 0 - Fundacion de datos"
  "modulo-1:0E8A16:Modulo 1 - Autenticacion y usuarios"
  "modulo-2:0E8A16:Modulo 2 - Reportes: creacion y consulta"
  "modulo-3:0E8A16:Modulo 3 - Feed publico"
  "modulo-4:0E8A16:Modulo 4 - Flujo de seguridad: recepcion y activacion"
  "modulo-5:0E8A16:Modulo 5 - Devoluciones"
  "modulo-6:0E8A16:Modulo 6 - Auditoria"
  "modulo-7:0E8A16:Modulo 7 - Administracion"
  "database:1D76DB:Relacionado a base de datos / Drizzle / Supabase"
  "backend:5319E7:Relacionado al servidor Hono"
  "frontend:E99695:Relacionado a Vite / React / TanStack Router"
  "auth:B60205:Relacionado a autenticacion y autorizacion"
  "config:FBCA04:Configuracion de proyecto/infraestructura"
  "docs:C5DEF5:Documentacion"
  "bug:D73A4A:Correccion de errores"
  "nice-to-have:CFD3D7:Prioridad baja, no bloqueante"
)

for entry in "${LABELS[@]}"; do
  IFS=":" read -r name color desc <<< "$entry"
  gh label create "$name" --repo "$REPO_FULL" --color "$color" --description "$desc" --force
done

echo "==> Obteniendo el campo 'Status' y el id de la opcion 'Backlog'..."
FIELDS_JSON=$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json)

STATUS_FIELD_ID=$(echo "$FIELDS_JSON" | jq -r '.fields[] | select(.name=="Status") | .id')
BACKLOG_OPTION_ID=$(echo "$FIELDS_JSON" | jq -r '.fields[] | select(.name=="Status") | .options[] | select(.name=="Backlog") | .id')

if [[ -z "$BACKLOG_OPTION_ID" || "$BACKLOG_OPTION_ID" == "null" ]]; then
  echo "    AVISO: No se encontro una columna 'Backlog'."
  echo "    Columnas disponibles:"
  echo "$FIELDS_JSON" | jq -r '.fields[] | select(.name=="Status") | .options[].name'
  echo "    Crea la columna 'Backlog' manualmente en el Project (Settings > Fields > Status) y vuelve a correr el script."
  exit 1
fi

echo "==> Definiendo todas las tareas de los modulos 0-7..."

# titulo|labels(coma-separado)|cuerpo-en-una-linea
# IMPORTANTE: no usar el caracter $ dentro del cuerpo (bash lo interpreta como variable)
declare -a TASKS=(
  # ---------------- MODULO 0 - Fundacion de datos ----------------
  "[MOD0-01] Corregir constraint de identidades_usuario|bug,database,modulo-0|El UNIQUE actual es por columna separada en vez de compuesto (proveedor, identificador_externo), lo que limita el sistema a un solo usuario mock. Ver docs/06-modulo-0-tareas.md."
  "[MOD0-02] Escribir schema.ts de Drizzle reflejando la base de datos existente|database,modulo-0|Traducir las tablas ya creadas en Supabase a definiciones de Drizzle ORM en packages/db/src/schema.ts, incluyendo el enum reportes_estado_enum."
  "[MOD0-03] Definir relaciones (relations) de Drizzle|database,modulo-0|Declarar relations entre todas las tablas para permitir queries con joins tipados."
  "[MOD0-04] Configurar drizzle.config.ts y variables de entorno|database,config,modulo-0|Configurar drizzle.config.ts apuntando a DIRECT_URL, y .env con DATABASE_URL (pooler) y DIRECT_URL (directa)."
  "[MOD0-05] Sincronizar Drizzle con la base de datos existente (baseline)|database,modulo-0|Evitar que drizzle-kit intente recrear tablas ya existentes. Generar migracion baseline o usar introspect como punto de partida."
  "[MOD0-06] Seed script: roles y categorias iniciales|database,modulo-0|Script idempotente para insertar los 3 roles y las categorias iniciales, ejecutable con bun run db:seed."
  "[MOD0-07] Estrategia de generacion de codigo unico en reportes|backend,modulo-0|Definir e implementar la funcion que genera el codigo legible de cada reporte, con verificacion de unicidad y reintento ante colision."
  "[MOD0-08] (Opcional) Actualizacion automatica de updated_at|database,nice-to-have,modulo-0|Decidir e implementar actualizacion automatica de updated_at (trigger SQL vs metodo de Drizzle para on-update), aplicado consistentemente a todas las tablas."
  "[MOD0-09] Exportar el paquete db del monorepo|backend,modulo-0|Finalizar client.ts e index.ts para que apps/server consuma el paquete de base de datos con tipos inferidos correctamente."
  "[MOD0-10] Documentar el Modulo 0|docs,modulo-0|Actualizar docs/03-base-de-datos.md con el estado final y marcar el Modulo 0 como completado en docs/README.md."

  # ---------------- MODULO 1 - Autenticacion y usuarios ----------------
  "[MOD1-01] Implementar MockAuthProvider|auth,backend,modulo-1|Crear MockAuthProvider con usuarios de prueba para cada rol (estudiante, seguridad, administrador), siguiendo el patron adaptador definido para Entra ID."
  "[MOD1-02] Upsert de usuario e identidad en primer login|auth,backend,database,modulo-1|Al autenticar, si el identificador_externo no existe en identidades_usuario, crear el usuario y la identidad asociada automaticamente."
  "[MOD1-03] Middleware de autorizacion por rol en Hono|auth,backend,modulo-1|Construir middleware tipo requireRole para restringir endpoints segun el rol del usuario autenticado."
  "[MOD1-04] Emision de sesion propia (JWT)|auth,backend,modulo-1|Emitir JWT de sesion propio tras el login (mock o real), de forma que el frontend nunca dependa del formato del proveedor de autenticacion."

  # ---------------- MODULO 2 - Reportes: creacion y consulta ----------------
  "[MOD2-01] Endpoint de creacion de reporte|backend,modulo-2|Crear endpoint que reciba titulo, descripcion, categoria, ubicacion y foto, generando el reporte en estado PENDIENTE."
  "[MOD2-02] Subida de imagen a Supabase Storage|backend,modulo-2|Definir el flujo de subida de la foto del objeto encontrado a Supabase Storage, antes o durante la creacion del reporte."
  "[MOD2-03] Endpoint de mis reportes|backend,modulo-2|Endpoint que devuelve los reportes creados por el usuario autenticado."
  "[MOD2-04] Endpoint de detalle de reporte|backend,modulo-2|Endpoint de consulta de un reporte especifico por codigo o id."
  "[MOD2-05] Frontend: formulario de creacion y vista de mis reportes|frontend,modulo-2|Construir el formulario de creacion de reporte y la vista de listado de reportes propios en la SPA."

  # ---------------- MODULO 3 - Feed publico ----------------
  "[MOD3-01] Endpoint de feed publico|backend,modulo-3|Endpoint que devuelve unicamente reportes en estado ACTIVO, con paginacion."
  "[MOD3-02] Filtros de categoria y fecha en el feed|backend,modulo-3|Agregar filtros por categoria y rango de fecha al endpoint de feed publico."
  "[MOD3-03] Frontend: vista de feed y detalle|frontend,modulo-3|Construir la vista de feed publico y la vista de detalle de un reporte individual en la SPA."

  # ---------------- MODULO 4 - Flujo de seguridad: recepcion y activacion ----------------
  "[MOD4-01] Busqueda de reporte por codigo|backend,modulo-4|Endpoint de busqueda de un reporte a partir de su codigo, para uso del personal de seguridad."
  "[MOD4-02] Endpoint de activacion de reporte|backend,modulo-4|Endpoint que transiciona el reporte de PENDIENTE a ACTIVO, registrando activado_por y activado_at."
  "[MOD4-03] Listado de reportes pendientes de recepcion|backend,modulo-4|Endpoint que lista los reportes en estado PENDIENTE, para el panel de seguridad."
  "[MOD4-04] Frontend: panel de seguridad con busqueda y activacion|frontend,modulo-4|Construir el panel de seguridad con busqueda de reporte por codigo y boton de activacion."

  # ---------------- MODULO 5 - Devoluciones ----------------
  "[MOD5-01] Endpoint de registro de devolucion|backend,modulo-5|Endpoint que recibe reporte_id, datos del receptor, metodo de verificacion y observaciones, y crea el registro de devolucion."
  "[MOD5-02] Match automatico de receptor por correo|backend,modulo-5|Intentar asociar automaticamente usuario_receptor_id si el correo_receptor coincide con un usuario existente en el sistema."
  "[MOD5-03] Transicion de reporte a estado DEVUELTO|backend,modulo-5|Al registrar la devolucion, transicionar el reporte de ACTIVO a DEVUELTO, retirandolo automaticamente del feed publico."
  "[MOD5-04] Frontend: panel de registro de devolucion|frontend,modulo-5|Construir el panel de seguridad para registrar la devolucion de un objeto."

  # ---------------- MODULO 6 - Auditoria ----------------
  "[MOD6-01] Helper reutilizable de registro de auditoria|backend,modulo-6|Crear funcion reutilizable para insertar en registros_auditoria, invocada desde cada mutacion relevante del sistema."
  "[MOD6-02] Endpoint de consulta de auditoria|backend,modulo-6|Endpoint restringido a administradores, con filtros por entidad, accion, usuario y rango de fecha."
  "[MOD6-03] Frontend: vista de historico de auditoria|frontend,modulo-6|Construir la vista de administracion para consultar el historico de auditoria del sistema."

  # ---------------- MODULO 7 - Administracion ----------------
  "[MOD7-01] CRUD de categorias|backend,modulo-7|Endpoints de creacion, edicion, activacion y desactivacion de categorias, restringidos a administradores."
  "[MOD7-02] Gestion de usuarios|backend,modulo-7|Endpoints para activar, desactivar y cambiar el rol de un usuario, restringidos a administradores."
  "[MOD7-03] (Opcional) Dashboard de metricas basicas|frontend,nice-to-have,modulo-7|Vista de administracion con metricas basicas: reportes por estado, tiempo promedio de devolucion, categorias mas reportadas."
)

echo "==> Total de tareas a crear: ${#TASKS[@]}"

for task in "${TASKS[@]}"; do
  IFS="|" read -r title labels body <<< "$task"

  echo "----------------------------------------------------------------"
  echo "==> Creando issue: $title"

  ISSUE_URL=$(gh issue create \
    --repo "$REPO_FULL" \
    --title "$title" \
    --body "$body" \
    --label "$labels")

  echo "    Issue creada: $ISSUE_URL"

  echo "==> Agregando issue al Project..."
  ITEM_ID=$(gh project item-add "$PROJECT_NUMBER" \
    --owner "$OWNER" \
    --url "$ISSUE_URL" \
    --format json | jq -r '.id')

  echo "==> Moviendo issue a la columna Backlog..."
  gh project item-edit \
    --project-id "$PROJECT_ID" \
    --id "$ITEM_ID" \
    --field-id "$STATUS_FIELD_ID" \
    --single-select-option-id "$BACKLOG_OPTION_ID"

  echo "    OK"
done