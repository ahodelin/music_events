-- New events
create or replace function music.insert_events(
  eve varchar, 
  dat date, 
  plac varchar)
returns text 
as $$ 
declare 
  i_p varchar;
  i_e varchar;
begin 
  select id_place into i_p
  from geo.places
  where place = plac for update ;
 
  if not found then
  	insert into geo.places
  	values (md5(plac), plac);
  end if;
 
  select id_event into i_e 
  from music.events e 
  where "event" = eve for update;
 
  if not found then
    insert into music.events
    values (md5(eve), eve, dat, md5(plac));
    return 'Added event';
  else return 'Event exist';
  end if;
end;
$$ language plpgsql;

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
  select id_band into i_band
  from music.bands
  where band  = ban for update ;
 
  if not found then
  	insert into music.bands
  	values (md5(ban), ban, 'y');
  end if;
 
  select id_event into i_e 
  from music.events e 
  where "event" = eve for update;
 
  if not found then    
    return 'This event does not exist';
  else 
    insert into music.bands_events
    values (md5(ban), md5(eve));
    return 'Band - Event inserted';
  end if;
end;
$$ language plpgsql;

-- Bands on contries
create or replace function music.insert_bands_on_countries(
  ban varchar,
  countr varchar 
  )
returns text 
as $$ 
declare 
  i_band varchar;
  i_countr varchar;
begin 
	
  select id_country into i_countr 
  from geo.countries c  
  where country = countr for update;
 
  if not found then    
    return 'Please insert this country first';
  end if;
	
  select id_band into i_band
  from music.bands
  where band = ban for update ;
 
  if not found then
  	insert into music.bands
  	values (md5(ban), ban, 'y');
    
    insert into music.bands_countries
    values(md5(ban), md5(countr));
    return 'New band added. Band - County added';
  else
    insert into music.bands_countries
    values(md5(ban), md5(countr));
    return 'Band - Country added';
  end if;
end;
$$ language plpgsql;


-- Bands plays generes
create or replace function music.insert_bands_to_generes(
  ban varchar,
  gene varchar 
  )
returns text 
as $$ 
declare 
  i_band varchar;
  i_gene varchar;
begin 
	
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
    
    insert into music.bands_generes
    values(md5(ban), md5(gene));
    return 'New band added. Band - Genere added';
  else
    insert into music.bands_generes
    values(md5(ban), md5(gene));
    return 'Band - Genere added';
  end if;
end;
$$ language plpgsql;
