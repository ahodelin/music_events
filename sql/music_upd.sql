insert into geo.countries 
  values 
    (md5(''), '', '');

   
-- New events
select music.insert_events('', '2023.03.', '', 0);

-- Bands on events
select music.insert_bands_on_events('', '');

-- Bands countries
select music.insert_bands_on_countries('', ''); 

-- Bands generes
select music.insert_bands_to_generes('', '');
