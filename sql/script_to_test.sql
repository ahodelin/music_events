select * from geo.countries c limit 1;
insert into geo.countries values('TCO', 'Test Country', 'tc');

select music.insert_event('Test Event1', '2024.06.13', 'Test Place', 1::int2, 29.30, 2::int2);


-- Bands on events
select music.insert_bands_on_events('Test Band', 'Test Event1'); --

select music.insert_bands_on_countries('Test Band', 'TCO');

select music.insert_bands_to_genres('Test Band', 'Test Genre');

delete from geo.countries where id_country = 'TCO';
delete from music.bands where band = 'Test Band';





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



select count(distinct(lower(regexp_replace("event", '\s|\W', '', 'g')))) from music.events; 


select count(distinct (lower(regexp_replace(genere, '\s|\W', '', 'g')))) from music.generes g;





-- DROP FUNCTION music.insert_bands_on_countries(varchar, varchar);

CREATE OR REPLACE FUNCTION music.insert_bands_on_countries(ban character varying, countr character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$ 
declare 
  i_band varchar;
  i_countr varchar;
begin 
	
  select id_band, id_country into i_band, i_countr
  from music.bands_countries bc
  where id_band = md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))) and id_country = countr for update;
 
  if found then
    return 'This combination of band and country exist';
  else
	 
    select id_country into i_countr 
    from geo.countries c  
    where id_country = countr for update;
 
    if not found then    
      return 'Please insert this country first';
    end if;
   
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), ban, 'y');
    end if; 
  
    insert into music.bands_countries
    values(md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), countr);
    return 'Band - County added'; 
   
  end if;
	  
end;
$function$
;


-- DROP FUNCTION music.insert_bands_on_events(varchar, varchar);

CREATE OR REPLACE FUNCTION music.insert_bands_on_events(ban character varying, eve character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$ 
declare 
  i_band varchar;
  i_e varchar;
begin 
	
  select id_band, id_event into i_band, i_e
  from music.bands_events be 
  where id_band = md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))) and id_event = md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))) for update;
 
 if found then
   return 'This combination Band - Event exist.';
 end if;
 
  select id_event into i_e 
  from music.events e 
  where "event" = eve for update;
 
  if not found then    
    return 'This event does not exist';
  else 
    select id_band into i_band
    from music.bands
    where band  = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), ban, 'y');
  	 
  	  insert into music.bands_events
      values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))));
     
      return 'New Band - Event inserted';
     
    else
      insert into music.bands_events
      values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))));
     
      return 'Band - Event inserted';  
    end if;
  end if;
end;
$function$
;


-- DROP FUNCTION music.insert_bands_to_genres(varchar, varchar);

CREATE OR REPLACE FUNCTION music.insert_bands_to_genres(ban character varying, gene character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$ 
declare 
  i_band varchar;
  i_gene varchar;
begin 
	
  select id_genere, id_band into i_gene, i_band
  from music.bands_generes bg 
  where id_band = md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))) and id_genere = md5(lower(regexp_replace(gene, '\s|\W', '', 'g'))) for update;
  
  if found then
    return 'This combination of band and genere exist';
  else
  
    select id_genere into i_gene 
    from music.generes g
    where genere = gene for update;
 
    if not found then    
      insert into music.generes
  	  values (md5(lower(regexp_replace(gene, '\s|\W', '', 'g'))), gene);
    end if;
	
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), ban, 'y');
    end if;
  
    insert into music.bands_generes
    values(md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), md5(lower(regexp_replace(gene, '\s|\W', '', 'g'))));
    return 'Band - Genere added';
    
  end if;  
end;
$function$
;


select md5(lower(regexp_replace(band, '\s|\W', '', 'g'))) from music.bands b;

update geo.places 
set id_place = md5(lower(regexp_replace(place , '\s|\W', '', 'g')));


alter table music.events 
drop constraint events_id_place_fkey,
add constraint events_id_place_fkey
foreign key (id_place) references geo.places(id_place) on update cascade;



-- DROP FUNCTION music.insert_event(varchar, date, varchar, int2, numeric, int2);

CREATE OR REPLACE FUNCTION music.insert_event(eve character varying, dat date, plac character varying, dur smallint, pri numeric, per smallint)
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
  	  values (md5(lower(regexp_replace(plac, '\s|\W', '', 'g'))), plac);
  	end if;
  
  	insert into music.events
    values (md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))), eve, dat, md5(lower(regexp_replace(plac, '\s|\W', '', 'g'))), dur, pri, per);
    return 'Added event';  
  else return 'Event alredy exist';
    
  end if;end;
$function$
;






