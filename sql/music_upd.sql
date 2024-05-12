/*
insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/

-- 34.00 Dying Fetus



-- New events
select music.insert_events('"The Tide of Death and fractured Dreams" European Tour 2024', '2024.05.15', 'Wiesbaden (Schlachthof)', 0, 36.0, 2);


-- Bands on events
select music.insert_bands_on_events('Ingested', '"The Tide of Death and fractured Dreams" European Tour 2024');
select music.insert_bands_on_events('Fallujah', '"The Tide of Death and fractured Dreams" European Tour 2024');
select music.insert_bands_on_events('Vulvodynia', '"The Tide of Death and fractured Dreams" European Tour 2024');
select music.insert_bands_on_events('Mélancholia', '"The Tide of Death and fractured Dreams" European Tour 2024');

-- Bands countries
select music.insert_bands_on_countries('Fallujah', 'United States of America');
select music.insert_bands_on_countries('Vulvodynia', 'South Africa');
select music.insert_bands_on_countries('Mélancholia', 'Australia');


-- Bands generes
select music.insert_bands_to_generes('Fallujah', 'Deathcore');
select music.insert_bands_to_generes('Fallujah', 'Progressive Death Metal');
select music.insert_bands_to_generes('Fallujah', 'Technical Death Metal');
select music.insert_bands_to_generes('Vulvodynia', 'Deathcore');
select music.insert_bands_to_generes('Vulvodynia', 'Brutal Death Metal');
select music.insert_bands_to_generes('Mélancholia', 'Deathcore');