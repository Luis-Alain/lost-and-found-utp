import { relations } from "drizzle-orm/relations";
import { roles, usuarios, categorias, reportes, identidadesUsuario, registrosAuditoria, devoluciones } from "./schema";

export const usuariosRelations = relations(usuarios, ({one, many}) => ({
	role: one(roles, {
		fields: [usuarios.rolId],
		references: [roles.id]
	}),
	reportes_activatedBy: many(reportes, {
		relationName: "reportes_activatedBy_usuarios_id"
	}),
	reportes_usuarioReportanteId: many(reportes, {
		relationName: "reportes_usuarioReportanteId_usuarios_id"
	}),
	identidadesUsuarios: many(identidadesUsuario),
	registrosAuditorias: many(registrosAuditoria),
	devoluciones_usuarioReceptorId: many(devoluciones, {
		relationName: "devoluciones_usuarioReceptorId_usuarios_id"
	}),
	devoluciones_usuarioSeguridadId: many(devoluciones, {
		relationName: "devoluciones_usuarioSeguridadId_usuarios_id"
	}),
}));

export const rolesRelations = relations(roles, ({many}) => ({
	usuarios: many(usuarios),
}));

export const reportesRelations = relations(reportes, ({one, many}) => ({
	categoria: one(categorias, {
		fields: [reportes.categoriaId],
		references: [categorias.id]
	}),
	usuario_activatedBy: one(usuarios, {
		fields: [reportes.activatedBy],
		references: [usuarios.id],
		relationName: "reportes_activatedBy_usuarios_id"
	}),
	usuario_usuarioReportanteId: one(usuarios, {
		fields: [reportes.usuarioReportanteId],
		references: [usuarios.id],
		relationName: "reportes_usuarioReportanteId_usuarios_id"
	}),
	devoluciones: many(devoluciones),
}));

export const categoriasRelations = relations(categorias, ({many}) => ({
	reportes: many(reportes),
}));

export const identidadesUsuarioRelations = relations(identidadesUsuario, ({one}) => ({
	usuario: one(usuarios, {
		fields: [identidadesUsuario.usuarioId],
		references: [usuarios.id]
	}),
}));

export const registrosAuditoriaRelations = relations(registrosAuditoria, ({one}) => ({
	usuario: one(usuarios, {
		fields: [registrosAuditoria.usuarioId],
		references: [usuarios.id]
	}),
}));

export const devolucionesRelations = relations(devoluciones, ({one}) => ({
	reporte: one(reportes, {
		fields: [devoluciones.reporteId],
		references: [reportes.id]
	}),
	usuario_usuarioReceptorId: one(usuarios, {
		fields: [devoluciones.usuarioReceptorId],
		references: [usuarios.id],
		relationName: "devoluciones_usuarioReceptorId_usuarios_id"
	}),
	usuario_usuarioSeguridadId: one(usuarios, {
		fields: [devoluciones.usuarioSeguridadId],
		references: [usuarios.id],
		relationName: "devoluciones_usuarioSeguridadId_usuarios_id"
	}),
}));