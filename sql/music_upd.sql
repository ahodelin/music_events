
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


--insert into geo.places values (md5(''), '');

-- New events
select music.insert_events('2023', '2023.12.28', 'Heidelberg (halle 02)', 0);


-- Bands on events
select music.insert_bands_on_events('Sodom', ' 2023');
select music.insert_bands_on_events('Knife', ' 2023');
select music.insert_bands_on_events('Soulburn', ' 2023');
select music.insert_bands_on_events('', ' 2023');


-- Bands countries
select music.insert_bands_on_countries('', 'Germany');
select music.insert_bands_on_countries('', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('', '');
select music.insert_bands_to_generes('', '');