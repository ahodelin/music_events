
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

refresh materialized view music.mv_musical_info;

SELECT music.insert_event('Test_Event', '2024-05-25', 'Test_Place', 0, 0.0, 2);

delete from music.events where event = 'Test_Event';
delete from geo.places where place = 'Test_Place'


 DROP FUNCTION music.insert_event(varchar, date, varchar, int2, numeric, int2);

CREATE OR REPLACE FUNCTION music.insert_event(eve character varying, dat date, plac character varying, dur int, pri numeric, per int)
 RETURNS text
 LANGUAGE plpgsql
AS $function$ 
declare 
  i_p varchar;
  i_e varchar;
begin
	
  select id_event into i_e 
  from music.events e 
  where "event" = eve for update;
 
  if not found then
  
    select id_place into i_p
    from geo.places
    where place = plac for update;
   
    if not found then 
      insert into geo.places
  	  values (md5(plac), plac);
  	end if;
  
  	insert into music.events
    values (md5(eve), eve, dat, md5(plac), dur, pri, per);
    return 'Added event';  
  else return 'Event alredy exist';
    
  end if;end;
$function$
;

