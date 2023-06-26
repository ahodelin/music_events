/*
insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('', '2023.07.0', '', 1);

-- Bands on events
select music.insert_bands_on_events('', '');

-- Bands countries
select music.insert_bands_on_countries('', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('', ' Metal');
select music.insert_bands_to_generes('', ' Metal');