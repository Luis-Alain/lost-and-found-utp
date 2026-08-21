import { pgTable, index, foreignKey, unique, uuid, varchar, boolean, timestamp, text, jsonb, pgEnum } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"

export const reportesEstadoEnum = pgEnum("reportes_estado_enum", ['PENDIENTE', 'ACTIVO', 'DEVUELTO'])


export const usuarios = pgTable("usuarios", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	rolId: uuid("rol_id").notNull(),
	nombre: varchar({ length: 150 }).notNull(),
	apellido: varchar({ length: 150 }).notNull(),
	correo: varchar({ length: 255 }).notNull(),
	activo: boolean().default(true).notNull(),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	index("idx_usuarios_correo").using("btree", table.correo.asc().nullsLast().op("text_ops")),
	index("idx_usuarios_rol_id").using("btree", table.rolId.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.rolId],
			foreignColumns: [roles.id],
			name: "fk_roles_usuarios"
		}).onDelete("restrict"),
	unique("usuarios_correo_key").on(table.correo),
]);

export const reportes = pgTable("reportes", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	codigo: varchar({ length: 30 }).notNull(),
	usuarioReportanteId: uuid("usuario_reportante_id").notNull(),
	categoriaId: uuid("categoria_id").notNull(),
	titulo: varchar({ length: 150 }).notNull(),
	descripcion: text().notNull(),
	fotoUrl: varchar("foto_url", { length: 500 }).notNull(),
	ubicacionEncontrado: varchar("ubicacion_encontrado", { length: 255 }).notNull(),
	estado: reportesEstadoEnum().default('PENDIENTE').notNull(),
	activatedBy: uuid("activated_by"),
	activatedAt: timestamp("activated_at", { mode: 'string' }),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	index("idx_reportes_categoria_id").using("btree", table.categoriaId.asc().nullsLast().op("uuid_ops")),
	index("idx_reportes_codigo").using("btree", table.codigo.asc().nullsLast().op("text_ops")),
	index("idx_reportes_estado").using("btree", table.estado.asc().nullsLast().op("enum_ops")),
	index("idx_reportes_feed").using("btree", table.estado.asc().nullsLast().op("timestamp_ops"), table.createdAt.asc().nullsLast().op("timestamp_ops")),
	index("idx_reportes_usuario_reportante_id").using("btree", table.usuarioReportanteId.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.categoriaId],
			foreignColumns: [categorias.id],
			name: "fk_categorias_reportes"
		}).onDelete("restrict"),
	foreignKey({
			columns: [table.activatedBy],
			foreignColumns: [usuarios.id],
			name: "fk_usuarios_reportes_activador"
		}).onDelete("set null"),
	foreignKey({
			columns: [table.usuarioReportanteId],
			foreignColumns: [usuarios.id],
			name: "fk_usuarios_reportes_reportante"
		}).onDelete("restrict"),
	unique("reportes_codigo_key").on(table.codigo),
]);

export const identidadesUsuario = pgTable("identidades_usuario", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	usuarioId: uuid("usuario_id").notNull(),
	proveedor: varchar({ length: 50 }).notNull(),
	identificadorExterno: varchar("identificador_externo", { length: 255 }).notNull(),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	index("idx_identidades_usuario_id").using("btree", table.usuarioId.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.usuarioId],
			foreignColumns: [usuarios.id],
			name: "fk_usuarios_identidades_usuario"
		}).onDelete("cascade"),
	unique("uq_identidad_proveedor_externo").on(table.proveedor, table.identificadorExterno),
]);

export const categorias = pgTable("categorias", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	nombre: varchar({ length: 100 }).notNull(),
	descripcion: text(),
	activa: boolean().default(true).notNull(),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	unique("categorias_nombre_key").on(table.nombre),
]);

export const roles = pgTable("roles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	codigo: varchar({ length: 50 }).notNull(),
	nombre: varchar({ length: 100 }).notNull(),
	descripcion: text(),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	unique("roles_codigo_key").on(table.codigo),
]);

export const registrosAuditoria = pgTable("registros_auditoria", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	usuarioId: uuid("usuario_id"),
	tipoEntidad: varchar("tipo_entidad", { length: 50 }).notNull(),
	entidadId: uuid("entidad_id").notNull(),
	accion: varchar({ length: 50 }).notNull(),
	datosAnteriores: jsonb("datos_anteriores"),
	datosNuevos: jsonb("datos_nuevos"),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	index("idx_auditoria_creado_at").using("btree", table.createdAt.asc().nullsLast().op("timestamp_ops")),
	index("idx_auditoria_entidad").using("btree", table.entidadId.asc().nullsLast().op("text_ops"), table.tipoEntidad.asc().nullsLast().op("text_ops")),
	index("idx_auditoria_usuario_id").using("btree", table.usuarioId.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.usuarioId],
			foreignColumns: [usuarios.id],
			name: "fk_usuarios_registros_auditoria"
		}).onDelete("set null"),
]);

export const devoluciones = pgTable("devoluciones", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	reporteId: uuid("reporte_id").notNull(),
	usuarioSeguridadId: uuid("usuario_seguridad_id").notNull(),
	usuarioReceptorId: uuid("usuario_receptor_id"),
	nombreReceptor: varchar("nombre_receptor", { length: 255 }).notNull(),
	correoReceptor: varchar("correo_receptor", { length: 255 }).notNull(),
	metodoVerificacion: varchar("metodo_verificacion", { length: 100 }).notNull(),
	observaciones: text(),
	returnedAt: timestamp("returned_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	createdAt: timestamp("created_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	cedulaReceptor: varchar("cedula_receptor", { length: 255 }).notNull(),
}, (table) => [
	index("idx_devoluciones_reporte_id").using("btree", table.reporteId.asc().nullsLast().op("uuid_ops")),
	index("idx_devoluciones_usuario_receptor_id").using("btree", table.usuarioReceptorId.asc().nullsLast().op("uuid_ops")),
	index("idx_devoluciones_usuario_seguridad_id").using("btree", table.usuarioSeguridadId.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.reporteId],
			foreignColumns: [reportes.id],
			name: "fk_reportes_devoluciones"
		}).onDelete("restrict"),
	foreignKey({
			columns: [table.usuarioReceptorId],
			foreignColumns: [usuarios.id],
			name: "fk_usuarios_devoluciones_receptor"
		}).onDelete("set null"),
	foreignKey({
			columns: [table.usuarioSeguridadId],
			foreignColumns: [usuarios.id],
			name: "fk_usuarios_devoluciones_seguridad"
		}).onDelete("restrict"),
	unique("devoluciones_reporte_id_key").on(table.reporteId),
]);
