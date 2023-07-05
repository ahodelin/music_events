
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('European Miserere 2023', '2023.07.03', 'Frankfurt (ELFER Club)', 1);

-- Bands on events


select music.insert_bands_on_events('Harlott', 'European Miserere 2023');
select music.insert_bands_on_events('Bloodspot', 'European Miserere 2023');
select music.insert_bands_on_events('Witchkrieg', 'European Miserere 2023');

-- Bands countries
select music.insert_bands_on_countries('Harlott', 'Australia');
select music.insert_bands_on_countries('Witchkrieg', 'Germany');


-- Bands generes
select music.insert_bands_to_generes('Witchkrieg', 'Thrash Metal');
select music.insert_bands_to_generes('Harlott', 'Thrash Metal');

