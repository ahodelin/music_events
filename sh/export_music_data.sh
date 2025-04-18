#!/bin/bash

# --- Configuración ---
DB_NAME="music_events"
DB_USER="postgres" # Cambia por tu usuario de PostgreSQL
DB_HOST="localhost" # O la IP/hostname si no es local
# Directorio de salida DENTRO de la carpeta del sitio web
# Asume que este script está UN NIVEL ARRIBA del directorio music_website
# Si no, ajusta la ruta relativa o usa una ruta absoluta
#PROJECT_DIR="$(dirname "$0")/music_website" # Directorio del sitio web
PROJECT_DIR=".."
OUTPUT_DIR="$PROJECT_DIR/data_js" # Directorio donde se guardarán los JS

# Lista de vistas y variables JS correspondientes
# Formato: "schema;view_name;js_variable_name;output_filename.js"
VIEWS_TO_EXPORT=(
    "music;v_band_full_details;musicData_Bands;bands_data.js"
    "music;v_event_details;musicData_Events;events_data.js"
    # Para el resumen, usaremos row_to_json directamente en la consulta
    # "music;v_summary_stats;musicData_Summary;summary_data.js"
    "music;v_chart_events_per_year;musicData_ChartEventsYear;chart_events_year_data.js"
    #"music;v_chart_events_per_month;musicData_ChartEventsMonth;chart_events_month_data.js"
    "music;v_chart_top_places;musicData_ChartTopPlaces;chart_top_places_data.js"
    "music;v_chart_top_bands;musicData_ChartTopBands;chart_top_bands_data.js"
    "music;v_chart_top_genres;musicData_ChartTopGenres;chart_top_genres_data.js"
    "music;v_chart_spending_per_year;musicData_ChartSpendingYear;chart_spending_year_data.js"
    "music;v_chart_likes_distribution;musicData_ChartLikes;chart_likes_data.js"
)

# --- Crear directorio de salida si no existe ---
mkdir -p "$OUTPUT_DIR"
if [ $? -ne 0 ]; then
    echo "Error: No se pudo crear el directorio de salida '$OUTPUT_DIR'."
    exit 1
fi
echo "Directorio de salida para JS: $OUTPUT_DIR"

# --- Función para exportar una vista a JS (como array) ---
export_view_to_js_array() {
    local schema_name=$1
    local view_name=$2
    local var_name=$3
    local output_file=$4
    local full_view_name="$schema_name.$view_name"
    local output_path="$OUTPUT_DIR/$output_file"

    echo "Generando JS '$output_file' para vista '$full_view_name' (variable: $var_name)..."

    # Obtener JSON compacto (sin pretty print) como un array
    local json_data
    json_data=$(psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -A -t -q \
                     -c "SELECT jsonb_agg(row_to_json(t)) FROM (SELECT * FROM ${full_view_name}) t;")

    # Verificar si psql tuvo éxito y si la salida no está vacía
    if [ $? -ne 0 ] || [ -z "$json_data" ]; then
        echo "Advertencia: No se obtuvieron datos o hubo un error para '$full_view_name'. Generando array vacío."
        json_data="[]" # Generar un array vacío si no hay datos o hay error
    fi

    # Crear el contenido del archivo .js
    # Usar 'const' para la variable
    echo "const ${var_name} = ${json_data};" > "$output_path"

    if [ $? -ne 0 ]; then
        echo "Error escribiendo el archivo JS '$output_path'."
    else
        echo "Archivo JS '$output_file' generado con éxito."
    fi
}

# --- Función ESPECIAL para exportar el resumen (como objeto único) ---
export_summary_to_js_object() {
    local schema_name="music"
    local view_name="v_summary_stats"
    local var_name="musicData_Summary"
    local output_file="summary_data.js"
    local full_view_name="$schema_name.$view_name"
    local output_path="$OUTPUT_DIR/$output_file"

     echo "Generando JS '$output_file' para vista '$full_view_name' (variable: $var_name)..."

    # Obtener JSON compacto (sin pretty print) como un objeto único
    # Usamos row_to_json en la primera (y única) fila
    local json_data
    json_data=$(psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -A -t -q \
                     -c "SELECT row_to_json(t) FROM (SELECT * FROM ${full_view_name} LIMIT 1) t;")

    # Verificar si psql tuvo éxito y si la salida no está vacía
    if [ $? -ne 0 ] || [ -z "$json_data" ]; then
        echo "Advertencia: No se obtuvieron datos o hubo un error para '$full_view_name'. Generando objeto vacío."
        json_data="{}" # Generar un objeto vacío si no hay datos o hay error
    fi

    # Crear el contenido del archivo .js
    echo "const ${var_name} = ${json_data};" > "$output_path"

     if [ $? -ne 0 ]; then
        echo "Error escribiendo el archivo JS '$output_path'."
    else
        echo "Archivo JS '$output_file' generado con éxito."
    fi
}


# --- Ejecutar exportaciones ---

# Exportar el resumen como objeto
export_summary_to_js_object

# Exportar las demás vistas como arrays
for item in "${VIEWS_TO_EXPORT[@]}"; do
    # Separar los componentes usando ; como delimitador
    IFS=';' read -r schema view varname filename <<< "$item"
    export_view_to_js_array "$schema" "$view" "$varname" "$filename"
done

echo "--- Proceso de exportación a JS finalizado ---"
