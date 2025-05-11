-- Obtener o insertar Lugar (Place)
CREATE OR REPLACE FUNCTION geo.fn_get_or_insert_place(p_place_name VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    v_id_place VARCHAR;
    v_clean_name VARCHAR := p_place_name; -- Usar el nombre original para la columna 'place'
BEGIN
    v_id_place := music.fn_generate_md5_id(p_place_name);

    INSERT INTO geo.places (id_place, place)
    VALUES (v_id_place, v_clean_name)
    ON CONFLICT (id_place) DO NOTHING;

    RETURN v_id_place;
END;
$$ LANGUAGE plpgsql;


select music.fn_get_or_insert_place('Test Place');
select * from geo.places p where place like 'Test%';

delete from geo.places where place like 'Test Pla%';

-- Obtener o insertar Género (Genre)
CREATE OR REPLACE FUNCTION music.fn_get_or_insert_genre(p_genre_name VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    v_id_genre VARCHAR;
    v_clean_name VARCHAR := p_genre_name;
BEGIN
    v_id_genre := music.fn_generate_md5_id(p_genre_name);

    INSERT INTO music.genres (id_genre, genre)
    VALUES (v_id_genre, v_clean_name)
    ON CONFLICT (id_genre) DO NOTHING;

    RETURN v_id_genre;
END;
$$ LANGUAGE plpgsql;

select music.fn_get_or_insert_genre('Test Genre');
select * from music.genres g where genre like 'Test%';

delete from music.genres where genre like 'Test Genr%';


-- Obtener o insertar Banda (Band)
CREATE OR REPLACE FUNCTION music.fn_get_or_insert_band(
    p_band_name VARCHAR,
    p_likes VARCHAR,
    p_active BOOLEAN,
    p_note VARCHAR
)
RETURNS VARCHAR AS $$
DECLARE
    v_id_band VARCHAR;
    -- Usar la nota para generar el ID si se proporciona, para diferenciar bandas homónimas
    v_name_for_hash VARCHAR := p_band_name || COALESCE('_' || p_note, '');
BEGIN
    v_id_band := music.fn_generate_md5_id(v_name_for_hash);

    INSERT INTO music.bands (id_band, band, likes, active, note)
    VALUES (v_id_band, p_band_name, p_likes, p_active, p_note)
    ON CONFLICT (id_band) DO UPDATE
    SET -- Decide qué hacer en caso de conflicto. ¿Actualizar? ¿Ignorar?
        -- Por ejemplo, podríamos querer actualizar 'likes', 'active', 'note' si la banda ya existe.
        likes = EXCLUDED.likes,
        active = EXCLUDED.active,
        note = EXCLUDED.note;
        -- O simplemente DO NOTHING si no se deben modificar bandas existentes a través de este proceso.
        -- ON CONFLICT (id_band) DO NOTHING;


    RETURN v_id_band;
END;
$$ LANGUAGE plpgsql;


select music.fn_get_or_insert_band('Test Band', 'm', false, 'testing...');
select * from music.bands g where band like 'Test Ba%';

delete from music.bands where band like 'Test Ban%';

drop function music.fn_get_or_insert_place(varchar);



CREATE OR REPLACE PROCEDURE music.sp_insert_event_data(event_data JSONB)
LANGUAGE plpgsql
AS $$
DECLARE
    v_event_name VARCHAR;
    v_event_date DATE;
    v_place_name VARCHAR;
    v_persons INT;
    v_price DECIMAL;
    v_duration INT;
    v_event_note VARCHAR;
    v_id_place VARCHAR;
    v_id_event VARCHAR;
    v_event_name_for_hash VARCHAR;

    band_record JSONB;
    v_band_name VARCHAR;
    v_is_new BOOLEAN;
    v_likes VARCHAR;
    v_active BOOLEAN;
    v_band_note VARCHAR;
    v_id_band VARCHAR;

    country_id_text TEXT;
    v_id_country VARCHAR;

    genre_name_text TEXT;
    v_id_genre VARCHAR;

BEGIN
    -- Extraer datos del evento del JSON
    v_event_name := event_data->'event'->>'name';
    v_event_date := (event_data->'event'->>'date')::DATE;
    v_place_name := event_data->'event'->>'placeName';
    v_persons    := (event_data->'event'->>'persons')::INT;
    v_price      := (event_data->'event'->>'price')::DECIMAL;
    v_duration   := (event_data->'event'->>'duration')::INT;
    v_event_note := event_data->'event'->>'note';

    -- Validar datos básicos (ejemplo simple)
    IF v_event_name IS NULL OR v_event_date IS NULL OR v_place_name IS NULL THEN
        RAISE EXCEPTION 'Datos del evento incompletos: nombre, fecha y lugar son requeridos.';
    END IF;

    -- 1. Obtener o insertar el lugar y obtener su ID
    v_id_place := geo.fn_get_or_insert_place(v_place_name);

    -- 2. Generar ID del evento e insertar el evento
    v_event_name_for_hash := v_event_name; -- Asumimos que el nombre del evento es suficiente para el hash
    v_id_event := music.fn_generate_md5_id(v_event_name_for_hash);

    INSERT INTO music.events (id_event, event, date_event, id_place, duration, price, persons, note)
    VALUES (v_id_event, v_event_name, v_event_date, v_id_place, v_duration, v_price, v_persons, v_event_note)
    ON CONFLICT (id_event) DO NOTHING; -- O manejar el conflicto si un evento con ese ID ya existe

    -- Si el ON CONFLICT hizo que no se insertara, podríamos querer detenernos o continuar
    -- Se puede verificar con GET DIAGNOSTICS row_count = ROW_COUNT; if row_count = 0 then ...

    -- 3. Procesar las bandas
    FOR band_record IN SELECT * FROM jsonb_array_elements(event_data->'bands')
    LOOP
        v_band_name := band_record->>'name';
        v_is_new    := (band_record->>'isNew')::BOOLEAN;
        v_id_band   := NULL; -- Resetear para cada banda

        IF v_band_name IS NULL THEN
            RAISE WARNING 'Registro de banda sin nombre ignorado en el evento %', v_event_name;
            CONTINUE;
        END IF;

        -- Definir el nombre a usar para el hash (considerando la nota si existe)
        v_band_note := band_record->>'note'; -- Puede ser NULL
        DECLARE
           v_name_for_hash VARCHAR := v_band_name || COALESCE('_' || v_band_note, '');
        BEGIN
           v_id_band := music.fn_generate_md5_id(v_name_for_hash);
        END;


        -- Si la banda es nueva, insertarla (o actualizarla)
        IF v_is_new THEN
            v_likes     := band_record->>'likes';
            v_active    := (band_record->>'active')::BOOLEAN;
            -- v_band_note ya está asignada

            IF v_likes IS NULL OR v_active IS NULL THEN
                 RAISE WARNING 'Datos incompletos para la nueva banda "%". Se usarán valores por defecto o se ignorará.', v_band_name;
                 -- Podrías poner valores por defecto aquí o lanzar un error más fuerte
                 v_likes := COALESCE(v_likes, 'm'); -- Default a neutral
                 v_active := COALESCE(v_active, true); -- Default a activa
            END IF;

            -- Insertar o actualizar banda (la función maneja la lógica ON CONFLICT)
            PERFORM music.fn_get_or_insert_band(v_band_name, v_likes, v_active, v_band_note);

            -- Insertar Géneros asociados a la nueva banda
            IF jsonb_typeof(band_record->'genres') = 'array' THEN
                FOR genre_name_text IN SELECT * FROM jsonb_array_elements_text(band_record->'genres')
                LOOP
                    v_id_genre := music.fn_get_or_insert_genre(genre_name_text);
                    -- Vincular banda y género
                    INSERT INTO music.bands_genres (id_band, id_genre)
                    VALUES (v_id_band, v_id_genre)
                    ON CONFLICT (id_band, id_genre) DO NOTHING;
                END LOOP;
            END IF;

             -- Insertar Países asociados a la nueva banda
            IF jsonb_typeof(band_record->'countryIds') = 'array' THEN
                FOR country_id_text IN SELECT * FROM jsonb_array_elements_text(band_record->'countryIds')
                LOOP
                    v_id_country := UPPER(country_id_text); -- Asume que el ID proporcionado es válido

                    -- Opcional: Verificar si el país existe antes de insertar el vínculo
                    -- PERFORM 1 FROM geo.countries WHERE id_country = v_id_country;
                    -- IF NOT FOUND THEN
                    --     RAISE WARNING 'El país con ID % para la banda % no existe en geo.countries. El vínculo no se creará.', v_id_country, v_band_name;
                    --     CONTINUE;
                    -- END IF;

                    -- Vincular banda y país
                    INSERT INTO music.bands_countries (id_band, id_country)
                    VALUES (v_id_band, v_id_country)
                    ON CONFLICT (id_band, id_country) DO NOTHING;
                END LOOP;
            END IF;

        -- ELSE -- La banda no es nueva, solo necesitamos su ID (ya calculado arriba)
           -- No es necesario hacer nada más aquí para la banda en sí, ya que asumimos que existe
           -- y ya calculamos su ID basado en nombre y posible nota.
           -- Si fn_get_or_insert_band usara ON CONFLICT DO NOTHING, necesitaríamos un SELECT aquí
           -- para asegurar que v_id_band tiene el valor correcto si la banda ya existía.
           -- Pero como fn_get_or_insert_band devuelve el ID (existente o nuevo), ya lo tenemos.
        END IF;

        -- 4. Vincular Banda y Evento (independientemente de si era nueva o no)
        IF v_id_band IS NOT NULL AND v_id_event IS NOT NULL THEN
             INSERT INTO music.bands_events (id_band, id_event)
             VALUES (v_id_band, v_id_event)
             ON CONFLICT (id_band, id_event) DO NOTHING;
        ELSE
             RAISE WARNING 'No se pudo vincular la banda "%" al evento "%" por falta de IDs.', v_band_name, v_event_name;
        END IF;

    END LOOP; -- Fin del loop de bandas

END;
$$;