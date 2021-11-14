-- Bands
copy (select row_to_json(t)
from (select * from music.v_bands) t)
to '/var/lib/postgresql/jsonBands.js'
;

-- Bands and Countries
copy (select row_to_json(t)
from (select * from music.bands_countries) t)
to '/var/lib/postgresql/jsonBandsCountries.js'
;

-- Bands and Events
copy (select row_to_json(t)
from (select * from music.bands_events) t)
to '/var/lib/postgresql/jsonBandsEvents.js'
;

-- Bands and Generes
copy (select row_to_json(t)
from (select * from music.bands_generes) t)
to '/var/lib/postgresql/jsonBandsGeneres.js'
;

-- Countries
copy (select row_to_json(t)
from (select * from music.v_countries) t)
to '/var/lib/postgresql/jsonCountries.js'
;

-- Events
copy (select row_to_json(t)
from (select * from music.v_events) t)
to '/var/lib/postgresql/jsonEvents.js'
;

-- Generes
copy (select row_to_json(t)
from (select * from music.v_generes) t)
to '/var/lib/postgresql/jsonGeneres.js'
