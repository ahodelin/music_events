
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


--insert into geo.places values (md5('Alzey (Oberhaus)'), 'Alzey (Oberhaus)');

-- New events
select music.insert_events('', '2024.0.', '', 0);


-- Bands on events
select music.insert_bands_on_events('', '');

-- Bands countries
select music.insert_bands_on_countries('', '');

-- Bands generes
select music.insert_bands_to_generes('', ' Metal');