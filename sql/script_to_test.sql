

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
 
copy
(
 select * from music.v_eu_to_metalembrace
) to '/var/lib/postgresql/Death_Black_Speed_Europe_to_Excel.csv' with delimiter E';' csv header;
 


-- music.v_bands_to_tex source

select "event"  from music.events e
where date_part('year', date_event) = 2018; 

select * from music.bands b where id_band not in (select id_band from music.v_bands vb);

select 'Punk''n''Roll' into test_name;
select * from test_name;
drop table test_name;
select * from test;
drop table test;


alter table music.bands 
add column active boolean default true;

alter table music.bands 
add column note varchar;


update music.bands 
set active = false where band in ('');


select distinct band, likes from music.bands b 
join music.bands_generes bg 
  on b.id_band = bg.id_band 
where likes = 'y'
and active
and bg.id_genere = 'caac3244eefed8cffee878acae427e28'; -- Deathcore

select * from music.bands b where band = 'Knife';



copy (select row_to_json(t)|| ',' from music.bands_countries t) to 'testing.json';

select * from music.v_eu_metalembrace_to_tex 

/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


-- music.v_bands_to_tex source

CREATE OR REPLACE VIEW music.v_bands_to_tex
AS 
SELECT
        CASE
            WHEN vb.band::text ~* 'Apey|Booze|Nordic'::text THEN regexp_replace(vb.band::text, '\&'::text, '\\&'::text)::character varying
            WHEN vb.band::text ~* 'Auðn'::text THEN regexp_replace(vb.band::text, 'ð'::text, '\\dh '::text)::character varying
            ELSE vb.band
        END AS "Gruppe",
    (' & \includegraphics[width=1cm]{../4x3/'::text || vb.flag::text) || '} & '::text AS "Land",
    (('\includegraphics[width=1cm]{'::text || '../likes/'::text) || vb.likes::text) || '} \\ \hline'::text AS "Farbe"
   FROM music.v_bands vb;
   
 -- music.v_events source

-- music.v_events_mod source

CREATE OR REPLACE VIEW music.v_events_mod
AS SELECT date_part('year'::text, e.date_event) AS year,
    (((
        CASE
            WHEN date_part('day'::text, e.date_event) < 10::double precision THEN '0'::text || date_part('day'::text, e.date_event)::text
            ELSE date_part('day'::text, e.date_event)::text
        END || '.'::text) ||
        CASE
            WHEN date_part('month'::text, e.date_event) < 10::double precision THEN '0'::text || date_part('month'::text, e.date_event)::text
            ELSE date_part('month'::text, e.date_event)::text
        END) || '.'::text) || date_part('year'::text, e.date_event) AS date,
    e.event,
    p.place,
    count(DISTINCT be.id_band) AS bands,
    e.duration + 1 AS days
   FROM music.events e
     JOIN geo.places p ON p.id_place = e.id_place
     JOIN music.bands_events be ON be.id_event = e.id_event
  GROUP BY e.event, p.place, e.date_event, e.id_event
  ORDER BY e.date_event;
  -- music.v_generes source

select 
  b.band,
  c.country country_of_band,
  b.likes,
  e."event",
  date_part('year'::text, e.date_event) AS year_of_event,
  date_part('year'::text, e.date_event) || '-'|| extract(quarter from e.date_event) quarter_of_event,
    (((
        CASE
            WHEN date_part('day'::text, e.date_event) < 10::double precision THEN '0'::text || date_part('day'::text, e.date_event)::text
            ELSE date_part('day'::text, e.date_event)::text
        END || '.'::text) ||
        CASE
            WHEN date_part('month'::text, e.date_event) < 10::double precision THEN '0'::text || date_part('month'::text, e.date_event)::text
            ELSE date_part('month'::text, e.date_event)::text
        END) || '.'::text) || date_part('year'::text, e.date_event) AS date_of_event,
  e.duration + 1 days_of_event,
  e.price price_one_ticket,
  e.persons,
  e.price * e.persons price_event --,
  --sum(e.price * e.persons) cost_events,
  --count(b.band) viewed_bands
from music.bands b
join music.bands_events be 
  on be.id_band = b.id_band 
join music.events e 
  on be.id_event = e.id_event
join music.bands_countries bc 
  on bc.id_band = b.id_band 
join geo.countries c 
  on c.id_country = bc.id_country
where date_part('year', e.date_event) = 2024 
--group by cube(b.band, country_of_band, likes, e."event", e.date_event, year_of_event, quarter_of_event, days_of_event, price_one_ticket, e.persons, price_event)
order by band, e.date_event;



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

alter table music.events 
alter column persons type int2,
alter column duration type int2;

-- music.v_events_mod source
drop view music.v_events_mod ;

CREATE OR REPLACE VIEW music.v_events_mod
AS SELECT date_part('year'::text, e.date_event) AS year,
    (((
        CASE
            WHEN date_part('day'::text, e.date_event) < 10::double precision THEN '0'::text || date_part('day'::text, e.date_event)::text
            ELSE date_part('day'::text, e.date_event)::text
        END || '.'::text) ||
        CASE
            WHEN date_part('month'::text, e.date_event) < 10::double precision THEN '0'::text || date_part('month'::text, e.date_event)::text
            ELSE date_part('month'::text, e.date_event)::text
        END) || '.'::text) || date_part('year'::text, e.date_event) AS date,
    e.event,
    p.place,
    count(DISTINCT be.id_band) AS bands,
    e.duration + 1 AS days
   FROM music.events e
     JOIN geo.places p ON p.id_place = e.id_place
     JOIN music.bands_events be ON be.id_event = e.id_event
  GROUP BY e.event, p.place, e.date_event, e.id_event
  ORDER BY e.date_event;


