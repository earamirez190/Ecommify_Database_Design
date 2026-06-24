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

*Requisitos*
- MongoDB Atlas (cluster M0) o instancia local
- Python 3.10+
- pymongo, pandas

*Instalación*
pip install pymongo pandas

*Conexión a MongoDB Atlas*

En Google Colab, configurar el Secret MONGO_URI (candado lateral).
No documentar la URI con contraseña en el repositorio.

from pymongo import MongoClient
from google.colab import userdata

uri = userdata.get("MONGO_URI")
client = MongoClient(uri)
db = client["ecommify_test"]

*Base de datos:* ecommify_test

*Colecciones principales:*
- productos (~1 200 documentos)
- reviews (~5 000 documentos)
- geolocation (~19 015 documentos)

*Scripts de carga (Unidad 3):*
- Unidad 3/script_insercion_datos_mongodb.py — productos + reviews desde CSV Olist
- Unidad 3/script_geolocation_mongodb.py — geolocation agregada por prefijo postal + índice 2dsphere
- Unidad 3/U3_Actividad1_Colab.ipynb — notebook completo

*Optimización (Unidad 5):*
- Unidad 5/Capturas/U5-completo-jun2026.ipynb — índices, explain, aggregation pipeline

---

*Colección productos* — catálogo con esquema flexible

{
  "product_id": "abc123...",
  "name": "Producto Ecommify ...",
  "category": "cama_mesa_banho",
  "specifications": {
    "tipo": "general",
    "peso_g": 500.0,
    "descripcion_largo": 120
  },
  "computed_metrics": {
    "total_units_sold": 150,
    "average_rating": 4.2
  }
}

*Colección reviews* — referenciada por product_id (no embebida)

{
  "product_id": "abc123...",
  "review_score": 5,
  "review_comment_title": "...",
  "review_creation_date": "..."
}

*Colección geolocation* — GeoJSON Point por prefijo postal

{
  "geolocation_zip_code_prefix": "01001",
  "location": {
    "type": "Point",
    "coordinates": [-46.63, -23.55]
  },
  "geolocation_city": "sao paulo",
  "geolocation_state": "SP",
  "metadata": { "record_count": 150 }
}

