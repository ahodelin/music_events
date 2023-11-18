
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
   
-- New events

--insert into geo.places values (md5(''), '');

select music.insert_events('European Fall 2023 Tour', '2023.11.19', 'Mörlenbach (LIVE MUSIC HALL Weiher)', 0);

-- Bands on events
select music.insert_bands_on_events('Uburen', 'European Fall 2023 Tour');
select music.insert_bands_on_events('Kanonenfieber', 'European Fall 2023 Tour');
select music.insert_bands_on_events('Batushka', 'European Fall 2023 Tour');


-- Bands countries
select music.insert_bands_on_countries('Uburen', 'Norway');
select music.insert_bands_on_countries('Kanonenfieber', 'Germany');


-- Bands generes
select music.insert_bands_to_generes('Uburen', 'Viking Metal');
select music.insert_bands_to_generes('Uburen', 'Black Metal');
select music.insert_bands_to_generes('Kanonenfieber', 'Melodic Black Metal');
select music.insert_bands_to_generes('Kanonenfieber', 'Death Metal');
