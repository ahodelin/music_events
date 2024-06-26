-- New events
-- DROP FUNCTION music.insert_events(varchar, date, varchar, int2, numeric, int2);

CREATE OR REPLACE FUNCTION music.insert_events(
  eve character varying, 
  dat date, 
  plac character varying, 
  dur int2, 
  pri numeric, 
  per int2)
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

-- Bands on events
create or replace function music.insert_bands_on_events(
  ban varchar,
  eve varchar 
  )
returns text 
as $$ 
declare 
  i_band varchar;
  i_e varchar;
begin 
	
  select id_band, id_event into i_band, i_e
  from music.bands_events be 
  where id_band = md5(ban) and id_event = md5(eve) for update;
 
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
  	  values (md5(ban), ban, 'y');
    end if;
  
    insert into music.bands_events
    values (md5(ban), md5(eve));
    return 'Band - Event inserted';
  end if;
  
end;
$$ language plpgsql;


-- Bands on contries
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
  where id_band = md5(ban) and id_country = countr for update;
 
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
  	  values (md5(ban), ban, 'y');
    end if; 
  
    insert into music.bands_countries
    values(md5(ban), countr);
    return 'Band - County added'; 
   
  end if;
	  
end;
$function$
;

-- Bands plays generes
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
  where id_band = md5(ban) and id_genere = md5(gene) for update;
  
  if found then
    return 'This combination of band and genere exist';
  else
  
    select id_genere into i_gene 
    from music.generes g
    where genere = gene for update;
 
    if not found then    
      insert into music.generes
  	  values (md5(gene), gene);
    end if;
	
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(ban), ban, 'y');
    end if;
  
    insert into music.bands_generes
    values(md5(ban), md5(gene));
    return 'Band - Genere added';
    
  end if;  
end;
$function$
;
