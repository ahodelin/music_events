--\c music_events

-- Bands
copy (select row_to_json(t)|| ','
from (select * from music.v_bands) t)
to '/var/lib/postgresql/jsonBands.json'
;

-- Bands and Countries
copy (select row_to_json(t)|| ','
from (select * from music.bands_countries) t)
to '/var/lib/postgresql/jsonBandsCountries.json'
;

-- Bands and Events
copy (select row_to_json(t)|| ','
from (select * from music.bands_events) t)
to '/var/lib/postgresql/jsonBandsEvents.json'
;

-- Bands and Generes
copy (select row_to_json(t)|| ','
from (select * from music.bands_generes) t)
to '/var/lib/postgresql/jsonBandsGeneres.json'
;

-- Countries
copy (select row_to_json(t)|| ','
from (select * from music.v_countries) t)
to '/var/lib/postgresql/jsonCountries.json'
;

-- Events
copy (select row_to_json(t)|| ','
from (select * from music.v_events) t)
to '/var/lib/postgresql/jsonEvents.json'
;

-- Generes
copy (select row_to_json(t)|| ','
from (select * from music.v_generes) t)
to '/var/lib/postgresql/jsonGeneres.json';

/*
-- copy to latex
-- Auðn - Au\dh n
-- & - \& 
--   Apey & The Pea
--   Booze & Glory
*/
copy 
  (
    select * from music.v_bands_to_tex
  )
to '/var/lib/postgresql/Music_Events.csv' with delimiter ';' csv;
