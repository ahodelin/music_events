-- Conectar a la base de datos music_events
-- \c music_events

CREATE OR REPLACE VIEW music.v_band_full_details AS
SELECT
    b.id_band,
    b.band,
    b.likes,
    b.active,
    b.note AS band_note,
    -- Agregar géneros como un array de texto
    (SELECT array_agg(g.genre ORDER BY g.genre)
     FROM music.bands_genres bg
     JOIN music.genres g ON bg.id_genre = g.id_genre
     WHERE bg.id_band = b.id_band) AS genres,
    -- Agregar países (nombre y bandera) como un array de JSON objects
    (SELECT jsonb_agg(jsonb_build_object('country', c.country, 'flag', c.flag) ORDER BY c.country)
     FROM music.bands_countries bc
     JOIN geo.countries c ON bc.id_country = c.id_country
     WHERE bc.id_band = b.id_band) AS countries,
    -- Agregar continentes como un array de texto
    (SELECT array_agg(DISTINCT ct.continent ORDER BY ct.continent)
     FROM music.bands_countries bc
     JOIN geo.countries c ON bc.id_country = c.id_country
     JOIN geo.countries_continents cc ON c.id_country = cc.id_country
     JOIN geo.continents ct ON cc.id_continent = ct.id_continent
     WHERE bc.id_band = b.id_band) AS continents,
    -- Agregar eventos (nombre y lugar) como un array de JSON objects
    (SELECT jsonb_agg(jsonb_build_object('event', e.event, 'place', p.place, 'date', to_char(e.date_event, 'DD.MM.YYYY')) ORDER BY e.date_event)
     FROM music.bands_events be
     JOIN music.events e ON be.id_event = e.id_event
     JOIN geo.places p ON e.id_place = p.id_place
     WHERE be.id_band = b.id_band) AS events_attended
FROM
    music.bands b order by band;

-- Opcional: Comprobar la vista
-- SELECT * FROM music.v_band_full_details LIMIT 5;




drop view music.v_event_details;
CREATE OR REPLACE VIEW music.v_event_details AS
SELECT
    e.id_event,
    e.event,
    to_char(e.date_event, 'DD.MM.YYYY') date_event,
    EXTRACT(YEAR FROM e.date_event) AS event_year,
    EXTRACT(MONTH FROM e.date_event) AS event_month,
    p.place,
    e.duration + 1::smallint duration,
    e.price,
    e.persons,
    (e.price * e.persons) AS total_cost_household,
    e.note AS event_note,
    -- Contar bandas participantes en el evento
    (SELECT COUNT(be.id_band)
     FROM music.bands_events be
     WHERE be.id_event = e.id_event) AS band_count
FROM
    music.events e
JOIN
    geo.places p ON e.id_place = p.id_place order by e.date_event;

-- Opcional: Comprobar la vista
-- SELECT * FROM music.v_event_details LIMIT 5;



CREATE OR REPLACE VIEW music.v_summary_stats AS
SELECT
    -- Contar eventos únicos visitados
    (SELECT COUNT(DISTINCT id_event) FROM music.events) AS total_events,
    -- Contar bandas únicas vistas en eventos
    (SELECT COUNT(DISTINCT id_band) FROM music.bands_events) AS total_bands_seen,
    -- Calcular el gasto total considerando las personas del hogar
    (SELECT SUM(price * persons) FROM music.events WHERE price IS NOT NULL AND persons IS NOT NULL) AS total_money_spent;

-- Opcional: Comprobar la vista
-- SELECT * FROM music.v_summary_stats;



-- Eventos por año
CREATE OR REPLACE VIEW music.v_chart_events_per_year AS
SELECT
    EXTRACT(YEAR FROM date_event)::INTEGER AS year,
    COUNT(*) AS event_count
FROM music.events
GROUP BY year
ORDER BY year;

-- Eventos por mes (agregado de todos los años)
CREATE OR REPLACE VIEW music.v_chart_events_per_month AS
SELECT
    EXTRACT(MONTH FROM date_event)::INTEGER AS month,
    TO_CHAR(date_event, 'TMMonth') AS month_name, -- 'TMMonth' para nombres localizados si es posible
    COUNT(*) AS event_count
FROM music.events
GROUP BY month, month_name
ORDER BY month;

-- 5 Lugares más frecuentados
CREATE OR REPLACE VIEW music.v_chart_top_places AS
SELECT
    p.place,
    COUNT(e.id_event) AS visit_count
FROM music.events e
JOIN geo.places p ON e.id_place = p.id_place
GROUP BY p.place
ORDER BY visit_count DESC
LIMIT 5;

-- 5 Bandas más vistas
CREATE OR REPLACE VIEW music.v_chart_top_bands AS
SELECT
    b.band,
    COUNT(be.id_event) AS event_count
FROM music.bands_events be
JOIN music.bands b ON be.id_band = b.id_band
GROUP BY b.band
ORDER BY event_count DESC
LIMIT 5;

-- 5 Géneros más populares (basado en bandas vistas en eventos)
CREATE OR REPLACE VIEW music.v_chart_top_genres AS
SELECT
    g.genre,
    COUNT(DISTINCT be.id_band) AS band_count -- Contar bandas únicas de ese género vistas
FROM music.bands_events be
JOIN music.bands_genres bg ON be.id_band = bg.id_band
JOIN music.genres g ON bg.id_genre = g.id_genre
GROUP BY g.genre
ORDER BY band_count DESC
LIMIT 5;
-- Alternativa: Contar ocurrencias de género entre todas las bandas vistas
-- CREATE OR REPLACE VIEW music.v_chart_top_genres_alt AS
-- SELECT
--     g.genre,
--     COUNT(*) AS genre_occurrence_count
-- FROM music.bands_events be
-- JOIN music.bands_genres bg ON be.id_band = bg.id_band
-- JOIN music.genres g ON bg.id_genre = g.id_genre
-- GROUP BY g.genre
-- ORDER BY genre_occurrence_count DESC
-- LIMIT 5;


-- Gasto por año
CREATE OR REPLACE VIEW music.v_chart_spending_per_year AS
SELECT
    EXTRACT(YEAR FROM date_event)::INTEGER AS year,
    SUM(price * persons) AS total_spent
FROM music.events
WHERE price IS NOT NULL AND persons IS NOT NULL
GROUP BY year
ORDER BY year;

-- Distribución de preferencias (Likes)
CREATE OR REPLACE VIEW music.v_chart_likes_distribution AS
SELECT
    likes,
    CASE likes
        WHEN 'y' THEN 'Ja'
        WHEN 'm' THEN 'Neutral'
        WHEN 'n' THEN 'Nein'
        ELSE 'Desconocido'
    END AS preference,
    COUNT(*) AS band_count
FROM music.bands
GROUP BY likes, preference
ORDER BY
    CASE likes
        WHEN 'y' THEN 1
        WHEN 'm' THEN 2
        WHEN 'n' THEN 3
        ELSE 4
    END;