
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('', '2023.08.0', 'Dotmund ', 1);

-- Bands on events
select music.insert_bands_on_events('', '');


-- Bands countries
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');

-- Bands generes
select music.insert_bands_to_generes('', ' Metal');
select music.insert_bands_to_generes('', ' Metal');
select music.insert_bands_to_generes('', ' Metal');

update music.bands set likes = 'y' where band = 'Ellende'