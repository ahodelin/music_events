
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
-- Ton Steine Scherben - Wiesbaden(Schlachthof) - 01.10.2015
   
-- New events
select music.insert_events('The Path of Death 10', '2023.10.14', 'Mainz (M8 im Haus der Jugend)', 0);

-- Bands on events
select music.insert_bands_on_events('he Path of Death 10', 'Epicedium');
select music.insert_bands_on_events('he Path of Death 10', 'Bösedeath');
select music.insert_bands_on_events('he Path of Death 10', 'Keitzer');
select music.insert_bands_on_events('he Path of Death 10', 'Crescent');
select music.insert_bands_on_events('he Path of Death 10', '');
select music.insert_bands_on_events('he Path of Death 10', '');
select music.insert_bands_on_events('he Path of Death 10', '');

-- Bands countries
select music.insert_bands_on_countries('Epicedium', 'Germany');
select music.insert_bands_on_countries('Crescent', 'Egypt');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');
select music.insert_bands_on_countries('', '');

-- Bands generes
select music.insert_bands_to_generes('Epicedium', 'Brutal Death Metal');
select music.insert_bands_to_generes('Crescent', 'Blackened Death Metal');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');