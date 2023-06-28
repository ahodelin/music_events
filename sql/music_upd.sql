/*
insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('Rumble of thunder', '2023.06.27', 'Frankfurt am Main (Batschkapp)', 1);

-- Bands on events


select music.insert_bands_on_events('The Hu', 'Rumble of thunder');
select music.insert_bands_on_events('Gunnar', 'Rumble of thunder');
select music.insert_bands_on_events('', 'Rumble of thunder');

-- Bands countries
select music.insert_bands_on_countries('Gunnar', '');
select music.insert_bands_on_countries('', '');

-- Bands generes
select music.insert_bands_to_generes('Gunnar', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');