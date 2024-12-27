delete from music.bands_events where id_event = md5(lower(regexp_replace('Test Event', '\s|\W', '', 'g')));
delete from music.bands_countries where id_country = 'TCC';
delete from music.bands_countries where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_genres where id_band = md5(lower(regexp_replace('Test Band', '\s|\W', '', 'g')));
delete from music.bands_genres where id_genre = md5(lower(regexp_replace('Test Genre', '\s|\W', '', 'g')));

delete from music.events where "event" = 'Test Event';
delete from geo.places where id_place = md5(lower(regexp_replace('Test Place', '\s|\W', '', 'g')));
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


delete from music.bands b where band like 'Humanity%';

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
   
  


select genre, case 
	when band_like isnull then 0
	else band_like
end
band_like, 
case 
	when band_no_like isnull then 0
	else band_no_like
end
band_no_like, case 
	when band_like is null and band_no_like notnull then 0 - band_no_like
	when band_like notnull and band_no_like is null then band_like - 0
	when band_like is null and band_no_like is null then 0
	else band_like - band_no_like
end
delta_like from music.genres g 
left join
(select bg.id_genre, count(yb.likes) as band_like from music.bands_genres bg
join music.bands yb
  on yb.id_band = bg.id_band 
where yb.likes = 'y'
group by bg.id_genre) as b_like
  on b_like.id_genre = g.id_genre
left join 
(select bg.id_genre, count(nb.likes) as band_no_like from music.bands_genres bg
join music.bands nb
  on nb.id_band = bg.id_band
where nb.likes = 'n' or nb.likes = 'm'
group by bg.id_genre) as b_no_like
  on b_no_like.id_genre = g.id_genre 
order by delta_like desc;


select b.band from music.bands b where id_band not in (select vb.id_band from music.v_bands vb);

select e."event" from music.events e where e.id_event not in (select ve.id_event from music.v_events ve);

select e.date_event, e."event" 
from music.events e
where (date_part('month', e.date_event) = '12' and date_part('day', e.date_event) = '15') or 
(date_part('month', e.date_event) = '11' and date_part('day', e.date_event) = '25')
order by date_part('month', e.date_event); 



select * from music.events e where id_place = '17648f3308a5acb119d9aee1b5eafceb';

select md5(lower(regexp_replace('Live on stage', '\s|\W', '', 'g'))), 'Live on stage';

update music.events
set id_event = md5(lower(regexp_replace('Hutkonzert - 19.10.2023', '\s|\W', '', 'g'))), "event" = 'Hutkonzert - 19.10.2023'
where id_event = '79880b3852adb21098807cc10effe071';




