
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('Rockfield 2023', '2023.08.11', '', 2);
--select music.insert_events(' 2023', '2023.08.12', '', 0);

-- Bands on events
select music.insert_bands_on_events('Purify', 'Rockfield 2023');
select music.insert_bands_on_events('Groundville Bastards', 'Rockfield 2023');
select music.insert_bands_on_events('The Killer Apes', 'Rockfield 2023');
select music.insert_bands_on_events('', 'Rockfield 2023');


-- Bands countries
select music.insert_bands_on_countries('Groundville Bastards', 'Germany');
select music.insert_bands_on_countries('The Killer Apes', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Groundville Bastards', '');
select music.insert_bands_to_generes('The Killer Apes', '');
select music.insert_bands_to_generes('', '');