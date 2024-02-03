
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


--insert into geo.places values (md5(''), '');

-- New events
select music.insert_events('Dread Reaver Europe 2024', '2024.01.20', 'Heidelberg (halle 02)', 0);


-- Bands on events
select music.insert_bands_on_events('Abbath', 'Dread Reaver Europe 2024');
select music.insert_bands_on_events('Toxic Holocaust', 'Dread Reaver Europe 2024');
select music.insert_bands_on_events('Hellripper', 'Dread Reaver Europe 2024');


-- Bands countries
select music.insert_bands_on_countries('Toxic Holocaust', 'USA');
select music.insert_bands_on_countries('Abbath', 'Norway');

-- Bands generes
select music.insert_bands_to_generes('Toxic Holocaust', 'Black Metal');
select music.insert_bands_to_generes('Toxic Holocaust', 'Speed Metal');
select music.insert_bands_to_generes('Toxic Holocaust', 'Thrash Metal');
select music.insert_bands_to_generes('Abbath', 'Black Metal');