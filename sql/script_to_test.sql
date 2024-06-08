delete from music.bands_events where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_countries where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_generes where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));

delete from music.events where id_event = md5(lower(regexp_replace('Test Event', '\s|\W', '', 'g')));
delete from geo.places where id_place = md5(lower(regexp_replace('Test Place', '\s|\W', '', 'g')));
delete from music.bands where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.generes where id_genere = md5(lower(regexp_replace('Test Genre', '\s|\W', '', 'g')));
delete from geo.countries where country = 'Test Band';

