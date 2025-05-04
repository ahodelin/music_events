#!/bin/bash

# --- Configuración ---
DB_NAME="music_events"
DB_USER="postgres" # O usa variables de entorno PGUSER
DB_HOST="localhost"    # O usa variables de entorno PGHOST
DB_PORT="5432"       # O usa variables de entorno PGPORT
# Asegúrate de que la autenticación esté configurada (ej. ~/.pgpass o variable PGPASSWORD)

# Directorio donde se encuentran los ficheros JSON de eventos
JSON_DIR="./new_events"

# --- Validación ---
if ! command -v psql &> /dev/null; then
    echo "Error: Comando 'psql' no encontrado. Asegúrate de que PostgreSQL client esté instalado y en el PATH."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: Comando 'jq' no encontrado. Instálalo (ej. sudo apt install jq)."
    exit 1
fi

if [ ! -d "$JSON_DIR" ]; then
    echo "Error: Directorio de entrada '$JSON_DIR' no encontrado."
    exit 1
fi

# --- Procesamiento ---
echo "Procesando archivos JSON en $JSON_DIR..."

for json_file in "$JSON_DIR"/*.json; do
    if [ -f "$json_file" ]; then
        echo "-----------------------------------------------------"
        echo "Procesando archivo: $json_file"

        # Validar que el archivo es JSON válido (opcional pero recomendado)
        if ! jq empty "$json_file" > /dev/null 2>&1; then
            echo "Error: Archivo '$json_file' no es JSON válido. Saltando."
            continue
        fi

        # Leer el contenido del JSON en una variable, escapando para psql
        # Usamos jq para asegurar que es una sola línea y correctamente escapado para SQL string literal
        json_content=$(jq -c . "$json_file")

        # Construir el comando psql para llamar al procedimiento almacenado
        # Usamos -v ON_ERROR_STOP=1 para que el script se detenga si hay un error SQL
        # Pasamos el JSON como un string literal a la función
        psql_command="CALL music.sp_insert_event_data('${json_content}'::jsonb);"

        echo "Ejecutando comando en PostgreSQL..."
        # Ejecutar el comando
        # PGPASSWORD=$PGPASSWORD PGPASSWORD=tu_contraseña psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c "$psql_command"
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c "$psql_command"
	# Nota: Reemplaza 'tu_contraseña' o mejor usa ~/.pgpass

        # Verificar el código de salida de psql
        if [ $? -eq 0 ]; then
            echo "Archivo '$json_file' procesado exitosamente."
            # Opcional: Mover el archivo procesado a otro directorio
            # mv "$json_file" "$JSON_DIR/processed/"
        else
            echo "Error: Hubo un problema al procesar '$json_file' con psql."
            # Podrías moverlo a un directorio de errores
            # mv "$json_file" "$JSON_DIR/error/"
        fi
    fi
done

echo "-----------------------------------------------------"
echo "Proceso completado."
