-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TYPE "public"."reportes_estado_enum" AS ENUM('PENDIENTE', 'ACTIVO', 'DEVUELTO');--> statement-breakpoint
CREATE TABLE "usuarios" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"rol_id" uuid NOT NULL,
	"nombre" varchar(150) NOT NULL,
	"apellido" varchar(150) NOT NULL,
	"correo" varchar(255) NOT NULL,
	"activo" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "usuarios_correo_key" UNIQUE("correo")
);
--> statement-breakpoint
ALTER TABLE "usuarios" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "reportes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"codigo" varchar(30) NOT NULL,
	"usuario_reportante_id" uuid NOT NULL,
	"categoria_id" uuid NOT NULL,
	"titulo" varchar(150) NOT NULL,
	"descripcion" text NOT NULL,
	"foto_url" varchar(500) NOT NULL,
	"ubicacion_encontrado" varchar(255) NOT NULL,
	"estado" "reportes_estado_enum" DEFAULT 'PENDIENTE' NOT NULL,
	"activated_by" uuid,
	"activated_at" timestamp,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "reportes_codigo_key" UNIQUE("codigo")
);
--> statement-breakpoint
ALTER TABLE "reportes" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "identidades_usuario" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"usuario_id" uuid NOT NULL,
	"proveedor" varchar(50) NOT NULL,
	"identificador_externo" varchar(255) NOT NULL,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "uq_identidad_proveedor_externo" UNIQUE("proveedor","identificador_externo")
);
--> statement-breakpoint
ALTER TABLE "identidades_usuario" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "categorias" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"nombre" varchar(100) NOT NULL,
	"descripcion" text,
	"activa" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "categorias_nombre_key" UNIQUE("nombre")
);
--> statement-breakpoint
ALTER TABLE "categorias" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "roles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"codigo" varchar(50) NOT NULL,
	"nombre" varchar(100) NOT NULL,
	"descripcion" text,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "roles_codigo_key" UNIQUE("codigo")
);
--> statement-breakpoint
ALTER TABLE "roles" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "registros_auditoria" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"usuario_id" uuid,
	"tipo_entidad" varchar(50) NOT NULL,
	"entidad_id" uuid NOT NULL,
	"accion" varchar(50) NOT NULL,
	"datos_anteriores" jsonb,
	"datos_nuevos" jsonb,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
ALTER TABLE "registros_auditoria" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "devoluciones" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"reporte_id" uuid NOT NULL,
	"usuario_seguridad_id" uuid NOT NULL,
	"usuario_receptor_id" uuid,
	"nombre_receptor" varchar(255) NOT NULL,
	"correo_receptor" varchar(255) NOT NULL,
	"metodo_verificacion" varchar(100) NOT NULL,
	"observaciones" text,
	"returned_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"cedula_receptor" varchar(255) NOT NULL,
	CONSTRAINT "devoluciones_reporte_id_key" UNIQUE("reporte_id")
);
--> statement-breakpoint
ALTER TABLE "devoluciones" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
ALTER TABLE "usuarios" ADD CONSTRAINT "fk_roles_usuarios" FOREIGN KEY ("rol_id") REFERENCES "public"."roles"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reportes" ADD CONSTRAINT "fk_categorias_reportes" FOREIGN KEY ("categoria_id") REFERENCES "public"."categorias"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reportes" ADD CONSTRAINT "fk_usuarios_reportes_activador" FOREIGN KEY ("activated_by") REFERENCES "public"."usuarios"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reportes" ADD CONSTRAINT "fk_usuarios_reportes_reportante" FOREIGN KEY ("usuario_reportante_id") REFERENCES "public"."usuarios"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "identidades_usuario" ADD CONSTRAINT "fk_usuarios_identidades_usuario" FOREIGN KEY ("usuario_id") REFERENCES "public"."usuarios"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "registros_auditoria" ADD CONSTRAINT "fk_usuarios_registros_auditoria" FOREIGN KEY ("usuario_id") REFERENCES "public"."usuarios"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "devoluciones" ADD CONSTRAINT "fk_reportes_devoluciones" FOREIGN KEY ("reporte_id") REFERENCES "public"."reportes"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "devoluciones" ADD CONSTRAINT "fk_usuarios_devoluciones_receptor" FOREIGN KEY ("usuario_receptor_id") REFERENCES "public"."usuarios"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "devoluciones" ADD CONSTRAINT "fk_usuarios_devoluciones_seguridad" FOREIGN KEY ("usuario_seguridad_id") REFERENCES "public"."usuarios"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "idx_usuarios_correo" ON "usuarios" USING btree ("correo" text_ops);--> statement-breakpoint
CREATE INDEX "idx_usuarios_rol_id" ON "usuarios" USING btree ("rol_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_reportes_categoria_id" ON "reportes" USING btree ("categoria_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_reportes_codigo" ON "reportes" USING btree ("codigo" text_ops);--> statement-breakpoint
CREATE INDEX "idx_reportes_estado" ON "reportes" USING btree ("estado" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_reportes_feed" ON "reportes" USING btree ("estado" timestamp_ops,"created_at" timestamp_ops);--> statement-breakpoint
CREATE INDEX "idx_reportes_usuario_reportante_id" ON "reportes" USING btree ("usuario_reportante_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_identidades_usuario_id" ON "identidades_usuario" USING btree ("usuario_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_auditoria_creado_at" ON "registros_auditoria" USING btree ("created_at" timestamp_ops);--> statement-breakpoint
CREATE INDEX "idx_auditoria_entidad" ON "registros_auditoria" USING btree ("entidad_id" text_ops,"tipo_entidad" text_ops);--> statement-breakpoint
CREATE INDEX "idx_auditoria_usuario_id" ON "registros_auditoria" USING btree ("usuario_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_devoluciones_reporte_id" ON "devoluciones" USING btree ("reporte_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_devoluciones_usuario_receptor_id" ON "devoluciones" USING btree ("usuario_receptor_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_devoluciones_usuario_seguridad_id" ON "devoluciones" USING btree ("usuario_seguridad_id" uuid_ops);
*/