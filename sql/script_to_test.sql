delete from music.bands_events where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_events where id_event = md5(lower(regexp_replace('Test Event', '\s|\W', '', 'g')));
delete from music.bands_countries where id_country = 'TCC';
delete from music.bands_countries where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_generes where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_generes where id_genere = md5(lower(regexp_replace('Test Genre', '\s|\W', '', 'g')));

delete from music.events where id_event = md5(lower(regexp_replace('Test Event', '\s|\W', '', 'g')));
delete from geo.places where id_place = md5(lower(regexp_replace('Test Place', '\s|\W', '', 'g')));
delete from music.bands where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.generes where id_genere = md5(lower(regexp_replace('Test Genre', '\s|\W', '', 'g')));
delete from geo.countries where country = 'Test Country';


insert into geo.countries 
  values 
    ('TCC', 'Test Country', 'tc');

   
select * from music.bands b where band like 'Test%';
select * from music.events where "event" like 'Tes%';
select * from music.generes g where genere like 'Tes%';
select * from geo.countries c where id_country = 'TCC';
select * from geo.places p where place = 'Test Place';


DROP FUNCTION music.insert_bands_to_genres_new(varchar, varchar);


select music.insert_bands_to_genres_new('Test Band', 'Test Genre');

