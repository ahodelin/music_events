
--CREATE OR REPLACE VIEW music.v_generes
--AS 
SELECT g.id_genere,
    g.genere,
    count(bg.id_band) AS bands
   FROM music.generes g
     JOIN music.bands_generes bg ON g.id_genere = bg.id_genere
     join music.bands b on b.id_band = bg.id_band 
where b.likes = 'n'
  GROUP BY g.genere, g.id_genere
  ORDER BY (count(bg.id_band)) DESC;

drop view music.v_eu_board_german_black_death_thrash; 
--create or replace view music.v_eu_to_metalembrace
--as
select 
  distinct b.band "Band", 
  cou.country "Country"
from music.bands b
join music.bands_countries bc 
  on b.id_band = bc.id_band 
join geo.countries cou
  on bc.id_country = cou.id_country 
join geo.countries_continents cc
  on cc.id_country = cou.id_country
join geo.continents con 
  on con.id_continent = cc.id_continent
join music.bands_generes bg 
  on b.id_band = bg.id_band 
join music.generes g 
  on bg.id_genere = g.id_genere 
where con.continent = 'Europe'
and g.genere in (
  'Death Metal', 
  'Thrash Metal', 
  'Speed Metal', 
  'Black Metal',
  'Melodic Death Metal',
  'Groove Metal',
  'Viking Metal',
  'Ambient',
  'Blackened Death Metal',
  'Avant-garde Black Metal',
  'Melodic Thrash Metal',
  'Melodic Black Metal',
  'Viking Black Metal',
  'Pagan Black Metal',
  'Ambient Post-Black Metal',
  'Pagan Metal',
  'Blackened Thrash Metal',
  'Atmospheric Black Metal'
  )
  and active
  order by "Country", "Band";
 





select 
  distinct
  b.band,
  e."event",
  count(*) quantity
from music.bands b
join music.bands_events be 
  on be.id_band = b.id_band 
join music.events e 
  on be.id_event = e.id_event
group by cube(b.band, e."event")
order by e."event", b.band;

refresh materialized view music.mv_musical_info;



select distinct band, likes, country from music.mv_musical_info mmi;

select distinct "event", price from music.mv_musical_info mmi;

select sum(price) from
  (select distinct "event", price from music.mv_musical_info mmi) t;

select md5(lower(band)) new_id, id_band, lower(regexp_replace(band, '\s|\W', '', 'g')) for_id,  band from music.bands order by band ;
 
select count(distinct(lower(regexp_replace(band, '\s|\W', '', 'g')))) from music.bands;


select count(distinct (lower(regexp_replace(genere, '\s|\W', '', 'g')))) from music.generes g;
