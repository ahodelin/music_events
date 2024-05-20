delete from music.bands_events where id_event = md5('Test Event');
delete from music.bands_events where id_band = md5('Test Band');


delete from music.bands_generes where id_genere = md5('Test Genre');
delete from music.bands_generes where id_band = md5('Test Band');

delete from music.bands_countries where id_country = 'TCC';
delete from music.bands_countries where id_band = md5('Test Band');

delete from geo.countries where country = 'Test Country';
delete from music.generes where genere = 'Test Genre';
delete from music.bands where band = 'Test Band';
delete from music.events where "event" = 'Test Event';
delete from geo.places where place = 'Test Place';


-- select * from music.bands_countries bc where id_country = md5('Test Country'); 

select * from geo.countries c where country = 'Test Country';
select * from music.bands b where band = 'Test Band';
select * from music.generes g where genere = 'Test Genre';
select * from music.events e where "event" = 'Test Event';
