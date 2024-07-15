delete from music.bands_events where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_events where id_event = md5(lower(regexp_replace('Test Event', '\s|\W', '', 'g')));
delete from music.bands_countries where id_country = 'TCC';
delete from music.bands_countries where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_genres where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_genres where id_genre = md5(lower(regexp_replace('Test Genre', '\s|\W', '', 'g')));

delete from music.events where id_event = md5(lower(regexp_replace('Test Event', '\s|\W', '', 'g')));
delete from geo.places where id_place = md5(lower(regexp_replace('Test Place', '\s|\W', '', 'g')));
delete from music.bands where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.genres where id_genre = md5(lower(regexp_replace('Test Genre', '\s|\W', '', 'g')));
delete from geo.countries where country = 'Test Country';


insert into geo.countries 
  values 
    ('TCC', 'Test Country', 'tc');

   
select * from music.bands b where band like 'Test%';
select * from music.events where "event" like 'Tes%';
select * from music.genres g where genre like 'Tes%';
select * from geo.countries c where id_country = 'TCC';
select * from geo.places p where place = 'Test Place';


DROP FUNCTION music.insert_bands_to_genres_new(varchar, varchar);


select music.insert_bands_to_genres_new('Test Band', 'Test Genre');

create view music.v_no_lovely_generes
as
select g.genere, count(b.likes) bands
from music.bands b 
join music.bands_generes bg 
  on b.id_band = bg.id_band 
join music.generes g 
  on bg.id_genere = g.id_genere 
where b.likes = 'n'
group by g.genere 
order by bands desc;



--- music.v_quantities source
drop view music.v_lovely_generes;

CREATE OR REPLACE VIEW music.v_quantities
AS SELECT 'bands'::text AS entities,
    count(*) AS quantity
   FROM music.bands
UNION
 SELECT 'events'::text AS entities,
    count(*) AS quantity
   FROM music.events
UNION
 SELECT 'places'::text AS entities,
    count(*) AS quantity
   FROM geo.places
UNION
 SELECT 'genres'::text AS entities,
    count(*) AS quantity
   FROM music.genres;
   
  
 insert into geo.countries values
      ('MYS', 'Malaysia', 'my');