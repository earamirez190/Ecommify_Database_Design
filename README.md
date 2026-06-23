# 📘 Materia: Diseño y Optimización de Bases de Datos

## Entrega

Se hace entrega a través del siguiente link de github en donde se encontrara el repositorio

Link: https://github.com/earamirez190/Ecommify_Database_Design/tree/main

## 👥 Integrantes

| Nombre completo                          | Código Estudiante |
|------------------------------------------|-------------------|
| Santiago Eduardo Muñoz Castillo          | 0000394453        |
| Edward Augusto Ramirez Rodriguez         | 0000324316        |
| Wolfran Alirio Pinzon Murillo            | 0000393439        |
| Henry Julian Salazar Salcedo             | 0000396117        |
|------------------------------------------|-------------------|

📅 **Semestre:** 2026-1


## 🛠️ Guía de Configuración Local

Para ejecutar el proyecto en su máquina, siga estos pasos:

### Opción A: Despliegue Local (Entorno de desarrollo)

1. **Prerrequisitos:** PostgreSQL 14+ instalado y ejecutándose localmente.
2. **Setup:**
   - Cree un schema llamado `ecommify_olist_analytics`. para cargar las estrutura de entidades y datos optimizada, carpeta -> postgresql/schemaEcommify_olist_analytics
   - Usa el schema por default `public`. para cargar el dataset  de entrada para el análisis de datos EDA,  carpeta -> postgresql/schemaPublic
   - Ejecute los scripts desde la carpeta `/postgresql` en el orden: `postgresql/schemaPublic/Modelo Fisico.sql` (estructuras) y `postgresql/seed_data/` (si aplica).
   - Ejecute los scripts desde la carpeta `/postgresql` en el orden: `postgresql/schemaEcommify_olist_analytics/Modelo Fisico Optimizado Indices .sql` (estructuras) y `postgresql/seed_data/` (si aplica).
   - Puede usar herramientas como pgAdmin, DBeaver o la terminal `psql`.

### Opción B: Despliegue en la Nube (Supabase)

Si prefieren evaluar el proyecto utilizando una instancia en la nube:
1. **Configuración:**
   - Cree un nuevo proyecto en [Supabase](https://supabase.com/).
   - Cree un schema llamado `ecommify_olist_analytics`. para cargar las estrutura de entidades y datos optimizada, carpeta -> postgresql/schemaEcommify_olist_analytics
   - En la sección **SQL Editor** del dashboard de Supabase, copie y pegue el contenido de los archivos `.sql` ubicados en la carpeta `/postgresql`.
   - Ejecute el script (Run). Supabase manejará automáticamente las extensiones y tipos avanzados que hemos configurado.
2. **Conexión:**
   - Utilice la cadena de conexión provista por Supabase (se encuentra en *Project Settings > Database*) para conectar sus notebooks o aplicaciones cliente.

### Configuración de MongoDB
1. Acceda a su instancia de MongoDB (Atlas o local).
2. Ejecute los scripts de la carpeta `/mongodb/schema` para crear colecciones e insertar los datos iniciales:
   ```bash
   mongosh "tu_connection_string" --file mongodb/setup.js


